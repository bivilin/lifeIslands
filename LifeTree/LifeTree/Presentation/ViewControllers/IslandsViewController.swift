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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SCNScene
        let islandsSCNScene = SCNScene(named: "AllIslandsScene.scn")!
        setUpCameraControl(sceneView: self.islandsSCNView)
        
        // Create the SKScene
        let selfIslandSKScene = SKScene(fileNamed: "IslandSpriteScene.sks")!
        selfIslandSKScene.isPaused = false
        selfIslandSKScene.scaleMode = .aspectFit
        
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let geometry = selfIslandPlane.geometry,
            let material = geometry.firstMaterial {
            
            material.diffuse.contents = selfIslandSKScene
            material.isDoubleSided = true
        }
        
        // SceneKit camera
        // let cameraNode = islandsSCNScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsSCNScene
        
    }
    
    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0
    }
}
