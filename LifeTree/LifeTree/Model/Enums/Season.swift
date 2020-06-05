//
//  Season.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 15/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

enum Season : String {
    case winter
    case spring
    case summer
    case autumn

    var name : String {
      switch self {
      case .winter:
        return "Inverno"
      case .spring:
        return "Primavera"
      case .summer:
        return "Verão"
      case .autumn:
        return "Outono"
      }
    }

    var description : String {
      switch self {
      case .winter:
        return "Assim como as estações, nós também temos ciclos. Agora as coisas podem estar mais difíceis, mas vá um passo de cada vez logo irá florescer de novo ;)"
      case .spring:
        return "Você superou um momento mais frio, e suas folhas e flores já estão crescendo de novo! continue cultivando para deixar tudo ainda mais vivo"
      case .summer:
        return "Uau, sua árvore está em seu ápice! Continue o cultivo para a manter linda assim, e que tal aproveitar para cuidar de outros mundos também?"
      case .autumn:
        return "Sua ilha está linda, mas parece que sua energia vem caindo. A natureza é cíclica e nós também! Respeite seu ritmo e tente cultivar aquilo que te faz bem ;)"
      }
    }

    var color: UIColor {
        switch self {
        case .winter:
            return .winterColor
        case .spring:
            return .springColor
        case .summer:
            return .summerColor
        case .autumn:
            return .autumnColor
        }
    }

    var imageNamed: String {
        var label: String = ""
        switch self {
        case .winter:
            label = "winter"
        case .spring:
            label = "spring"
        case .summer:
            label = "summer"
        case .autumn:
            label = "autumn"
        }
        label = label + "Island"
        return label
    }

    var texture: SKTexture {
        var label: String = ""
        switch self {
        case .winter:
            label = "winter"
        case .spring:
            label = "spring"
        case .summer:
            label = "summer"
        case .autumn:
            label = "autumn"
        }
        label = label + "Island"
        let texture = SKTexture(imageNamed: label)
        return texture
    }


}
