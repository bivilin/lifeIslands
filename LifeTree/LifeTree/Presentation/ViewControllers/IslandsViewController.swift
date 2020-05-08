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
    var mainCameraNode = SCNNode()
    var mainCamera = SCNCamera()
    var secundaryCameraNode = SCNNode()
    var isMainCamera = true

    // Handle pan camera
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0
    var widthRatio: Float = 0
    var heightRatio: Float = 0
    var fingersNeededToPan = 1
    var maxHeightRatioXDown: Float = -0.22
    var maxHeightRatioXUp: Float = 0

    // Handle pinch camera
    var pinchAttenuation: Double = 40  //1.0: very fast - 100.0 slow
    let maxCameraDistanceFromCenter: Float = 20
    let minCameraDistanceFromCenter: Float = 2
    var lastFingersNumber: Int = 0

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up SCNScene background
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

        // Add a tap gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.islandsSCNView.addGestureRecognizer(panGesture)

        // Add a pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.islandsSCNView.addGestureRecognizer(pinchGesture)

        // Gesture - Tap
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(IslandsViewController.handleTap(rec:)))
        self.view.addGestureRecognizer(tapRec)
    }
    
    // MARK: Gestures
    
    // Pan
    @objc func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {

        let numberOfTouches = gestureRecognize.numberOfTouches
        let translation = gestureRecognize.translation(in: gestureRecognize.view!)

        if (numberOfTouches == fingersNeededToPan) {

            // Horizontal displacement relative to screen size
            widthRatio = Float(translation.x) / Float(gestureRecognize.view!.frame.size.width) + self.lastWidthRatio
            
            // Rotate camera horizontally
            self.cameraOrbit.eulerAngles.y = -2 * .pi * widthRatio/2
            
            if self.isMainCamera {
                // Vertical displacement relative to screen size
                heightRatio = Float(translation.y) / Float(gestureRecognize.view!.frame.size.height) + self.lastHeightRatio
                
                //  Apply height constraints
                if (heightRatio >= self.maxHeightRatioXUp ) {
                    heightRatio = self.maxHeightRatioXUp
                }
                if (heightRatio <= self.maxHeightRatioXDown ) {
                    heightRatio = self.maxHeightRatioXDown
                }
                
                // Rotates camera vertically
                self.cameraOrbit.eulerAngles.x = -.pi * heightRatio/2
                
                // Rotate the position camera orbit for a more dynamic movement
                self.cameraOrbit.position.x += 0.01 * cos(-.pi * heightRatio/2)
                self.cameraOrbit.position.z += 0.01 * sin(-.pi * heightRatio/2)
                
                // Prohibits the camera orbit to diverge too much from center
                let maximumDisplacement: Float = 0.1
                if self.cameraOrbit.position.x > maximumDisplacement {
                    self.cameraOrbit.position.x = maximumDisplacement
                }
                if cameraOrbit.position.z > maximumDisplacement {
                    self.cameraOrbit.position.z = maximumDisplacement
                }
            }
            
            // Final check on fingers number
            lastFingersNumber = self.fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches > 0 ? numberOfTouches : lastFingersNumber)
        
        // Update variables at the end of the gesture
        if (gestureRecognize.state == .ended && lastFingersNumber == self.fingersNeededToPan) {
            
            self.lastWidthRatio = self.widthRatio
            if self.isMainCamera {
                self.lastHeightRatio = self.heightRatio
            }
        }
    }
    
    // Pinch
    @objc func handlePinch(_ gestureRecognize: UIPinchGestureRecognizer) {
        
        // Zoom only allowed when main camera is on
        if self.isMainCamera {
            let vectorServices = VectorServices()
            
            // Calculate zoom factor
            let pinchVelocity = Double.init(gestureRecognize.velocity)
            let zoomFactor = 1 - pinchVelocity/self.pinchAttenuation
            
            // Increases camera distance from center by the zoomFactor
            let newPosition = vectorServices.multiplicationByScalar(vector: self.mainCameraNode.position, scalar: Float(zoomFactor))
            
            // Apply change only if the new distance from the center is whithin the boundaries we've set
            let distanceFromCameraOrbit = vectorServices.length(vector: vectorServices.subtraction(vector1: self.cameraOrbit.position, vectorToSubtract: newPosition))
            if distanceFromCameraOrbit < self.maxCameraDistanceFromCenter && distanceFromCameraOrbit > self.minCameraDistanceFromCenter {
                self.mainCameraNode.position = newPosition
            }
        }
    }
    
    // Tap
    @objc func handleTap(rec: UITapGestureRecognizer){
        print("tap")
        if rec.state == .ended {
            // Make hit test for the tap
            let location: CGPoint = rec.location(in: islandsSCNView)
            let hits = self.islandsSCNView.hitTest(location, options: nil)
            
            // Get node from hit test
            if let tappednode = hits.first?.node {
                print(tappednode)
                
                // Moves camera to better show the island which was tapped
                self.moveCameraToPeripheralIsland(islandNode: tappednode)
                
                // Get island information from CoreData
                let islandObject = self.islandsVisualizationServices?.getIslandfromNode(inputNode: tappednode)
                if let name = islandObject?.name {
                    print(name)
                }
                if islandObject == nil, let tappedName = tappednode.name {
                    print(tappedName)
                }
            }
        }
    }
    
    // MARK: Helpers
    
    func moveCameraToPeripheralIsland(islandNode: SCNNode) {
        
        // Return cameraOrbit node to center of scene
        self.cameraOrbit.position.x = 0
        self.cameraOrbit.position.y = 0
        
        // Set euler angles of cameraOrbit based on the islandNode's position
        self.cameraOrbit.eulerAngles.x = 0
        let tanOfIslandAngle = islandNode.position.x/islandNode.position.z
        self.cameraOrbit.eulerAngles.y = atan(tanOfIslandAngle)
        
        // Places main camera in front of the selected islandNode
        let vectorServices = VectorServices()
        let cameraPositionUnitVector = vectorServices.normalize(vector: self.mainCameraNode.position)
        self.mainCameraNode.position = vectorServices.multiplicationByScalar(vector: cameraPositionUnitVector, scalar: Float((self.islandsVisualizationServices!.radius + 2)))
        
        // Set secundaryCamera as pointOfView so that we have better vision of a single island
        self.islandsSCNView.pointOfView = self.secundaryCameraNode
        self.isMainCamera = false
    }
    
    func setUpCamera() {
        
        if let camOrbit = self.islandsSCNScene.rootNode.childNode(withName: "cameraOrbit", recursively: true) {
            self.cameraOrbit = camOrbit
            print("cameraOrbit is set")
            
            if let camNode = self.cameraOrbit.childNode(withName: "camera", recursively: true) {
                self.mainCameraNode = camNode
                print("cameraNode is set")
                
                if let cam = self.mainCameraNode.camera {
                    self.mainCamera = cam
                    print("camera is set")
                }
                if let cam2 = self.mainCameraNode.childNode(withName: "secundaryCamera", recursively: true) {
                    self.secundaryCameraNode = cam2
                    print("secundaryCameraNode is set")
                }
            }
        }
        self.mainCamera.zNear = 1.5
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
