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
import UICircularProgressRing

class PeripheralCardViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var actionsTableView: UITableView!
    @IBOutlet weak var lastActivityMessageLabel: UILabel!
    @IBOutlet weak var progressSeasonPeripheral: UICircularProgressRing!
    @IBOutlet weak var islandImage: UIImageView!
    var islandSceneServices: IslandsVisualisationServices?
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
        
        // Colocando a linha do pod em cima do circulo imagem
        progressSeasonPeripheral.style = .ontop

        // Easter Egg
        progressView.isHidden = true
        let superTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEasterEggTapGesture(_:)))
        superTapGesture.numberOfTapsRequired = 5
        self.view.addGestureRecognizer(superTapGesture)

        // Debug
        print("===== ENTRANDO NA ILHA =====")
        print("Saúde Atual da Ilha: \(String(describing: self.peripheralIsland?.currentHealthStatus))")
        print("Saúde Anterior da Ilha: \(String(describing: self.peripheralIsland?.lastHealthStatus))")
    }

    @objc func handleEasterEggTapGesture(_ gesture: UIPanGestureRecognizer) {
        progressView.isHidden = false
        let healthStatus = (peripheralIsland?.currentHealthStatus as! Float) / 100
        progressView.setProgress(healthStatus, animated: true)
    }

    // Atualiza labels de acordo com dados persistidos
    func updateLabels() {

        // Definindo nome da ilha
        nameIsland.text = peripheralIsland?.name

        // Texto com último dia de entrada
        let relativeDate = DateServices().getTimeSinceLastEntry(lastDate: peripheralIsland?.lastActionDate ?? Date())
        self.lastActivityMessageLabel.text = "Sua última atividade aqui foi \(relativeDate)."
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
                    self.updateImage(island: island)
                    self.loadProgressPeripheral()
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
    
    func loadProgressPeripheral() {
        
        guard let currentHealth = peripheralIsland?.currentHealthStatus as? Double else { return }
        guard let lastHeath = peripheralIsland?.lastHealthStatus as? Double else { return }
        let season = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath)
            
            var progress: CGFloat = 0
            var indicatorImageName = ""

            // Progress Bar
            let progressIndex = Float(currentHealth / 100)
            progressView.setProgress(progressIndex, animated: true)
            progressView.tintColor = season?.color

            // switch para saber em que ponto do circulo o calculo irá cair
            switch season {
            case .autumn:
                progress = CGFloat(Int.random(in: 45...55))
                indicatorImageName = "autumn"
            case .spring:
                let i = Int.random(in: 1...10)
                if i % 2 == 0 {
                    progress = CGFloat(Int.random(in: 1...6))
                } else {
                    progress = CGFloat(Int.random(in: 94...100))
                }
                indicatorImageName = "spring"
                break
            case .summer:
                progress = CGFloat(Int.random(in: 17...25))
                indicatorImageName = "summer"
                break
            case .winter:
                progress = CGFloat(Int.random(in: 70...80))
                indicatorImageName = "winter"
            case .none:
                break
            }
            
            // troca de imagem do indicador de acordo com a estação e roda a animação
            let indicatorSeason = UICircularRingValueKnobStyle(size: 50, color: .clear, image: UIImage(named: indicatorImageName))
            progressSeasonPeripheral.valueKnobStyle = indicatorSeason
            progressSeasonPeripheral.startProgress(to: progress, duration: 3)
        }

    // Atualiza imagem da ilha no card
    func updateImage(island: PeripheralIsland?) {
        guard let island = island else {
            print("Island not found. Image will not be updated.")
            return
        }
        // Definindo estação
        let currentHealth = island.currentHealthStatus as! Double
        let lastHeath = island.lastHealthStatus as! Double
        let season = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath)
        if let imageNamed = season?.imageNamed {
            islandImage.image = UIImage(named: imageNamed)
        }
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
            if let island = self.peripheralIsland {
                newFixedContentCell.loadContents(island: island)
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
        customAlert.islandSceneServices = self.islandSceneServices
        
        CustomAlertServices().presentAsAlert(show: customAlert, over: self)
    }
}

extension PeripheralCardViewController: ActionCustomAlertViewDelegate {
    
    func reloadActionsTableView() {
        self.updateDataFromDatabase()
        self.actionsTableView.reloadData()
    }
}
