//
//  InformationHandler.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 04/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class InformationHandler {

    var peripheralIslandsToPersist: [PeripheralIsland] = []

    // MARK: Self Create
    // Cria ilha do Self
    func createSelf(name: String, healthStatus: Double, completion: @escaping () -> Void) {
        
        // Including default information to CoreData in case of first launch
        let island = SelfIsland()
        island.name = name
        island.currentHealthStatus = NSNumber(value: healthStatus)
        island.lastHealthStatus = NSNumber(value: healthStatus)
        island.islandId = UUID()

        SelfIslandDataServices.createSelfIsland(island: island) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                // Debug Code
                print("Mundo criado #\(island.islandId!) - \(island.name!) - Saúde de \(island.currentHealthStatus!)%")
                completion()
            }
        }
    }

    // MARK: Multiple Peripheral
    // Métodos para versão estática, sem customização (MVP)

    // Cria vetor contendo todas as ilhas periféricas que serão persistidas no banco de dados
    func addPeripheralIslandToArray(category: String, name: String, healthStatus: Double) {
        let peripheralIsland = PeripheralIsland()

        peripheralIsland.category = category
        peripheralIsland.name = name
        peripheralIsland.currentHealthStatus = NSNumber(value: healthStatus)
        peripheralIsland.lastHealthStatus = NSNumber(value: healthStatus)
        peripheralIsland.islandId = UUID()
        peripheralIsland.lastActionDate = Date()

        self.peripheralIslandsToPersist.append(peripheralIsland)
    }

    // Adiciona ilhas periféricas do vetor no banco de dados
    func addAllPeripheralIslandsToDatabase(completion: @escaping () -> Void) {
        PeripheralIslandDataServices.createAllPeripheralIsland(islands: self.peripheralIslandsToPersist) { (error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                // Adiciona
                print("Ilhas periféricas criadas com sucesso")
                completion()
            }
        }
    }

    // MARK: Get Peripheral Islands
    // Apresenta as ilhas periféricas existentes no banco de dados na interface do usuário
    func retrievePeripheralIslands(completion: (([PeripheralIsland]) -> Void)?) {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                // Treat Error
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {
                // Faz o completion apenas se há ilhas no banco
                if allIslands.count > 0 {
                    print("Há \(allIslands.count) ilhas periféricas no banco de dados.")
                    if let completion = completion {
                        completion(allIslands)
                    }
                }
            }
        }
    }

    // MARK: Single Peripheral - Future
    // Permite a inclusão de uma nova ilha periférica
    // Versão futura com personalização das ilhas periféricas

    func addPeripheralIslandToDatabase(category: String, name: String, healthStatus: Double) {

        let peripheralIsland = PeripheralIsland()

        // Mock Data
        peripheralIsland.category = category
        peripheralIsland.name = name
        peripheralIsland.currentHealthStatus = NSNumber(value: healthStatus)
        peripheralIsland.islandId = UUID()
        peripheralIsland.lastHealthStatus = 0
        peripheralIsland.lastActionDate = Date()

        // Method for accessing Core Data
        PeripheralIslandDataServices.createPeripheralIsland(island: peripheralIsland) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                // Debug code
                print("Ilha criada")
            }
        }
    }
}
