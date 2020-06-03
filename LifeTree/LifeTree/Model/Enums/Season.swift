//
//  Season.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 15/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

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
        return "No inverno, a energia é mais baixa e tudo pode parecer mais lento e difícil. Não desista, continue cultivando a sua ilha. Pense em passos pequenos e não se cobre tanto."
      case .spring:
        return "Você acaba de sair de um período frio, mas está ganhando energia. O ritmo aumenta, suas folhas estão se espalhando e suas flores começam a florir. Continue assim para chegar no verão."
      case .summer:
        return "Parabéns! Você chegou no verão! O ritmo é alto e tudo se movimenta a todo tempo. Aproveite esse momento para cultivar outras ilhas que estão mais frias."
      case .autumn:
        return "A energia ainda está alta, mas está diminuindo com o tempo. Continue cultivando a sua ilha. Não tente ser tão produtivo quanto em outro momento. Encontre o seu próprio ritmo de agora."
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


}
