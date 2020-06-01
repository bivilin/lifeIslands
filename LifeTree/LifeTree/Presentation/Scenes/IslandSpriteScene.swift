//
//  IslandSpriteScene.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 29/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import SpriteKit

class IslandSpriteScene: SKScene {
    var islandNode: SKSpriteNode?

    func changeTexture(named: String) {
        islandNode = self.childNode(withName: "islandNode") as? SKSpriteNode
        islandNode?.texture = SKTexture(imageNamed: named)
    }
}
