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
    
    // COLOCAR INICIALIZADOR NESSA CLASSE!
    
    // Self Island Properties
    var selfIslandSKScene: SKScene?
    var selfIsland: SelfIsland?

    // Services
    var infoHandler: InformationHandler?
    var islandsVisualizationServices: IslandsVisualisationServices? = nil
    // Dictionary with key being the id of the island, and value its corresponding SceneKit plane node
    var islandDictionary: [String: SCNNode] = [:]

    // Card Properties
    var floatingPanel: FloatingPanelController!
    var cardView: CardViewController!

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SCNScene
        let islandsSCNScene = SCNScene(named: "AllIslandsScene.scn")!
        islandsSCNScene.background.contents = UIImage(named: "backgroundSky")
        setUpCameraControl(sceneView: self.islandsSCNView)
        
        // Create the SKScene
        selfIslandSKScene = SKScene(fileNamed: "IslandSpriteScene.sks")!
        selfIslandSKScene?.isPaused = false
        selfIslandSKScene?.scaleMode = .aspectFit
        
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
        
        // Add periferal islands to scene
        //self.islandsVisualizationServices!.addAllPeriferalIslandsToScene()
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        //self.islandsVisualizationServices!.changePeriferalIslandLabel(islandId: "3", text: "Deu bom")
    }

    // MARK: Helpers

    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Olhar constraints de câmera
        sceneView.allowsCameraControl = true
        // sceneView.cameraControlConfiguration.rotationSensitivity = 0
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
        //self.mockPeripheral()
    }

    // Debug function only to populate CoreData in first use.
    func mockPeripheral() {
        self.infoHandler?.addPeripheralIsland(category: "Trabalho", name: "Trabalho", healthStatus: 90)
        self.infoHandler?.addPeripheralIsland(category: "Estudos", name: "Faculdade", healthStatus: 55)
        self.infoHandler?.addPeripheralIsland(category: "Família", name: "Família", healthStatus: 40)
        self.infoHandler?.addPeripheralIsland(category: "Saúde", name: "Saúde", healthStatus: 70)
    }

}
