//
//  SelectIslandsViewController.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 03/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

// Struct é utilizado no array para popular a TableView
struct LifeArea {
    var name: String
    // Getter é utilizado para que a imagem esteja sempre associada ao nome da área da vida
    var icon: UIImage {
        get {
            return UIImage(named: self.name) ?? UIImage()
        }
    }
    var selected: Bool = false
}

class SelectIslandsViewController: UIViewController {

    var easterEggMode: Bool = false
    @IBOutlet weak var lifeAreasTableView: UITableView!
    var lifeAreas:[LifeArea] = [
        LifeArea(name: "Autocuidado"),
        LifeArea(name: "Família"),
        LifeArea(name: "Amigos"),
        LifeArea(name: "Relacionamento"),
        LifeArea(name: "Trabalho"),
        LifeArea(name: "Estudos"),
        LifeArea(name: "Financeiro"),
        LifeArea(name: "Lazer"),
        LifeArea(name: "Espiritual")]
    var customizedLifeAreas: [LifeArea] = []

    // Manejo dos dados a serem incluídos
    var infoHandler = InformationHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView Setup e Design
        self.lifeAreasTableView.delegate = self
        self.lifeAreasTableView.dataSource = self
        self.lifeAreasTableView.separatorStyle = .none


        // Implements easter egg gesture for customizing islands
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleEasterEggPanGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
    }

    @objc func handleEasterEggPanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.numberOfTouches == 3 {
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlert") as! CustomAlertViewController
            customAlert.alertTitle = "Ilhas Customizadas! Você descobriu nosso segredo!"
            customAlert.alertDescription = "Dê o nome da sua ilha e clique em OK. Você pode repetir esse processo para até 12 ilhas. Para concluir, clique X."
            customAlert.hasTextField = true
            customAlert.hasBottomButton = true
            customAlert.delegate = self
            CustomAlertServices().presentAsAlert(show: customAlert, over: self)
        }
    }



    // Ao clicar no botão, as ilhas selecionadas são criadas no banco
    @IBAction func nextButton(_ sender: Any) {

        var numberOfSelectedAreas: Int = 0

        // Somente as ilha selecionadas são incluídas no vetor que será persistido
        for lifeArea in lifeAreas {
            if lifeArea.selected {
                if lifeArea.name == "Trabalho" {
                    infoHandler.addPeripheralIslandToArray(category: lifeArea.name, name: lifeArea.name, healthStatus: 33)
                } else {
                    infoHandler.addPeripheralIslandToArray(category: lifeArea.name, name: lifeArea.name, healthStatus: 50)
                }

                numberOfSelectedAreas += 1
            }
        }

        if numberOfSelectedAreas > 2 {
            // O segue só é feito depois que a ilha é adicionada com sucesso no banco
            infoHandler.addAllPeripheralIslandsToDatabase {
                self.performSegue(withIdentifier: "fromSelectIslandToNameIsland", sender: self)
            }
        } else {
            // Alerta
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlert") as! CustomAlertViewController
            customAlert.alertTitle = "Ops..."
            customAlert.alertDescription = "Você precisa selecionar pelo menos três ilhas para continuar!"
            CustomAlertServices().presentAsAlert(show: customAlert, over: self)
        }
    }
}

extension SelectIslandsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if easterEggMode {
                return customizedLifeAreas.count
            } else {
                return lifeAreas.count
            }
        default:
            return 1
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        // Célula única de conteúdo fixo acima da lista de áreas da vida
        case 0:
            let newFixedContentCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "titleHeader", for: indexPath)
            newFixedContentCell.selectionStyle = .none
            return newFixedContentCell
        case 1:
            // Lista de Áreas da Vida Padrão
            let lifeAreaTableCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "lifeAreaCell", for: indexPath) as! LifeAreaTableViewCell
            var lifeArea = lifeAreas[indexPath.row]
            // Muda conteúdo no caso de easterEgg
            if easterEggMode {
                lifeArea = customizedLifeAreas[indexPath.row]
            }
            lifeAreaTableCell.loadContents(island: lifeArea)
            return lifeAreaTableCell
        default:
            return UITableViewCell()
        }
    }

    // Seleção da célula troca o estado dela entre selecionado/deselecionado
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            lifeAreas[indexPath.row].selected = !lifeAreas[indexPath.row].selected

            // Reload é necessário para carregar modificações visuais do novo estado
            lifeAreasTableView.reloadData()
        }
    }
}

extension SelectIslandsViewController: CustomAlertViewDelegate {
    func bottomButtonAction(alert: CustomAlertViewController) {
        easterEggMode = true
        if let islandName = alert.inputTextField.text {
            let newLifeArea = LifeArea(name: islandName)
            customizedLifeAreas.append(newLifeArea)
            print("Ilha \(islandName) adicionada com sucesso. Clique em OK para adicionar mais uma ilha. Clique em X para concluir")
            alert.inputTextField.text = ""
        }
    }

    func dismisButtonAction(alert: CustomAlertViewController) {
        if easterEggMode == true {
            lifeAreasTableView.reloadData()
        }
    }
}
