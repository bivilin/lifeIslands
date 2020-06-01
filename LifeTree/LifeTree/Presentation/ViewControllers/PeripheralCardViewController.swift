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
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var lastActivityMessageLabel: UILabel!
    var islandScene: SKScene?

    var peripheralIsland: PeripheralIsland?
    var islandActions: [Action] = []

    override func viewWillAppear(_ animated: Bool) {

        // TableView Delegates Setup
        self.actionsTableView.delegate = self
        self.actionsTableView.dataSource = self

        // Table View Design
        self.actionsTableView.separatorStyle = .none

        // Populando TableView com dados persistidos
        self.updateDataFromDatabase()

        // Labels
        updateLabels()


        // Debug
        print("===== ENTRANDO NA ILHA =====")
        print("Saúde Atual da Ilha: \(self.peripheralIsland?.currentHealthStatus)")
        print("Saúde Anterior da Ilha: \(self.peripheralIsland?.lastHealthStatus)")
    }

    // Atualiza labels de acordo com dados persistidos
    func updateLabels() {
        // Definindo nome da ilha
        nameIsland.text = peripheralIsland?.name

        // Texto com último dia de entrada
        let relativeDate = DateServices().getTimeSinceLastEntry(lastDate: peripheralIsland?.lastActionDate ?? Date())
        self.lastActivityMessageLabel.text = "Sua última atividade aqui foi \(relativeDate). Fico feliz quando me rega todos os dias!"
    }

    // MARK: Info Handling
    func updateDataFromDatabase() {

        // Recupera ações dessa ilha
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

        // Atualiza dados da ilha
        if let uuid = self.peripheralIsland?.islandId {
            PeripheralIslandDataServices.findById(objectID: uuid) { (error, island) in
                if error == nil {
                    self.peripheralIsland = island
                    self.updateLabels()
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
        switch section {
        case 0:
            return 1
        case 1:
            return islandActions.count + 1
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Célula única de conteúdo fixo acima da lista de ações
        case 0:
            let newFixedContentCell = actionsTableView.dequeueReusableCell(withIdentifier: "fixedContentCell", for: indexPath) as! FixedContentCell
            if let scene = self.islandScene, let island = self.peripheralIsland {
                newFixedContentCell.loadContents(island: island, scene: scene)
            }
            return newFixedContentCell
        case 1:
            // Lista de ações
            if indexPath.row < islandActions.count {
                let actionCell = actionsTableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionTableViewCell
                let action = islandActions[indexPath.row]
                actionCell.loadContents(action: action)
                return actionCell
            }
            // Células para adicionar uma nova ação
            else {
                let newActionCell = actionsTableView.dequeueReusableCell(withIdentifier: "createActionCell", for: indexPath) as! CreateActionTableViewCell
                return newActionCell
            }
        default:
            return UITableViewCell()
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
        if indexPath.section != 1 {
            return
        }

        // Ação selecionada
        if indexPath.row < islandActions.count {
            self.presentConfirmActionCustomAlert(action: islandActions[indexPath.row])
        }
        // Adicionar nova ação
        else {
            self.performSegue(withIdentifier: "NewAction", sender: self)
        }
        actionsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Show custom Alert for expanding details of an action and deleting/cultivating it
    func presentConfirmActionCustomAlert(action: Action) {
        
        // Set up ViewController
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmAction") as! ActionCustomAlertViewController
        customAlert.delegate = self
        customAlert.action = action
        customAlert.island = self.peripheralIsland!
        
        CustomAlertServices().presentAsAlert(show: customAlert, over: self)
    }
}

extension PeripheralCardViewController: ActionCustomAlertViewDelegate {
    
    func reloadActionsTableView() {
        self.updateDataFromDatabase()
        self.actionsTableView.reloadData()
    }
}
