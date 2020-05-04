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
import UIKit

class IslandsVisualisationServices {
    
    var radius: Double = 3
    var numberofPeriferalIslands: Int = 1
    var separationAngle: Double = 1
    
    var islandsSCNScene: SCNScene
    let planeLength: CGFloat = 1
    
    let islandIndexes: [String] = ["1", "2", "3", "4", "5", "6"]
    var islandDictionary: [String: SCNNode] = [:]
    
    init(scnScene: SCNScene) {
        self.islandsSCNScene = scnScene
    }
    
    // Add self island to scene
    func addSelfIslandToScene(islandsSCNScene: SCNScene) {
        
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let selfIslandPlaneGeometry = selfIslandPlane.geometry {
            self.setPlaneMaterialAsIslandSKScene(planeGeometry: selfIslandPlaneGeometry)
            
            // Places billboard constrint so that self plane is always facing the camera
            let constraint = SCNBillboardConstraint()
            selfIslandPlane.constraints = [constraint]
        }
    }
    
    // Add all periferal islands to scene
    func addAllPeriferalIslandsToScene() {
        self.updateVariablesForPositioningIslands()
        
        // Creates all islands
        for n in 1...self.numberofPeriferalIslands {
            addPeriferalIslandToSCNScene(n: n)
        }
        print(self.islandDictionary)
    }
    
    // Add a single periferal island with index n to the scene
    func addPeriferalIslandToSCNScene(n: Int) {

        // Creates plane with island
        var planeGeometry: SCNGeometry
        planeGeometry = SCNPlane(width: self.planeLength, height: self.planeLength)
        self.setPlaneMaterialAsIslandSKScene(planeGeometry: planeGeometry)
        
        // Add plane node to the SCNScene with all islands
        let islandNode = SCNNode(geometry: planeGeometry)
        islandsSCNScene.rootNode.addChildNode(islandNode)
        
        // Append plane to the dictionary associating them with the island id
        self.islandDictionary[String(n)] = islandNode
        
        // Positions island in the orbit circle
        self.positionIslandInCircle(islandNode: islandNode, n: n)
    }
    
    // Position a periferal islands in the ellipse with focus in the self island
    func positionIslandInCircle(islandNode: SCNNode, n: Int) {
        
        // Define plane for the ellipse
        islandNode.position.y = 0
        // Distinguishes between even and odd number of islands so they're better distributed in the ellipse
        if self.numberofPeriferalIslands % 2 == 0 {
            islandNode.position.x = Float(self.radius * sin((Double(n) + 1/2) * self.separationAngle))
            islandNode.position.z = Float(self.radius * cos((Double(n) + 1/2) * self.separationAngle))
        } else {
            islandNode.position.x = Float(self.radius * sin(Double(n) * self.separationAngle))
            islandNode.position.z = Float(self.radius * cos(Double(n) * self.separationAngle))
        }
        islandNode.position.y = 0
        makeRope(n: n) // places rope connecting it to the self island
        
        // Place billboard constraint so that island plane is always facing the camera
        let constraint = SCNBillboardConstraint()
        islandNode.constraints = [constraint]
    }
    
    // Updates variables to be used when placing the periferal islands
    func updateVariablesForPositioningIslands() {
        self.numberofPeriferalIslands = islandIndexes.count
        
        // Angle of separation between the periferal islands islands
        self.separationAngle = 2 * .pi / Double(self.numberofPeriferalIslands)
        
        // Corrects radius size based on the total number of islands
        self.radius += self.radius * Double(self.numberofPeriferalIslands)/50
    }
    
    // Define the material for a plane as the island SpriteKit scene model
    func setPlaneMaterialAsIslandSKScene(planeGeometry: SCNGeometry) {
        // Assign a SpriteKit scene as texture to such plane
        if let planeMaterial = planeGeometry.firstMaterial {
            
            // Creates SpriteKit scene as an independent copy of the island scene
            let newSpriteKitScene = SKScene(fileNamed: "IslandSpriteScene.sks")!.copy() as! SKScene
            
            // Asign scene as material
            planeMaterial.diffuse.contents = newSpriteKitScene
            
            // Makes the material double sided, otherwise the plane can only be seen when the camera is pointed at its +z direction (which might not be the case unless we use the billboard constrint on the planes)
            planeMaterial.isDoubleSided = true
            
            // Flips the SKScene root node vertically so it has the correct orientation on the SCNScene
            if let yScale = newSpriteKitScene.children.first?.yScale {
                newSpriteKitScene.children.first?.yScale = -1 * yScale
            }
            
        }
    }
    
    // Get the SKScene of the self island
    func getSelfIslandSKScene() -> SKScene? {
        var selfIslandSKScene: SKScene? = nil
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true) {
            selfIslandSKScene = selfIslandPlane.geometry!.firstMaterial!.diffuse.contents as? SKScene
        }
        return selfIslandSKScene
    }
    
    // Get the SKScene of a periferal island from its id
    func getPeriferalIslandSKScene(islandId: String) -> SKScene? {
        var sceneForIsland: SKScene? = nil
        if let nodeForIsland: SCNNode = self.islandDictionary[islandId] {
            sceneForIsland = nodeForIsland.geometry!.firstMaterial!.diffuse.contents as? SKScene
        }
        return sceneForIsland
    }
    
    // Changes label of a periferal island
    func changePeriferalIslandLabel(islandId: String, text: String) {
        // Acessa uma scene do SpriteKit a partir do node do plano do SceneKit
        guard let sceneForIsland: SKScene = getPeriferalIslandSKScene(islandId: islandId) else {return}
        guard let nameIsland = sceneForIsland.children.first?.childNode(withName: "nameLabelNode") as? SKLabelNode else {return}
        nameIsland.text = text
    }
    
    // Changes label of self island
    func changeSelfIslandLabel(text: String) {
        guard let selfSKScene = getSelfIslandSKScene() else {return}
        guard let nameSelfIsland = selfSKScene.children.first?.childNode(withName: "nameLabelNode") as? SKLabelNode else {return}
            nameSelfIsland.text = text
    }
    
    func makeRope(n: Int) {
        // Width of the parabole, which corresponds to the coordinate x of its ending point
        let width = self.radius * 100
        
        // Distance between the two paraboles - thickness (in the xy plane) of the 3D shape generated by them
        let thickness = width * 0.99

        // Create a pair of connected paraboles through Bezier paths
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0,y: 0)) // initial point
        path.addQuadCurve(to: CGPoint(x: width, y: 0), controlPoint: CGPoint(x: width/2, y: -(1/3) * width)) // parabole going forward
        path.addLine(to: CGPoint(x: thickness, y: 0)) // line connecting the two paraboles
        path.addQuadCurve(to: CGPoint(x: width - thickness, y: 0), controlPoint: CGPoint(x: width/2, y: -(1/3) * width + 2 * (width - thickness))) // parabole going backwards
        
        // Creates 3D shape by filling the space between the paraboles
        let shape = SCNShape(path: path, extrusionDepth: 2)
        shape.firstMaterial?.diffuse.contents = SKColor.black
        let shapeNode = SCNNode(geometry: shape)
        shapeNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        // Positions the node
        shapeNode.position.y = -0.4
        shapeNode.eulerAngles.y = Float(Double(n) * self.separationAngle)
        self.islandsSCNScene.rootNode.addChildNode(shapeNode)
    }
}
