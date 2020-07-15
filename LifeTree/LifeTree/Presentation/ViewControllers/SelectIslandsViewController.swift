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

    @IBOutlet weak var lifeAreasTableView: UITableView!
    // Áreas da vida predefinidas
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

    // Manejo dos dados a serem incluídos
    var infoHandler = InformationHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        // TableView Setup e Design
        self.lifeAreasTableView.delegate = self
        self.lifeAreasTableView.dataSource = self
        self.lifeAreasTableView.separatorStyle = .none
    }

    func createCustomIslandAlert() {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlert") as! CustomAlertViewController
        customAlert.alertTitle = "Adicionar área da vida"
        customAlert.hasTextField = true
        customAlert.hasBottomButton = true
        customAlert.delegate = self
        CustomAlertServices().presentAsAlert(show: customAlert, over: self)
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
            return lifeAreas.count + 1
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
            if indexPath.row == 0 {
                // Tratamento da primeira célula-botão de adicionar uma ilha cus
                let newIslandCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "newIslandCell", for: indexPath) as! AddNewItemTableViewCell
                return newIslandCell
            } else {
                // Lista de Áreas da Vida Padrão
                let lifeAreaTableCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "lifeAreaCell", for: indexPath) as! LifeAreaTableViewCell
                var lifeArea = lifeAreas[indexPath.row - 1]
                lifeAreaTableCell.loadContents(island: lifeArea)
                return lifeAreaTableCell            }
        default:
            return UITableViewCell()
        }
    }

    // Seleção da célula troca o estado dela entre selecionado/deselecionado
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                // Abre um popup para incluir o nome da nova ilha
                createCustomIslandAlert()
            } else {
                // Altera o estado on/off da ilha
                lifeAreas[indexPath.row - 1].selected = !lifeAreas[indexPath.row - 1].selected
                lifeAreasTableView.reloadData()
            }
        }
    }
}

extension SelectIslandsViewController: CustomAlertViewDelegate {
    func bottomButtonAction(alert: CustomAlertViewController) {
        if let islandName = alert.inputTextField.text {
            // Adiciona nova ilha com o nomem inputado
            let newLifeArea = LifeArea(name: islandName)
            lifeAreas.append(newLifeArea)
            alert.dismiss(animated: true, completion: nil)
            lifeAreasTableView.reloadData()
        }
    }

    func dismisButtonAction(alert: CustomAlertViewController) {
        lifeAreasTableView.reloadData()
    }
}
