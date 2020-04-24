//
//  AllIslandsViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import SceneKit

class IslandsViewController: UIViewController {
    
    @IBOutlet weak var islandsSCNView: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SCNScene
        let islandsScene = SCNScene(named: "AllIslandsScene.scn")!
        
        setUpCameraControl(sceneView: self.islandsSCNView)
        
//        let selfIslandNode = islandsScene.rootNode.childNode(withName: "selfIslands", recursively: true)
//        let cameraNode = islandsScene.rootNode.childNode(withName: "camera", recursively: true)
        
        // Set the scene to the view
        self.islandsSCNView.scene = islandsScene

        // Configure the view
        self.islandsSCNView.backgroundColor = UIColor.black
    }
    
    func setUpCameraControl(sceneView: SCNView) {
        // Allows the user to manipulate the camera
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0
    }
}
