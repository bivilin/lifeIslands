//
//  IslandsVisualisationServices.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 28/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

class IslandsVisualisationServices {
    
    // Axis to distribute the periferal islands in an ellipse
    var a: Double = 3.5 // bigger semi-axis of the ellipse
    var b: Double = 2.5 // smaller semi-axis of the ellipse
    let planeLength: CGFloat = 1
    var islandDictionary: [String: SCNNode] = [:]
    
    // Add self island to scene
    func addSelfIslandToScene(islandsSCNScene: SCNScene) {
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let selfIslandPlaneGeometry = selfIslandPlane.geometry {
            self.setPlaneMaterialAsIslandSKScene(planeGeometry: selfIslandPlaneGeometry)
        }
    }
    
    // Add all periferal islands to scene
    func addPeriferalIslandsToScene(islandsSCNScene: SCNScene, numberOfIslands: Int) {
        
        axisSizeCorrection(numberOfIslands: numberOfIslands)
        // Position of ellipse focus
        let ellipseFocalLength: Double = sqrt(self.a * self.a - self.b * self.b)
        
        // Angle of separation between the islands
        let separationAngle: Double = 2 * .pi / Double(numberOfIslands)
        
        // Creates all islands
        for n in 1...numberOfIslands {
            addIslandToSCNScene(islandsSCNScene: islandsSCNScene, n: n, ellipseFocalLength: ellipseFocalLength, numberOfIslands: numberOfIslands, separationAngle: separationAngle)
        }
        print(self.islandDictionary)
    }
    
    // Add a single periferal island with index n to the scene
    func addIslandToSCNScene(islandsSCNScene: SCNScene, n: Int, ellipseFocalLength: Double, numberOfIslands: Int, separationAngle: Double) {

        // Creates plane with island
        var planeGeometry: SCNGeometry
        planeGeometry = SCNPlane(width: self.planeLength, height: self.planeLength)
        self.setPlaneMaterialAsIslandSKScene(planeGeometry: planeGeometry)
        
        // Add plane node to the SCNScene with all islands
        let islandNode = SCNNode(geometry: planeGeometry)
        islandsSCNScene.rootNode.addChildNode(islandNode)
        
        // Append plane to the dictionary associating them with the island id
        self.islandDictionary[String(n)] = islandNode
        
        // Defines y position and tilt angle for the plane
        islandNode.eulerAngles.x = .pi - .pi/6 // so the plane faces the camera
        
        self.positionIslandInEllipse(islandNode: islandNode, numberOfIslands: numberOfIslands, n: n, separationAngle: separationAngle, ellipseFocalLength: ellipseFocalLength)
    }
    
    // Position a periferal islands in the ellipse with focus in the self island
    func positionIslandInEllipse(islandNode: SCNNode, numberOfIslands: Int, n: Int, separationAngle: Double, ellipseFocalLength: Double) {
        
        // Define plane for the ellipse
        islandNode.position.y = 0
        // Distinguishes between even and odd number of islands so they're better distributed in the ellipse
        if numberOfIslands % 2 == 0 {
            islandNode.position.x = Float(self.b * sin((Double(n) + 1/2) * separationAngle))
            islandNode.position.z = Float(self.a * cos((Double(n) + 1/2) * separationAngle) - (self.a - ellipseFocalLength))
        } else {
            islandNode.position.x = Float(self.b * sin(Double(n) * separationAngle))
            islandNode.position.z = Float(self.a * cos(Double(n) * separationAngle) - (self.a - ellipseFocalLength))
        }
    }
    
    func axisSizeCorrection(numberOfIslands: Int) {
        // Corrects axis size based on the total number of islands
        self.a += self.a * Double(numberOfIslands)/40
        self.b += self.b * Double(numberOfIslands)/80
    }
    
    // Define the material for a plane as the island SpriteKit scene model
    func setPlaneMaterialAsIslandSKScene(planeGeometry: SCNGeometry) {
        // Assign a SpriteKit scene as texture to such plane
        if let planeMaterial = planeGeometry.firstMaterial {
            
            // Creates SpriteKit scene as an independent copy of the island scene
            let newSpriteKitScene = SKScene(fileNamed: "IslandSpriteScene.sks")!.copy() as! SKScene
            // Asign scene as material
            planeMaterial.diffuse.contents = newSpriteKitScene
            // Makes the material double sided, otherwise the plane can only be seen when the camera is pointed at its +z direction (which is not our case)
            planeMaterial.isDoubleSided = true
        }
    }
    
    // Changes label of a periferal island
    func changePeriferalIslandLabel(islandId: String, text: String, islandDictionary: [String: SCNNode]) {
        // Acessa uma scene do SpriteKit a partir do node do plano do SceneKit
        guard let nodeForIsland: SCNNode = islandDictionary[islandId] else {return}
        guard let sceneForIsland: SKScene = nodeForIsland.geometry!.firstMaterial!.diffuse.contents as? SKScene else {return}
        guard let nameIsland = sceneForIsland.children.first?.childNode(withName: "nameLabelNode") as? SKLabelNode else {return}
        nameIsland.text = text
    }
    
}

