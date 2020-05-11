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
        peripheralCardView = storyboard?.instantiateViewController(withIdentifier: "PeripheralCard") as? PeripheralCardViewController
        showFloatingPanel()
        
        // Add self islando do scene
        self.islandsVisualizationServices!.addSelfIslandToScene(islandsSCNScene: islandsSCNScene)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        // Configures camera
        self.instantiateCameras()
        self.mainCamera.zNear = 1.5

        // Add a tap gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.islandsSCNView.addGestureRecognizer(panGesture)

        // Add a pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        self.islandsSCNView.addGestureRecognizer(pinchGesture)

        // Add a single tap gesture recognizer
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        self.islandsSCNView.addGestureRecognizer(singleTap)
        
        // Add a double tap gesture recognizer
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.islandsSCNView.addGestureRecognizer(doubleTap)
    }
    
    // MARK: Gestures
    
    // Pan
    // Rotates camera around center in the SCNScene
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {

        let numberOfTouches = gesture.numberOfTouches
        let translation = gesture.translation(in: gesture.view!)

        if (numberOfTouches == fingersNeededToPan) {

            // Horizontal displacement relative to screen size
            self.widthRatio = Float(translation.x) / Float(gesture.view!.frame.size.width) + self.lastWidthRatio
            
            // Rotate camera horizontally
            self.cameraOrbit.eulerAngles.y = -.pi * widthRatio
            
            if self.isMainCamera {
                
                // Update vertical displacement relative to screen size
                self.heightRatio = Float(translation.y) / Float(gesture.view!.frame.size.height) + self.lastHeightRatio
                // Vertical rotation for the main camera
                self.makeVerticalRotationWithConstraints()
                
                // Moves camera orbit center in circle along with the horizontal rotation for a more organic feel
                self.moveCenterPositionAlongWithRotation()
            }
            
            // Final check on fingers number
            lastFingersNumber = self.fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches > 0 ? numberOfTouches : lastFingersNumber)
        
        // Update variables at the end of the gesture
        if (gesture.state == .ended && lastFingersNumber == self.fingersNeededToPan) {
            self.updateLastWidthAndHeight()
        }
    }
    
    // Pinch
    // Zooms in and out from the center in the SCNScene
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        // Get pinch velocity
        let pinchVelocity = Double.init(gesture.velocity)
        
        // Zoom only allowed when main camera is on
        if self.isMainCamera {
            // Increase/decrease camera distance from center by a zoomFactor
            let zoomFactor = 1 - pinchVelocity/self.pinchAttenuation
            let newPosition = self.vectorServices.multiplicationByScalar(vector: self.mainCameraNode.position, scalar: Float(zoomFactor))
            
            // Apply change only if the new distance from the center is whithin the boundaries we've set
            let distanceFromCameraOrbit = self.vectorServices.length(vector: self.vectorServices.subtraction(vector1: self.cameraOrbit.position, vectorToSubtract: newPosition))
            if distanceFromCameraOrbit < self.maxCameraDistanceFromCenter && distanceFromCameraOrbit > self.minCameraDistanceFromCenter {
                self.mainCameraNode.position = newPosition
            }
        }
        else {
            // Rotate camera horizontally
            self.cameraOrbit.eulerAngles.y += Float(pinchVelocity)*(-1/80)
            
            // Update variables for camera rotation with pan
            if gesture.state == .ended {
                self.updateLastWidthAndHeight()
            }
        }
    }
    
    // Single tap
    // Moves camera to tapped island node and get its information from CoreData
    @objc func handleTap(_ gesture: UITapGestureRecognizer){

        if gesture.state == .ended {
            // Make hit test for the tap
            let location: CGPoint = gesture.location(in: islandsSCNView)
            let hits = self.islandsSCNView.hitTest(location, options: nil)
            
            // Get node from hit test
            if let tappednode = hits.first?.node {
                
                // Zooms into self island
                if self.isMainCamera {
                    if tappednode.position.x == 0 {
                        self.zoomMainCameraIntoSelfIsland()
                    }
                        // Change camera visualization if node tapped is a peripheral island
                    else {
                        // Moves camera to better show the island which was tapped
                        self.zoomSecundaryCameraToPeripheralIsland(islandNode: tappednode)
                        
                        // Update variables for camera rotation with pan
                        if gesture.state == .ended {
                            self.updateLastWidthAndHeight()
                        }
                    }
                }
                
                // Altera conteúdo do card
                setCardForNode(node: tappednode)
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

    
    // Double tap
    // Goes back to the main camera visualization of the SCNScene
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer){
        
        // Position main camera
        let cameraPositionUnitVector = self.vectorServices.normalize(vector: self.mainCameraNode.position)
        self.mainCameraNode.position = self.vectorServices.multiplicationByScalar(vector: cameraPositionUnitVector, scalar: Float((self.islandsVisualizationServices!.radius + 8)))
        
        // Set mainCamera as pointOfView for the scene
        if !self.isMainCamera {
            self.islandsSCNView.pointOfView = self.mainCameraNode
            self.isMainCamera = true
        }
    }
    
    // MARK: Camera Helpers
    
    // Get number sign
    func sign(_ number: Float) -> Float  {
        return number < 0 ? -1 : 1
    }
    
    // Update lastWidthRation and lastHeightRatio to match the eulerAngles of the cameraOrbit
    func updateLastWidthAndHeight() {
        self.lastWidthRatio = self.cameraOrbit.eulerAngles.y/(-.pi)
        self.lastHeightRatio = self.cameraOrbit.eulerAngles.x/(-.pi/2)
    }
    
    // Return cameraOrbit node to center of scene
    func recenterCameraOrbit() {
        self.cameraOrbit.position.x = 0
        self.cameraOrbit.position.y = 0
    }
    
    // Rotate the position camera orbit for a more dynamic camera rotation movement
    func moveCenterPositionAlongWithRotation() {
        self.cameraOrbit.position.x += 0.01 * cos(-.pi * self.widthRatio/4)
        self.cameraOrbit.position.z += 0.01 * sin(-.pi * self.widthRatio/4)
        
        // Prohibits the camera orbit to diverge too much from center
        let maximumDisplacementFromCenter: Float = 0.15
        if abs(self.cameraOrbit.position.x) > maximumDisplacementFromCenter {
            self.cameraOrbit.position.x = self.sign(self.cameraOrbit.position.x) * maximumDisplacementFromCenter
        }
        if abs(self.cameraOrbit.position.z) > maximumDisplacementFromCenter {
            self.cameraOrbit.position.z = self.sign(self.cameraOrbit.position.z) * maximumDisplacementFromCenter
        }
    }
    
    // Rotate camera vertically whithin given constraints
    func makeVerticalRotationWithConstraints() {
        
        //  Apply height constraints
        if (self.heightRatio >= self.maxHeightRatioXUp ) {
            self.heightRatio = self.maxHeightRatioXUp
        }
        if (self.heightRatio <= self.maxHeightRatioXDown ) {
            self.heightRatio = self.maxHeightRatioXDown
        }
        // Rotates camera vertically
        self.cameraOrbit.eulerAngles.x = -.pi * self.heightRatio/2
    }
    
    // Positions main camera zoomed into selfIsland
    func zoomMainCameraIntoSelfIsland() {
        self.recenterCameraOrbit()
        
        self.mainCameraNode.position = self.vectorServices.normalize(vector: self.mainCameraNode.position)
        self.mainCameraNode.position = self.vectorServices.multiplicationByScalar(vector: self.mainCameraNode.position, scalar: 5)
    }
    
    // Set secundary camera as point of view and have it look at a given peripheral island
    func zoomSecundaryCameraToPeripheralIsland(islandNode: SCNNode) {
        self.recenterCameraOrbit()
        
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
    
    // Instantiate the cameras from the .scn files
    func instantiateCameras() {
        
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
