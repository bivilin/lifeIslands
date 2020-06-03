//
//  InformationHandler.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 04/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation

class InformationHandler {
//    var sceneServices: IslandsVisualisationServices
    var peripheralIslandsToPersist: [PeripheralIsland] = []

//    init(sceneServices: IslandsVisualisationServices) {
//        self.sceneServices = sceneServices
//        self.loadData()
//    }

    // MARK: Mock Data

    // Os dados estão temporariamente estáticos para MVP
    // Os mesmos métodos podem ser utilizados na VC para customização
//    func loadData() {
//        self.createSelf(name: "Meu Mundo", currentHealth: 50)
//        self.addPeripheralIslandToArray(category: "Trabalho", name: "Trabalho", healthStatus: 66)
//        self.addPeripheralIslandToArray(category: "Faculdade", name: "Faculdade", healthStatus: 66)
//        self.addPeripheralIslandToArray(category: "Família", name: "Família", healthStatus: 32)
//        self.addPeripheralIslandToArray(category: "Saúde", name: "Academia", healthStatus: 66)
//        self.addPeripheralIslandToArray(category: "Casa", name: "Casa", healthStatus: 32)
//        self.addPeripheralIslandToArray(category: "Finanças", name: "Finanças", healthStatus: 32)
//        self.plotPeripheralIslandsOnScene(shouldAddToScene: true) { (islands) in
//            self.sceneServices.addAllPeripheralIslandsToScene(peripheralIslandArray: islands)
//        }
//    }

    // MARK: Self Create
    // Cria ilha do Self
    func createSelf(name: String, currentHealth: Double, completion: ((Bool) -> Void)?) {
        // Including default information to CoreData in case of first launch
        let island = SelfIsland()
        island.name = name
        island.currentHealthStatus = NSNumber(value: currentHealth)
        island.islandId = UUID()
        island.lastHealthStatus = 0

        SelfIslandDataServices.createSelfIsland(island: island) { (error) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                // Debug Code
                print("Mundo criado #\(island.islandId!) - \(island.name!) - Saúde de \(island.currentHealthStatus!)%")
                if let completion = completion {
                    completion(true)
                }
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
        peripheralIsland.islandId = UUID()
        peripheralIsland.lastHealthStatus = 0
        peripheralIsland.lastActionDate = Date()

        self.peripheralIslandsToPersist.append(peripheralIsland)
    }

    // Adiciona ilhas periféricas do vetor no banco de dados
    func addAllPeripheralIslandsToDatabase(completion: ((Bool) -> Void)?) {
        PeripheralIslandDataServices.createAllPeripheralIsland(islands: self.peripheralIslandsToPersist) { (error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                // Adiciona
                print("Ilhas periféricas criadas com sucesso")
                if let completion = completion {
                    completion(true)
                }
            }
        }
    }

    // MARK: Periphal Plot on Scene
    // Apresenta as ilhas periféricas existentes no banco de dados na interface do usuário
    func plotPeripheralIslandsOnScene(shouldAddToScene: Bool, completion: (([PeripheralIsland]) -> Void)?) {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                // Treat Error
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {
                // Se há alguma ilha no banco de dados, cria os elementos visuais para cada uma
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
