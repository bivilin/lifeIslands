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

class IslandsSceneViewController: UIViewController {
    
    @IBOutlet weak var islandsSCNView: SCNView!
    
    // MARK: Variable
    
    // Self Island variables
    var selfIslandSKScene: SKScene?
    var selfIsland: SelfIsland?
    
    // Variables to distribute the periferal islands in an ellipse
    var numberOfIslands: Int = 6
    var a: Double = 3.5 // bigger semi-axis of the ellipse
    var b: Double = 2.5 // smaller semi-axis of the ellipse
    
    // Dictionary with key being the id of the island, and value its corresponding SceneKit plane node
    var islandDictionary: [String: SCNNode] = [:]
    
    // MARK: Lifecycle

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

        // SceneKit camera
        // let cameraNode = islandsSCNScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let geometry = selfIslandPlane.geometry,
            let material = geometry.firstMaterial {
            
            // Rotates the plane reference frame by pi (180 degrees), otherwize the SpriteKit Scene appears mirroed
            material.diffuse.contents = selfIslandSKScene
            // Makes the material double sided, otherwise the plane can only be seen when the camera is pointed at its +z direction
            // In our case, the camera is pointed to the plane -z direction, so if not double sided, the plane won't even be visible
            material.isDoubleSided = true
        }
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
        // Corrects axis size based on the total number of islands
        self.a += self.a * Double(self.numberOfIslands)/40
        self.b += self.b * Double(self.numberOfIslands)/80
        
        // Angle of separation between the islands
        let separationAngle: Double = 2 * .pi / Double(self.numberOfIslands)
        
        // Position of ellipse focus
        let c = sqrt(self.a * self.a - self.b * self.b)
        
        // Creates all islands
        for n in 1...self.numberOfIslands {
            
            // Creates SceneKit plane
            var planeGeometry: SCNGeometry
            planeGeometry = SCNPlane(width: 1, height: 1)
            
            // Assign a SpriteKit scene as texture to such plane
            if let planeMaterial = planeGeometry.firstMaterial {
                
                // Creates SpriteKit scene as an independent copy of the self island scene
                let newSpriteKitScene = selfIslandSKScene!.copy() as! SKScene
                
                // Asign scene as material
                planeMaterial.diffuse.contents = newSpriteKitScene
                planeMaterial.isDoubleSided = true
                
                // Changes label in island
                let islandNode = newSpriteKitScene.children.first
                let labelNode = islandNode?.childNode(withName: "nameLabelNode") as! SKLabelNode
                labelNode.text = "Ilha" + String(n)
            }
            
            // Add plane node to the SCNScene with all islands
            let islandNode = SCNNode(geometry: planeGeometry)
            islandsSCNScene.rootNode.addChildNode(islandNode)
            
            // Append plane to the dictionary associating them with the island id
            self.islandDictionary[String(n)] = islandNode
            
            // Defines y position and tilt angle for the plane
            islandNode.eulerAngles.x = .pi - .pi/6 // so the plane faces the camera
            islandNode.position.y = 0 // define plane for the ellipse
            
            // Positions the islando in the ellipse with focus in the self island
            // Distinguishes between even and odd number of islands so they're better distributed in the ellipse
            if self.numberOfIslands % 2 == 0 {
                islandNode.position.x = Float(self.b * sin((Double(n) + 1/2) * separationAngle))
                islandNode.position.z = Float(self.a * cos((Double(n) + 1/2) * separationAngle) - (self.a-c))
            } else {
                islandNode.position.x = Float(self.b * sin(Double(n) * separationAngle))
                islandNode.position.z = Float(self.a * cos(Double(n) * separationAngle) - (self.a-c))
            }
        }
        
        print(self.islandDictionary)
        
        // Acessa uma scene do SpriteKit a partir do node do plano do SceneKit
        guard let nodeForIsland1: SCNNode = islandDictionary["1"] else {return}
        guard let sceneForIsland1: SKScene = nodeForIsland1.geometry!.firstMaterial!.diffuse.contents as? SKScene else {return}
        guard let nameIsland1 = sceneForIsland1.children.first?.childNode(withName: "nameLabelNode") as? SKLabelNode else {return}
        nameIsland1.text = "Vai Corinthians"
        
        // TODO
        
        // Fazer cordas
        
        // Tirar sprite separado para a árvore
        
        // Calibrar as posições da câmera e das ilhas
        // Fica esquisito para 1, 2 e 4 ilhas

        // Conectar com o CoreData (quando buscamos as ilhas no CoreData, elas sempre serão devolvidas por ordem de id?) Se sim, toda vez que recriarmos o mundo quando a pessoa entrar no app, ele vai ser o mesmo!
        // Estabelecer como será a navegação
        
        // O dicionário é persistido quando vamos para outra página e voltamos?
        // Verificar se mesmo indo para outra tela a minha scene continua existindo
        // Como ela vai se comportar com segues que vão para ela? Talvez tenhamos que chamar funções diferentes dependendo de quando a pessoa acessa a Scene (ao entrar no app ou voltando de outra tela). Se for voltando de outra tela e a Scene não tiver persistido na troca, devemos persistir pelo menos a última posição da câmera para ter continuidade
        
        // CÂMERA
        
        // Mover a câmera com pinch e pan
        // Limitar o movimento dessa câmera com constraints
        // Escrever uma função que dependendo da posição da câmera mostra um card específico
        // OU
        // Cordinhas: joint (articulação) -> colocar efeitos de física
        // Colocar um corpo de física maior que a corda e transparente para a pessoa tocar
    }
    
    // MARK: Actions
    
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
    
    // MARK: Helpers

    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        // Estudar sobre constraints de câmera
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
}
