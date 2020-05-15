
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
    
    // |a|
    func length(_ vector: SCNVector3) -> Float {
        return sqrt(dotProduct(vector, vector))
    }
    
    // a . b
    func dotProduct(_ a: SCNVector3,_ b: SCNVector3) -> Float {
        return a.x * b.x + a.y * b.y + a.z * b.z
    }
    
    // a * b
    func multiplicationByScalar(vector: SCNVector3, scalar: Float) -> SCNVector3 {
        return SCNVector3(x: scalar * vector.x, y: scalar * vector.y, z: scalar * vector.z)
    }
    
    // a + b
    func sum(_ a: SCNVector3,_ b: SCNVector3) -> SCNVector3 {
        return SCNVector3(x: a.x + b.x,
                          y: a.y + b.y,
                          z: a.z + b.z)
    }
    
    // a - b
    func subtraction(of b: SCNVector3, from a: SCNVector3) -> SCNVector3 {
        let c = self.multiplicationByScalar(vector: b, scalar: -1)
        return self.sum(a, c)
    }
    
    // â = a/|a|
    func normalize(_ a: SCNVector3) -> SCNVector3 {
        let norm = length(a)
        return multiplicationByScalar(vector: a, scalar: (1/norm))
    }
    
    // (b . â) * â
    func projection(of b: SCNVector3, in a: SCNVector3) -> SCNVector3 {
        let aUnitVector = normalize(a)
        let scalarProduct = dotProduct(aUnitVector, b)
        return multiplicationByScalar(vector: aUnitVector, scalar: scalarProduct)
    }
}
