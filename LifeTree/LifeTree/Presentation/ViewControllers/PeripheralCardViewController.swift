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
    var islandActions: [Actions] = []
    var numberOfActions: Int = 0

    override func viewWillAppear(_ animated: Bool) {
        nameIsland.text = peripheralIsland?.name

        if let healthStatus = peripheralIsland?.healthStatus {
            phrase.text = "Sua saúde é de \(healthStatus)%"
        } else {
            phrase.text = "Sua saúde ainda não foi definida"
        }

        // Table View
        islandActions = [Actions(name: "Regar as plantas"), Actions(name: "Varrer a calçada"), Actions(name: "Lavar a roupa")]
        numberOfActions = islandActions.count

        actionsTableView.delegate = self
        actionsTableView.dataSource = self
        actionsTableView.reloadData()


    }


}

extension PeripheralCardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfActions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        cell.textLabel?.text = islandActions[indexPath.row].name
        return cell
    }


}

class Actions {
    var name: String

    init(name: String) {
        self.name = name
    }


    // MARK: Debug Buttons

    @IBAction func newAction(_ sender: Any) {
        let action = Action()

        action.actionId = UUID()
        action.name = "Ação teste"
        action.impactLevel = 50

        if let relatedIsland = self.peripheralIsland {
            ActionDataServices.createAction(action: action, relatedIsland: relatedIsland) { (error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Ação criada com sucesso.")
                }
            }
        }
    }

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

    // MARK: Table View - List of Actions
    // Deve ser populada utilizando o método
    // ActionDataServices.getIslandActions() conforme
    // exemplificado no botão de debug

    // MARK: Add New Action Button
    // Deve levar o usuário a uma nova tela (CreateActionViewController)
    // Informações que devem ser passadas: PeripheralIsland
}
