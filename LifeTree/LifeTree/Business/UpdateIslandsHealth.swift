//
//  UpdateIslandsHealth.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class UpdateIslandsHealth {

    // MARK: Health Definition


    // MARK: Season Definition

    static func getSeason(currentHealth: Double, lastHealth: Double) -> Season? {

        switch currentHealth {
        case 0...33:
            return .winter
        case 34...67:
            if currentHealth > lastHealth {
                return .spring
            } else {
                return .autumn
            }
        case 67...100:
            return .summer
        default:
            print("Season not found. Check if HealthStatus is between 0-100")
            return nil
        }
    }
}
