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

class IslandsViewController: UIViewController {
    
    @IBOutlet weak var islandsSCNView: SCNView!
    var selfIslandSKScene: SKScene?
    var selfIsland: SelfIsland?

    override func viewWillAppear(_ animated: Bool) {
        self.setupWorld()
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

    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Olhar constraints de câmera
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0
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

// MARK: Tests for new version

    func addPeripheralIsland() {
        let peripheralIsland = PeripheralIsland()
        peripheralIsland.category = "Trabalho"
        peripheralIsland.name = "OneForma"
        peripheralIsland.healthStatus = 30.0
        peripheralIsland.islandId = UUID()

        PeripheralIslandDataServices.createPeripheralIsland(island: peripheralIsland) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                print("Ilha criada")
            }
        }
    }

    func checkAllIslands() {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {
                print("Há \(allIslands.count) ilhas.")
                for island in allIslands {
                    print("Ilha #\(String(describing: island.islandId))")
                }
            }
        }

    }
}
