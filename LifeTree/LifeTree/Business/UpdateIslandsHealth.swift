//
//  UpdateIslandsHealth.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class UpdateIslandsHealth {
    
    let dropToHealthConversionFactor: Double = 0.5
    let inactiveTimeToHealthDropConversionFactor: Double = 0.3

    static func getSeason(currentHealth: Double, lastHealth: Double) -> Season? {

        switch currentHealth {
        case 0...33:
            return .winter
        case 34...67:
            if currentHealth >= lastHealth {
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
    
    func updatePeripheralIslandByInactiveTime(_ island: inout PeripheralIsland) {
        var timeDistance: Int = 0
        
        // Calculate hours since island was updated last
        if let lastDate: Date = island.lastActionDate {
            timeDistance = DateServices().timeDistanceFromDate(date: lastDate, timeUnit: .hour)
        }
        // Decrease health due to inactive time
        var newHealth = Int(truncating: island.currentHealthStatus ?? 50) - Int(Double(timeDistance) * self.inactiveTimeToHealthDropConversionFactor)
        
        // Make sure new health is within boundaries
        if newHealth < 0 {
            newHealth = 0
        } else if newHealth > 100 {
            newHealth = 100
        }
        // Update island health and
        island.lastActionDate = Date()
        island.lastHealthStatus = island.currentHealthStatus
        island.currentHealthStatus = NSNumber(value: newHealth)
    }
    
    func updateSelfIslandHealth(_ completion: @escaping (_ selfIsland: SelfIsland) -> Void) {
        
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                // Treat Error
                print(error.debugDescription)
            }
            else if let allIslands = peripheralIslands {
                
                // Get average from every island's health
                var healthAverage: Float = 0
                for island in allIslands {
                    healthAverage += Float(truncating: island.currentHealthStatus ?? 0)
                }
                healthAverage = healthAverage/Float(allIslands.count)
                
                // Get current selfIsland from CoreData
                SelfIslandDataServices.getFirstSelfIsland { (error, selfIsland) in
                    if error != nil {
                        // Treat error
                        print(error.debugDescription)
                    }
                    // Update selfIsland health
                    else if let myIsland: SelfIsland = selfIsland {
                        
                        myIsland.lastHealthStatus = myIsland.currentHealthStatus
                        myIsland.currentHealthStatus = NSNumber(value: healthAverage)
                        
                        // Save update in Coredata
                        SelfIslandDataServices.updateSelfIsland(island: myIsland) { (error) in
                            if error != nil {
                                print(error.debugDescription)
                            }
                            else {
                                // Completion to update selfIsland related UI
                                completion(myIsland)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getNewHealthFromDrops(island: PeripheralIsland, drops: Int) -> Int {
        
        let currentHealth = Int(truncating: island.currentHealthStatus ?? 50)
        var newHealth: Int = 50
            
        newHealth = currentHealth + Int(Double(drops) * self.dropToHealthConversionFactor)
        
        if newHealth > 100 {
            newHealth = 100
        } else if newHealth < 0 {
            newHealth = 0
        }
        return newHealth
    }
}
