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
    var selfIslandSKScene: SKScene?
    var selfIsland: SelfIsland?

    var floatingPanel: FloatingPanelController!
    var cardView: CardViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        loadingData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SCNScene
        let islandsSCNScene = SCNScene(named: "AllIslandsScene.scn")!
        setUpCameraControl(sceneView: self.islandsSCNView)
        
        // Create the SKScene
        selfIslandSKScene = SKScene(fileNamed: "IslandSpriteScene.sks")!
        selfIslandSKScene?.isPaused = false
        selfIslandSKScene?.scaleMode = .aspectFit

        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let geometry = selfIslandPlane.geometry,
            let material = geometry.firstMaterial {
            
            material.diffuse.contents = selfIslandSKScene
            material.isDoubleSided = true
        }

        // Show Card
        setupFloatingPanel()
        cardView = storyboard?.instantiateViewController(withIdentifier: "Card") as? CardViewController
        showFloatingPanel()

        // Passos para criar as outras ilhas
        // 1: Adicionar planos ao SceneKit programaticamente correspondendo às ilhas
        // 2: Criar cena no SpriteKit programaticamente (ou podemos reaproveitar a mesma SKScene?)
        // 3: Associar as duas
        // 4: Conectar com as informações persistidas do CoreData

        // DICIONÁRIO: NOME DA ILHA (chave) -> SPRITEKIT
        // Fazer array de planos, cada um com uma textura do SpriteKit
        // SpriteKit -> podemos fazer o sks herdar de uma classe -
        // Fazer uma SKScene para cada ilha, já que teremos um número máximo
        
        // CÂMERA
        // Mover a câmera com pinch e pan
        // Limitar o movimento dessa câmera com constraints
        // Escrever uma função que dependendo da posição da câmera mostra um card específico
        // OU
        // Cordinhas: joint (articulação) -> colocar efeitos de física
        // Colocar um corpo de física maior que a corda e transparente para a pessoa tocar
        
        // SceneKit camera
        // let cameraNode = islandsSCNScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
    }
    @IBAction func criarIlha(_ sender: Any) {
        let island = SelfIsland()
        island.name = "Mundo Mágico de Oz"
        island.healthStatus = 50
        island.islandId = UUID()

        SelfIslandDataServices.createSelfIsland(island: island) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                print("Mundo criado #\(island.islandId!) - \(island.name!) - Saúde de \(island.healthStatus!)%")
            }
        }
    }

    // Refresh database and change text on the screen
    @IBAction func refreshScreen(_ sender: Any) {
        loadingData()

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

    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Olhar constraints de câmera
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0
    }

    func loadingData() {
        // Getting data from CoreData
        SelfIslandDataServices.getFirstSelfIsland { (error, island) in
            guard let island = island else {return}
            if (error != nil) {
                print(error.debugDescription)
            } else {
                self.selfIsland = island
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
