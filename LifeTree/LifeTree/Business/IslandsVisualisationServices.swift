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
    
    var radius: Double = 1.75
    var numberofPeripheralIslands: Int = 1
    var separationAngle: Double = 1
    
    var islandsSCNScene: SCNScene
    let planeLength: CGFloat = 1
    let yPositionForPeripheralIsland: Double = -1.7
    
    var peripheralIslands: [PeripheralIsland] = [PeripheralIsland]()
    var islandDictionary: [UUID: SCNNode] = [:]
    
    var gaussianBlur = CIFilter(name: "CIGaussianBlur")
    
    init(scnScene: SCNScene) {
        self.islandsSCNScene = scnScene
        
        let blurRadius = 6
        gaussianBlur?.setValue(blurRadius, forKey: kCIInputRadiusKey)
    }
    
    // Add self island to scene
    func addSelfIslandToScene(islandsSCNScene: SCNScene) {
        
        // Set SpriteKit scene as the material for the SceneKit plane
        if let selfIslandPlane = islandsSCNScene.rootNode.childNode(withName: "selfIslandPlane", recursively: true),
            let selfIslandPlaneGeometry = selfIslandPlane.geometry {
            self.setPlaneMaterialAsIslandSKScene(planeGeometry: selfIslandPlaneGeometry)
            
            // Places billboard constraint so that self plane is always facing the camera
            let constraint = SCNBillboardConstraint()
            selfIslandPlane.constraints = [constraint]
        }
    }
    
    // Add all peripheral islands to scene
    func addAllPeripheralIslandsToScene(peripheralIslandArray: [PeripheralIsland]) {
        
        self.peripheralIslands = peripheralIslandArray
        self.updateVariablesForPositioningIslands()

        // Creates all islands
        for n in 1...self.numberofPeripheralIslands {
            addPeripheralIslandToSCNScene(n: n)
        }
    }
    
    // Add a single peripheral island with index n to the scene
    func addPeripheralIslandToSCNScene(n: Int) {
        // Creates plane with island
        var planeGeometry: SCNGeometry
        planeGeometry = SCNPlane(width: self.planeLength, height: self.planeLength)
        self.setPlaneMaterialAsIslandSKScene(planeGeometry: planeGeometry)
        
        // Add plane node to the SCNScene with all islands
        let islandNode = SCNNode(geometry: planeGeometry)
        islandsSCNScene.rootNode.addChildNode(islandNode)
        
        // Append plane to the dictionary associating them with the island id
        self.islandDictionary[self.peripheralIslands[n - 1].islandId!] = islandNode
        
        // Positions island in the orbit circle
        self.positionIslandInCircle(islandNode: islandNode, n: n)
    }
    
    // Position a peripheral islands in the ellipse with focus in the self island
    func positionIslandInCircle(islandNode: SCNNode, n: Int) {
        
        // Distinguishes between even and odd number of islands so they're better distributed in the ellipse
        let angle = Double(n) * self.separationAngle
        islandNode.position.x = Float(self.radius * sin(angle))
        islandNode.position.z = Float(self.radius * cos(angle))
        islandNode.position.y = Float(self.yPositionForPeripheralIsland)
        
        // Place billboard constraint so that island plane is always facing the camera
        let constraint = SCNBillboardConstraint()
        islandNode.constraints = [constraint]
        
        // Put gaussian filter
        if let blur = self.gaussianBlur {
            islandNode.filters = [blur]
        }
        
        // Add rope connecting it to the self island
        self.makeRope(angle: Float(angle))
    }
    
    // Updates variables to be used when placing the peripheral islands
    func updateVariablesForPositioningIslands() {
        self.numberofPeripheralIslands = self.peripheralIslands.count
        
        // Angle of separation between the peripheral islands islands
        self.separationAngle = 2 * .pi / Double(self.numberofPeripheralIslands)
        
        // Corrects radius size based on the total number of islands
        self.radius += self.radius * Double(self.numberofPeripheralIslands)/20
    }
    
    // Define the material for a plane as the island SpriteKit scene model
    func setPlaneMaterialAsIslandSKScene(planeGeometry: SCNGeometry) {
        // Assign a SpriteKit scene as texture to such plane
        if let planeMaterial = planeGeometry.firstMaterial {
            
            // Creates SpriteKit scene as an independent copy of the island scene
            let newSpriteKitScene = IslandSpriteScene(fileNamed: "IslandSpriteScene.sks")!.copy() as! IslandSpriteScene

            // Asign scene as material
            planeMaterial.diffuse.contents = newSpriteKitScene
            
            // Makes the material double sided, otherwise the plane can only be seen when the camera is pointed at its +z direction (which might not be the case unless we use the billboard constrint on the planes)
            planeMaterial.isDoubleSided = true
            
            // Flips plane material vertically so SKScene is displayed correctly
            planeMaterial.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

            newSpriteKitScene.changeTexture(named: "summerIsland")

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
    
    // Get the SKScene of a peripheral island from its id
    func getPeripheralIslandSKScene(islandId: UUID) -> SKScene? {
        var sceneForIsland: SKScene? = nil
        if let nodeForIsland: SCNNode = self.islandDictionary[islandId] {
            sceneForIsland = nodeForIsland.geometry!.firstMaterial!.diffuse.contents as? SKScene
        }
        return sceneForIsland
    }
    
    // Get SKScene of given node
    func getIslandSKSceneFromNode(node: SCNNode) -> SKScene? {
        var scene: SKScene? = nil
        if let material = node.geometry!.firstMaterial {
            scene = material.diffuse.contents as? SKScene
        }
        return scene
    }
    
    func makeRope(angle: Float) {
        // Width of the parabole, which corresponds to the coordinate x of its ending point
        let width = self.radius * 100
        
        // Distance between the two paraboles - thickness (in the xy plane) of the 3D shape generated by them
        let thickness = width * 0.995

        // Create a pair of connected paraboles through Bezier paths
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0)) // initial point
        path.addQuadCurve(to: CGPoint(x: width, y: 90 * self.yPositionForPeripheralIsland), controlPoint: CGPoint(x: width/2, y: -(5/6) * width)) // parabole going forward
        path.addLine(to: CGPoint(x: thickness, y: 90 * self.yPositionForPeripheralIsland)) // line connecting the two paraboles
        path.addQuadCurve(to: CGPoint(x: width - thickness, y: 0), controlPoint: CGPoint(x: width/2, y: -(5/6) * width + 2 * (width - thickness))) // parabole going backwards
        
        // Creates 3D shape by filling the space between the paraboles
        let shape = SCNShape(path: path, extrusionDepth: 2)
        shape.firstMaterial?.diffuse.contents = UIColor(red: 0.37, green: 0.18, blue: 0.03, alpha: 1.0)
        
        // Put geometry into node
        let shapeNode = SCNNode(geometry: shape)
        shapeNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        // Corrects SceneKit angle shift bug
        var correction: Float = 0
        switch self.numberofPeripheralIslands {
        case 1, 2:
            correction = -.pi/2
        case 3, 6:
            correction = .pi/6
        case 5, 10:
            correction = -.pi/10
        case 7:
            correction = .pi/12
        case 9:
            correction = -.pi/16
        case 11:
            correction = .pi/24
        default:
            correction = 0
        }
        
        // Positions the node
        shapeNode.position.y = -0.6
        self.islandsSCNScene.rootNode.addChildNode(shapeNode)
        shapeNode.eulerAngles.y = angle + correction
    }

    // Acessa o objeto da ilha de um nó
    func getIslandfromNode(inputNode: SCNNode) -> PeripheralIsland? {
        var island: PeripheralIsland?

        for (uuid, node) in islandDictionary {
            if inputNode == node {
                island = self.getPeripheralIslandFromUUID(uuid: uuid)
            }
        }
        return island
    }

    // Identifica ilha periférica de um dado UUID
    func getPeripheralIslandFromUUID(uuid: UUID) -> PeripheralIsland? {
        var peripheralIsland: PeripheralIsland?

        for island in self.peripheralIslands {
            if uuid == island.islandId {
                peripheralIsland = island
            }
        }
        return peripheralIsland
    }
}

