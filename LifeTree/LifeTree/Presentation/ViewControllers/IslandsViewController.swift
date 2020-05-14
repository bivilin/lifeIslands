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

class IslandsViewController: UIViewController{
    
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
    let vectorServices = VectorServices()

    // Card Properties
    var floatingPanel: FloatingPanelController!
    var peripheralCardView: PeripheralCardViewController!
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
    var panDirection: PanDirection = .unknown
    var hasReachedVerticalLimit = false
    var isSelfIslandVisualization = true
    var peripheralIslandInCard: SCNNode? = nil
    var minHeight: Float = -10 // to be updated in setUpCameras function
    var maxHeight: Float = 10 // to be updated in setUpCameras function
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up SCNScene background
        islandsSCNScene.background.contents = UIImage(named: "background")
        
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
        peripheralCardView = storyboard?.instantiateViewController(withIdentifier: "PeripheralCard") as? PeripheralCardViewController
        showFloatingPanel()
        
        // Add self islando do scene
        self.islandsVisualizationServices!.addSelfIslandToScene(islandsSCNScene: islandsSCNScene)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        // Configures camera
        self.setUpCameras()

        // Add a pan gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.islandsSCNView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Gestures
    
    // Pan
    // Rotates camera around center in the SCNScene
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            self.hasReachedVerticalLimit = false
        }
        
        if gesture.numberOfTouches == 1 {
            
            // Get horizontal and vertical displacement relative to screen size
            let translation = gesture.translation(in: gesture.view!)
            self.widthRatio = Float(translation.x) / Float(gesture.view!.frame.size.width) + self.lastWidthRatio
            self.heightRatio = Float(translation.y) / Float(gesture.view!.frame.size.height)
            
            // Get pan direction
            let error: CGFloat = 0.01
            if self.panDirection == .unknown && abs(translation.x) > error && abs(translation.y) > error {
                self.panDirection = (abs(translation.y) + 0.01 > abs(translation.x)) ? .vertical : .horizontal
            }
            
            // colocar a camera definitivamente em alguma das posições
            
            if self.panDirection == .vertical && !self.hasReachedVerticalLimit {
                
                // Vertical displacement of camera
                let newCameraOrbitYPosition = self.cameraOrbit.position.y + 50 * (self.heightRatio - self.lastHeightRatio)
                
                if !(newCameraOrbitYPosition > self.maxHeight) && !(newCameraOrbitYPosition < self.minHeight) {
                    self.cameraOrbit.position.y = newCameraOrbitYPosition
                    self.lastHeightRatio = self.heightRatio
                }
                else if !self.hasReachedVerticalLimit {
                    
                    if !(newCameraOrbitYPosition < self.maxHeight) {
                        self.cameraOrbit.position.y = self.maxHeight
                    }
                    else if !(newCameraOrbitYPosition > self.minHeight) {
                        self.cameraOrbit.position.y = self.minHeight
                    }
                    
                    // Gives hapitic feedback when user reaches the camera limit
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    self.hasReachedVerticalLimit = true
                }
                
                let midpoint = (self.maxHeight + self.minHeight)/2
                
                if self.cameraOrbit.position.y > midpoint {
                    self.setCardForNode(node: self.islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true)!)
                    
                    if self.isSelfIslandVisualization == false {
                        self.isSelfIslandVisualization = true
                    }
                }
                else {
                    if self.isSelfIslandVisualization == true {
                        self.isSelfIslandVisualization = false
                    }
                }
                
            }
            else if self.panDirection == .horizontal && !self.isSelfIslandVisualization {
                // Rotate camera horizontally
                
                self.displayClosestIslandNodeInCard()
                self.cameraOrbit.eulerAngles.y = -.pi * widthRatio
            }
        }
        
        // Update variables at the end of the gesture
        if gesture.state == .ended {
            self.lastWidthRatio = self.cameraOrbit.eulerAngles.y/(-.pi)
            self.lastHeightRatio = 0
            panDirection = .unknown
        }
    }
    
    func displayClosestIslandNodeInCard() {
        
        let centerOfScreen = CGPoint(x: self.islandsSCNView.frame.width/2, y: self.islandsSCNView.frame.height/2)
        let hits = self.islandsSCNView.hitTest(centerOfScreen, options: nil)
        
        // Get node from hit test
        if let centerNode = hits.first?.node {
            
            if centerNode != self.peripheralIslandInCard {
                self.peripheralIslandInCard = centerNode
                setCardForNode(node: centerNode)
                
                // Hapitic feedback
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }

    func setCardForNode(node: SCNNode) {
        // Ilhas Periféricas
        // Utiliza o nó para obter o objeto referente àquela ilha
        if let islandObject = self.islandsVisualizationServices?.getIslandfromNode(inputNode: node) {
            // Atualiza as informações da VC
            peripheralCardView.peripheralIsland = islandObject
            // Atualiza o conteúdo do Floating Panel para a nova VC
            floatingPanel.set(contentViewController: peripheralCardView)
        } else {
            // Ilha Central
            // Solução temporária
            floatingPanel.set(contentViewController: cardView)
        }
    }
    
    // MARK: Camera Helpers
    
    // Get number sign
    func sign(_ number: Float) -> Float  {
        return number < 0 ? -1 : 1
    }
    
    // Instantiate the cameras from the .scn files
    func setUpCameras() {
        
        if let camOrbit = self.islandsSCNScene.rootNode.childNode(withName: "cameraOrbit", recursively: true) {
            self.cameraOrbit = camOrbit
            self.maxHeight = self.cameraOrbit.position.y
            self.minHeight = self.maxHeight + Float(self.islandsVisualizationServices!.yPositionForPeripheralIsland) + Float(self.islandsVisualizationServices!.planeLength/4) // second term (yPositionForPeripheralIsland) is already negative
            
            if let camNode = self.cameraOrbit.childNode(withName: "camera", recursively: true) {
                self.cameraNode = camNode
                self.islandsSCNView.pointOfView = self.cameraNode
                
                // Put constraint so that main camera is always facing the center of its orbit
                let constraint = SCNLookAtConstraint(target: self.cameraOrbit)
                self.cameraNode.constraints = [constraint]
                
                if let cam = self.cameraNode.camera {
                    self.camera = cam
                    self.camera.zNear = 1.5
                    self.camera.focusDistance = 5
                }
            }
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

extension IslandsViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
         return FloatingPanelCardLayout()
    }

    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FloatingPanelCardBehavior()
    }
}
