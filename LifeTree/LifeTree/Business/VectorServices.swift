
//
//  vectorServices.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 07/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import SceneKit

class VectorServices {
    
    func length(vector: SCNVector3) -> Float {
        let lengthSquared = vector.x * vector.x + vector.y * vector.y + vector.z * vector.z
        return sqrt(lengthSquared)
    }
    
    func multiplicationByScalar(vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(x: scalar * vector.x, y: scalar * vector.y, z: scalar * vector.z)
    }
    
    func sum(vector1: SCNVector3, vector2: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: vector1.x + vector2.x,
                          y: vector1.y + vector2.y,
                          z: vector1.z + vector2.z)
    }
    
    func subtraction(vector1: SCNVector3, vectorToSubtract: SCNVector3) -> SCNVector3 {
        let vector2 = self.multiplicationByScalar(vector: vectorToSubtract, scalar: -1)
        return self.sum(vector1: vector1, vector2: vector2)
    }
}
