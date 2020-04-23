//
//  GameViewController.swift
//  Scenekit+Spritekit
//
//  Created by Gustavo Lima on 06/04/20.
//  Copyright © 2020 Gustavo Lima. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skScene = SKScene(fileNamed: "art.scnassets/SpriteKitScene.sks")!
        skScene.isPaused = false
        skScene.scaleMode = .aspectFit
        
        // create a new scene
        let scnScene = SCNScene(named: "art.scnassets/ScenekitScene.scn")!
        
        // create and add a camera to the scene
       let cameraNode = SCNNode()
       cameraNode.camera = SCNCamera()
       scnScene.rootNode.addChildNode(cameraNode)
       
       // place the camera
       cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        
        if let plane = scnScene.rootNode.childNode(withName: "plane", recursively: true),
            let geometry = plane.geometry,
            let material = geometry.firstMaterial {
            
            material.diffuse.contents = skScene
            material.isDoubleSided = true
            
            let constraint = SCNLookAtConstraint(target: cameraNode)
            
            plane.constraints = [constraint]
        }

        
               
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scnScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
