//
//  InformationHandler.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 04/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class InformationHandler {
    var sceneServices: IslandsVisualisationServices
    var numberOfPeripheralIslands: Int = 0

    init(sceneServices: IslandsVisualisationServices) {
        self.sceneServices = sceneServices
    }

    // MARK: Self Create
    // Creates the self island
    func createSelf(name: String, currentHealth: Double) {
        // Including default information to CoreData in case of first launch
        let island = SelfIsland()
        island.name = name
        island.healthStatus = NSNumber(value: currentHealth)
        island.islandId = UUID()

        SelfIslandDataServices.createSelfIsland(island: island) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                // Debug Code
                print("Mundo criado #\(island.islandId!) - \(island.name!) - Saúde de \(island.healthStatus!)%")
            }
            // After saving data, retrieving it to save on selfIsland object
            // That might occur in another screen, so then here we would have a performSegue instead.
            SelfIslandDataServices.getFirstSelfIsland { (error, island) in
                guard let island = island else {return}
                if (error != nil) {
                    print(error.debugDescription)
                } else {
                    //self.selfIsland = island
                    self.sceneServices.changeSelfIslandLabel(text: island.name ?? "Sem Nome")
                }
            }
        }
    }

    // MARK: Single Peripheral Create
    // Creating a Single Peripheral Island on CoreData
    func addPeripheralIsland(category: String, name: String, healthStatus: Double) {

        let peripheralIsland = PeripheralIsland()

        // Mock Data
        peripheralIsland.category = category
        peripheralIsland.name = name
        peripheralIsland.healthStatus = NSNumber(value: healthStatus)
        peripheralIsland.islandId = UUID()

        // Method for accessing Core Data
        PeripheralIslandDataServices.createPeripheralIsland(island: peripheralIsland) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                // Debug code
                print("Ilha criada")

                // Updating Number of Peripheral Islands
                self.numberOfPeripheralIslands += 1

                // TODO: Adding New Island to the Scene - todo
                // append object on array
                // self.islandsVisualizationServices?.peripheralIslands.append(peripheralIsland)

                // change label
                //self.islandsVisualizationServices?.changePeriferalIslandLabel(peripheralIsland: peripheralIsland)

                // add to the scene
                // self.islandsVisualizationServices?.addPeriferalIslandToSCNScene(n: self.numberOfPeripheralIslands)
            }
        }
    }

    // MARK: All Peripheral Create
    // Retrieving all Peripheral Islands from Core Data
    func retrievePeripheralIslands(shouldAddToScene: Bool) {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                // Treat Error
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {
                // Updating Number of Peripheral Islands
                self.numberOfPeripheralIslands = allIslands.count
                print("Há \(allIslands.count) ilhas.")

                // If there are any island, start the process os creating scenes
                if allIslands.count > 0 && shouldCreate {
                    self.sceneServices.addAllPeriferalIslandsToScene(peripheralIslandArray: allIslands)
                }

                // Update labels for each peripheral island
                for island in allIslands {
                    print("Ilha #\(String(describing: island.islandId))")
                    self.sceneServices.changePeriferalIslandLabel(peripheralIsland: island)
                }
            }
        }
    }
}
