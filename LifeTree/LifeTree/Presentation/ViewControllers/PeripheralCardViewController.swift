//
//  PeripheralCardViewController.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 08/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class PeripheralCardViewController: UIViewController {

    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var phrase: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var islandSKView: SKView!
    
    var peripheralIsland: PeripheralIsland?
    var islandActions: [Action] = []

    override func viewWillAppear(_ animated: Bool) {
        nameIsland.text = peripheralIsland?.name

        if let healthStatus = peripheralIsland?.currentHealthStatus {
            phrase.text = "Sua saúde é de \(healthStatus)%"
        } else {
            phrase.text = "Sua saúde ainda não foi definida"
        }
        
        // Set up the SKView for the island
        islandSKView.allowsTransparency = true

        // TableView Delegates Setup
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self

        // Table View Design
        self.actionsTableView.separatorStyle = .none

        // Populando TableView com dados persistidos
        self.updateDataFromDatabase()
    }

    // MARK: Info Handling

    func updateDataFromDatabase() {
        ActionDataServices.getIslandActions(island: peripheralIsland!) { (error, actions) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                if let islandActions = actions {
                    self.islandActions = islandActions
                    self.actionsTableView.reloadData()

                    // Debug Prints
                    print("Há \(islandActions.count) ações na ilha \(self.peripheralIsland!.name!).")
                    for action in islandActions {
                        print("Ação \(action.name!) - Nível de impacto: \(action.impactLevel!)")
                    }
                }
            }
        }
    }

    // MARK: Segue Flow

    // Passando objeto da ilha periférica para a criação de uma ação
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "NewAction" {
            if let destination = segue.destination as? CreateActionViewController {
                destination.island = self.peripheralIsland
            }
        }
    }

    // Atualiza dados quando o usuário sai da CreateActionViewController
    @IBAction func unwindToPeriphalIsland(_ unwindSegue: UIStoryboardSegue) {
        self.updateDataFromDatabase()
    }
}

// MARK: Table View - List of Actions

extension PeripheralCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return islandActions.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < islandActions.count {
            let action = islandActions[indexPath.row]
            let actionCell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionTableViewCell
            actionCell.label?.text = action.name

            // Altera imagem de acordo com o nível de impacto da ação
            do {
                try actionCell.setDropImage(impactLevel: action.impactLevel as! Double)
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            return actionCell
        } else {
            let newActionCell = actionsTableView.dequeueReusableCell(withIdentifier: "createActionCell", for: indexPath) as! CreateActionTableViewCell
            return newActionCell
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    // Permitindo altura variável da célula da Table View
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // Navegação para a próxima tela de acordo com célula clicada
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < islandActions.count {
            // Futuro: abrir actionSheet para definir se é para confirmar ou editar
            // TODO Agora: colocar o segue para receber as gotas
        } else {
            self.performSegue(withIdentifier: "NewAction", sender: nil)
        }
        actionsTableView.deselectRow(at: indexPath, animated: true)
    }
}
