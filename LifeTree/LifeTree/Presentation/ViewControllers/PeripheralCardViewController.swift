//
//  PeripheralCardViewController.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 08/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class PeripheralCardViewController: UIViewController {

    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var phrase: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!

    var peripheralIsland: PeripheralIsland?
    var islandActions: [Action] = []

    override func viewWillAppear(_ animated: Bool) {
        nameIsland.text = peripheralIsland?.name

        if let healthStatus = peripheralIsland?.healthStatus {
            phrase.text = "Sua saúde é de \(healthStatus)%"
        } else {
            phrase.text = "Sua saúde ainda não foi definida"
        }

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

    // Segue para CreateActionViewController
    @IBAction func newAction(_ sender: Any) {
        self.performSegue(withIdentifier: "NewAction", sender: sender)
    }

    // Atualiza dados quando o usuário sai da CreateActionViewController
    @IBAction func unwindToPeriphalIsland(_ unwindSegue: UIStoryboardSegue) {
        self.updateDataFromDatabase()
    }

    // Botão de Debug
    @IBAction func checkIslandActions(_ sender: Any) {
        ActionDataServices.getIslandActions(island: peripheralIsland!) { (error, actions) in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                if let islandActions = actions {
                    print("Há \(islandActions.count) ações na ilha \(self.peripheralIsland!.name!).")
                    for action in islandActions {
                        print("Ação \(action.name!) - Nível de impacto: \(action.impactLevel!)")
                    }
                }
            }
        }
    }
}

// MARK: Table View - List of Actions

extension PeripheralCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return islandActions.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionTableViewCell

        if indexPath.row < islandActions.count {
            cell.actionName?.text = islandActions[indexPath.row].name
            cell.dropImage.image = UIImage(named: "happyDropIcon")
        } else {
            cell.actionName.text = "+ Criar nova ação"
            cell.actionName.textColor = UIColor.lightGray
            cell.dropImage = nil
        }
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        actionsTableView.deselectRow(at: indexPath, animated: true)
    }
}
