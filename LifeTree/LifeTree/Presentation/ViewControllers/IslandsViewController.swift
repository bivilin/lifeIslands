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
    var cameraNode: SCNNode? = nil
    
    // Handle pan camera
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0.2
    var WidthRatio: Float = 0
    var HeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    var maxWidthRatioRight: Float = 0.2
    var maxWidthRatioLeft: Float = -0.2
    var maxHeightRatioXDown: Float = 0.02
    var maxHeightRatioXUp: Float = 0.4

    // Handle pinch camera
    var pinchAttenuation = 20.0  //1.0: very fast ---- 100.0 very slow
    var lastFingersNumber = 0

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up SCNScene
        islandsSCNScene.background.contents = UIImage(named: "backgroundSky")
        setUpCameraControl(sceneView: self.islandsSCNView)
        
        // Set up model for islands SKScene
        self.islandModelSKScene.isPaused = false
        self.islandModelSKScene.scaleMode = .aspectFit
        
        // Initializes island Services class with our SCNScene
        self.islandsVisualizationServices = IslandsVisualisationServices(scnScene: islandsSCNScene)
        self.infoHandler = InformationHandler(sceneServices: islandsVisualizationServices!)
        self.mockData()

        // Show Card
        setupFloatingPanel()
        cardView = storyboard?.instantiateViewController(withIdentifier: "Card") as? CardViewController
        showFloatingPanel()
        
        // Add self islando do scene
        self.islandsVisualizationServices!.addSelfIslandToScene(islandsSCNScene: islandsSCNScene)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        
    }

    // MARK: Helpers

    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Olhar constraints de câmera
        sceneView.allowsCameraControl = true
        // sceneView.cameraControlConfiguration.rotationSensitivity = 0
    }

    // MARK: Debug Buttons

    @IBAction func addPeripheralIsland(_ sender: Any) {
        //self.infoHandler?.addPeripheralIsland(category: "Pessoal", name: "Amigos", healthStatus: 40)
    }

    @IBAction func retrievePeripheralIslands(_ sender: Any) {
        self.infoHandler?.retrievePeripheralIslands(shouldAddToScene: false)
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

    // MARK: Data Handling
    // Preciso passar isso pra outra classe
    // Planejar delegates

    func mockData() {
        self.infoHandler?.createSelf(name: "Meu Mundo", currentHealth: 50)
        self.infoHandler?.retrievePeripheralIslands(shouldAddToScene: true)

        // Uncomment and run for first use on debug
        // self.mockPeripheral()
    }

    // Debug function only to populate CoreData in first use.
    func mockPeripheral() {
        self.infoHandler?.addPeripheralIsland(category: "Trabalho", name: "Trabalho", healthStatus: 90)
        // self.infoHandler?.addPeripheralIsland(category: "Estudos", name: "Faculdade", healthStatus: 55)
        // self.infoHandler?.addPeripheralIsland(category: "Família", name: "Família", healthStatus: 40)
        // self.infoHandler?.addPeripheralIsland(category: "Saúde", name: "Saúde", healthStatus: 70)
    }

}
