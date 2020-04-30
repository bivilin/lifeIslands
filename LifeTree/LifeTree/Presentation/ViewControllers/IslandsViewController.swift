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

    // Peripheral Islands Properties
    var numberOfPeripheralIslands: Int?
    var islandsVisualizationServices: IslandsVisualisationServices? = nil
    // Dictionary with key being the id of the island, and value its corresponding SceneKit plane node
    var islandDictionary: [String: SCNNode] = [:]

    // Card Properties
    var floatingPanel: FloatingPanelController!
    var cardView: CardViewController!

    // MARK: Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        self.setupWorld()
        self.checkAllIslands()
    }
    
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

        // SceneKit camera
        // let cameraNode = islandsSCNScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Initializes island Services class with our SCNScene
        self.islandsVisualizationServices = IslandsVisualisationServices(scnScene: islandsSCNScene)

        // Show Card
        setupFloatingPanel()
        cardView = storyboard?.instantiateViewController(withIdentifier: "Card") as? CardViewController
        showFloatingPanel()
        
        // Add self islando do scene
        self.islandsVisualizationServices!.addSelfIslandToScene(islandsSCNScene: islandsSCNScene)
        
        // Add periferal islands to scene
        self.islandsVisualizationServices!.addAllPeriferalIslandsToScene()
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        self.islandsVisualizationServices!.changePeriferalIslandLabel(islandId: "3", text: "Deu bom")
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
        self.addPeripheralIsland()
    }

    @IBAction func retrievePeripheralIslands(_ sender: Any) {
        self.checkAllIslands()
    }
}

// MARK: Data Visualization
// Is this working?
extension IslandsViewController {
    // After data is retrieved successfuly, its content defines the visualization
    func setupInterface() {
        guard let mainNode = selfIslandSKScene?.childNode(withName: "islandNode") else {return}

        // Accessing label node from SpriteKit to change its content
        if let labelNode = mainNode.childNode(withName: "nameLabelNode") as? SKLabelNode {
            labelNode.text = selfIsland?.name
        }

        // Accessing tree node from SpriteKit to change its texture depending on health
        if let health = selfIsland?.healthStatus as? Double, let treeNode = mainNode.childNode(withName: "treeNode") as? SKSpriteNode {
            if health > 45.0 {
                treeNode.texture = SKTexture(imageNamed: "healthyTree")
            } else {
                treeNode.texture = SKTexture(imageNamed: "sickTree")
            }
        }
    }
}

// MARK: Data Handling
extension IslandsViewController {

    func setupWorld() {
        // Including default information to CoreData in case of first launch
        let island = SelfIsland()
        island.name = "Meu Mundo"
        island.healthStatus = 50
        island.islandId = UUID()

        SelfIslandDataServices.createSelfIsland(island: island) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                print("Mundo criado #\(island.islandId!) - \(island.name!) - Saúde de \(island.healthStatus!)%")
            }
            // After saving data, retrieving it to save on selfIsland object
            // That might occur in another screen, so then here we would have a performSegue instead.
            SelfIslandDataServices.getFirstSelfIsland { (error, island) in
                guard let island = island else {return}
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    self.selfIsland = island
                    self.setupInterface()
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


// MARK: Tests for new version

    // Creating Peripheral Island on CoreData
    func addPeripheralIsland() {

        let peripheralIsland = PeripheralIsland()

        // Mock Data
        peripheralIsland.category = "Trabalho"
        peripheralIsland.name = "OneForma"
        peripheralIsland.healthStatus = 30.0
        peripheralIsland.islandId = UUID()

        // Method for accessing Core Data
        PeripheralIslandDataServices.createPeripheralIsland(island: peripheralIsland) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                print("Ilha criada")
            }
        }
    }

    // Retrieving all Peripheral Islands from Core Data
    func checkAllIslands() {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {
                // Saving number of islands in this class to be available for SpriteKit / Scene Kit implementation
                self.numberOfPeripheralIslands = allIslands.count
                print("Há \(allIslands.count) ilhas.")
                for island in allIslands {
                    print("Ilha #\(String(describing: island.islandId))")
                }
            }
        }
    }
}
