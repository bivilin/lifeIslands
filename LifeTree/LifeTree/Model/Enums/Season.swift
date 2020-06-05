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
        return "Tempos frios fazem parte dos nossos ciclos. Com passos pequenos, você irá florescer de novo ;)"
      case .spring:
        return "Suas folhas e flores já estão crescendo de novo! Continue cultivando para deixar tudo ainda mais vivo"
      case .summer:
        return "Uau, sua árvore está em seu ápice! Que tal aproveitar para cuidar de outros mundos também?"
      case .autumn:
        return "Sua energia vem caindo, mas mudanças de ritmo são naturais! Tente cultivar aquilo que te faz bem ;)"
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
