//
//  AllIslandsViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import FloatingPanel

class IslandsViewController: UIViewController, FloatingPanelControllerDelegate{
    
    @IBOutlet weak var islandsSCNView: SCNView!
    
    // MARK: Variables
    
    // Set up the 3D scene for the islands
    let islandsSCNScene = SCNScene(named: "AllIslandsScene.scn")!
    
    // Self Island Properties
    var islandModelSKScene: SKScene = SKScene(fileNamed: "IslandSpriteScene.sks")!
    var selfIsland: SelfIsland?

    // Services
    var infoHandler: InformationHandler?
    var islandsVisualizationServices: IslandsVisualisationServices? = nil
    // Dictionary with key being the id of the island, and value its corresponding SceneKit plane node
    var islandDictionary: [String: SCNNode] = [:]

    // Card Properties
    var floatingPanel: FloatingPanelController!
    var cardView: CardViewController!
    
    // Camera
    var cameraOrbit = SCNNode()
    var cameraNode = SCNNode()
    var camera = SCNCamera()

    // Handle pan camera
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0
    var widthRatio: Float = 0
    var heightRatio: Float = 0
    var fingersNeededToPan = 1
    var maxHeightRatioXDown: Float = -0.2
    var maxHeightRatioXUp: Float = 0

    // Handle pinch camera
    var pinchAttenuation: Double = 50  //1.0: very fast - 200.0 very slow
    let maxCameraDistanceFromCenter: Float = 20
    let minCameraDistanceFromCenter: Float = 2
    var lastFingersNumber: Int = 0

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up SCNScene
        islandsSCNScene.background.contents = UIImage(named: "backgroundSky")
        
        // Set up model for islands SKScene
        self.islandModelSKScene.isPaused = false
        self.islandModelSKScene.scaleMode = .aspectFit
        
        // Initializes island Services class with our SCNScene
        self.islandsVisualizationServices = IslandsVisualisationServices(scnScene: islandsSCNScene)

        // Inicializando classe que maneja os dados
        self.infoHandler = InformationHandler(sceneServices: islandsVisualizationServices!)

        // Show Card
        setupFloatingPanel()
        cardView = storyboard?.instantiateViewController(withIdentifier: "Card") as? CardViewController
        showFloatingPanel()
        
        // Add self islando do scene
        self.islandsVisualizationServices!.addSelfIslandToScene(islandsSCNScene: islandsSCNScene)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        // Configures camera
        self.setUpCamera()

        // add a tap gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.islandsSCNView.addGestureRecognizer(panGesture)

        // add a pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.islandsSCNView.addGestureRecognizer(pinchGesture)
    }

    // MARK: Helpers
    
    func setUpCamera() {
        
        if let camOrbit = self.islandsSCNScene.rootNode.childNode(withName: "cameraOrbit", recursively: true) {
            self.cameraOrbit = camOrbit
            print("cameraOrbit is set")
            if let camNode = self.cameraOrbit.childNode(withName: "camera", recursively: true) {
                self.cameraNode = camNode
                print("cameraNode is set")
                if let cam = self.cameraNode.camera {
                    self.camera = cam
                    print("camera is set")
                }
            }
        }
        self.camera.zNear = 1
    }
    
    // MARK: Gestures
    
    @objc func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {

        let numberOfTouches = gestureRecognize.numberOfTouches

        let translation = gestureRecognize.translation(in: gestureRecognize.view!)

        if (numberOfTouches==fingersNeededToPan) {

           widthRatio = Float(translation.x) / Float(gestureRecognize.view!.frame.size.width) + lastWidthRatio
           heightRatio = Float(translation.y) / Float(gestureRecognize.view!.frame.size.height) + lastHeightRatio

            //  Height constraints
            if (heightRatio >= maxHeightRatioXUp ) {
                heightRatio = maxHeightRatioXUp
            }
            if (heightRatio <= maxHeightRatioXDown ) {
                heightRatio = maxHeightRatioXDown
            }

            self.cameraOrbit.eulerAngles.y = -2 * .pi * widthRatio/2
            self.cameraOrbit.eulerAngles.x = -.pi * heightRatio/2
            
            self.cameraOrbit.position.x += 0.01 * cos(-.pi * heightRatio/2)
            self.cameraOrbit.position.z += 0.01 * sin(-.pi * heightRatio/2)
            
            let maximumDisplacement: Float = 0.1
            if cameraOrbit.position.x > maximumDisplacement {
                self.cameraOrbit.position.x = maximumDisplacement
            }
            if cameraOrbit.position.z > maximumDisplacement {
                self.cameraOrbit.position.z = maximumDisplacement
            }
            
            // Final check on fingers number
            lastFingersNumber = fingersNeededToPan
        }

        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)

        if (gestureRecognize.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = widthRatio
            lastHeightRatio = heightRatio
        }
    }
    
    @objc func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {
        
        let pinchVelocity = Double.init(gestureRecognize.velocity)
        let zoomFactor = 1 - pinchVelocity/pinchAttenuation
        
        let vectorServices = VectorServices()
        let newPosition = vectorServices.multiplicationByScalar(vector: self.cameraNode.position, scalar: Float(zoomFactor))
        let distanceFromCameraOrbit = vectorServices.length(vector: vectorServices.subtraction(vector1: self.cameraOrbit.position, vectorToSubtract: newPosition))
        
        if distanceFromCameraOrbit < self.maxCameraDistanceFromCenter && distanceFromCameraOrbit > self.minCameraDistanceFromCenter {
            self.cameraNode.position = newPosition
        }
    }
    
// MARK: FloatingPanel - Card

    func setupFloatingPanel() {

        // InitializeFloatingPanelController
        floatingPanel = FloatingPanelController()
        floatingPanel.delegate = self

        // Initialize FloatingPanelController and add the view
        floatingPanel.surfaceView.backgroundColor = UIColor(displayP3Red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        floatingPanel.surfaceView.cornerRadius = 24.0
        floatingPanel.surfaceView.shadowHidden = false
        floatingPanel.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        floatingPanel.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
    }

    func showFloatingPanel() {
        // Set a content view controller
        floatingPanel.set(contentViewController: cardView)
        floatingPanel.addPanel(toParent: self, animated: false)
    }

}
