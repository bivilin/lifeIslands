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
