//
//  ViewController.swift
//  SelfCoreData
//
//  Created by Beatriz Viseu Linhares on 22/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @objc var currentIsland: SelfIsland?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Aqui vamos incluir novos dados no banco de dados
    @IBAction func populateDatabase(_ sender: Any) {
        // Primeiro cria-se um objeto "vazio"
        currentIsland = SelfIsland()

        // Depois coloca-se os dados
        currentIsland?.healthStatus = 80
        currentIsland?.name = "Bia's World"
        currentIsland?.islandId = UUID()

        // E então, acessa-se a camada de Services para adicioná-lo ao banco de dados
        SelfIslandServices.createSelfIsland(island: currentIsland!) { (error) in
            if (error != nil) {
                //treat error
            }
        }
    }

    // Aqui vamos checar quais dados estão atualmente no banco de dados
    @IBAction func retrieveData(_ sender: Any) {

        SelfIslandServices.getAllSelfIslands { (error, selfIslands) in
            if let allIslands = selfIslands {
                print("Banco possui \(allIslands.count) registros.")
                for island in allIslands {
                    print("Ilha Self #\(island.islandId!) - Nome \(island.name!) com saúde de \(island.healthStatus!)")
                }
            }
        }
    }

    @IBAction func cleanData(_ sender: Any) {
        SelfIslandServices.getAllSelfIslands { (error, selfIslands) in
            if let allIslands = selfIslands {
                for island in allIslands {
                    SelfIslandServices.deleteSelfIsland(island: island) {(error) in
                        if (error != nil) {
                            // treat error
                        }
                    }
                }
            }
        }
    }

}

