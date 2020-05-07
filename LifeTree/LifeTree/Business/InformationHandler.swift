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
    // var numberOfPeripheralIslands: Int = 0
    var peripheralIslandsToPersist: [PeripheralIsland] = []

    init(sceneServices: IslandsVisualisationServices) {
        self.sceneServices = sceneServices
        self.loadData()
    }

    // MARK: Mock Data

    // Os dados estão temporariamente estáticos para MVP
    // Os mesmos métodos podem ser utilizados na VC para customização
    func loadData() {
        self.createSelf(name: "Meu Mundo", currentHealth: 50)
        self.addPeripheralIslandToArray(category: "Trabalho", name: "Trabalho", healthStatus: 90)
        self.addPeripheralIslandToArray(category: "Faculdade", name: "Faculdade", healthStatus: 55)
        self.addPeripheralIslandToArray(category: "Família", name: "Família", healthStatus: 40)
        self.addPeripheralIslandToArray(category: "Saúde", name: "Academia", healthStatus: 50)
        self.addPeripheralIslandToArray(category: "Casa", name: "Casa", healthStatus: 60)
        self.addPeripheralIslandToArray(category: "Finanças", name: "Finanças", healthStatus: 80)
        self.plotPeripheralIslandsOnScene(shouldAddToScene: true)
    }

    // MARK: Self Create
    // Cria ilha do Self
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

    // MARK: Single Peripheral
    // Permite a inclusão de uma nova ilha periférica
    // Versão futura com personalização das ilhas periféricas

    func addPeripheralIslandToDatabase(category: String, name: String, healthStatus: Double) {

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
                // self.numberOfPeripheralIslands += 1
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
        peripheralIsland.healthStatus = NSNumber(value: healthStatus)
        peripheralIsland.islandId = UUID()

        peripheralIslandsToPersist.append(peripheralIsland)
    }

    // Adiciona ilhas periféricas do vetor no banco de dados
    func addAllPeripheralIslandsToDatabase(islandArray: [PeripheralIsland]) {
        PeripheralIslandDataServices.createAllPeripheralIsland(islands: islandArray) { (error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                // Adiciona
                self.plotPeripheralIslandsOnScene(shouldAddToScene: true)
            }
        }
    }


    // MARK: Periphal Plot on Scene
    // Apresenta as ilhas periféricas existentes no banco de dados na interface do usuário
    func plotPeripheralIslandsOnScene(shouldAddToScene: Bool) {
        PeripheralIslandDataServices.getAllPeripheralIslands { (error, peripheralIslands) in
            if error != nil {
                // Treat Error
                print(error.debugDescription)
            } else if let allIslands = peripheralIslands {

                // Tratamento do primeiro uso
                // Banco de dados vazio
                if allIslands.count == 0 {
                    // Cria as ilhas periféricas mockadas
                    self.addAllPeripheralIslandsToDatabase(islandArray: self.peripheralIslandsToPersist)
                }

                // Número de ilhas é utilizado quando há quantidade variável de ilhas (futuro)
                // self.numberOfPeripheralIslands = allIslands.count
                // print("Há \(allIslands.count) ilhas.")

                // Se há alguma ilha no banco de dados, cria os elementos visuais para cada uma
                if allIslands.count > 0 && shouldAddToScene {
                    self.sceneServices.addAllPeriferalIslandsToScene(peripheralIslandArray: allIslands)
                }

                // Atualiza os rótulos de cada ilha para o texto existente no banco de dados
                for island in allIslands {
                    print("Ilha #\(String(describing: island.islandId))")
                    self.sceneServices.changePeriferalIslandLabel(peripheralIsland: island)
                }
            }
        }
    }
}
