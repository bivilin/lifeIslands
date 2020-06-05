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

    // Ao clicar no botão, as ilhas selecionadas são criadas no banco
    @IBAction func nextButton(_ sender: Any) {

        // Somente as ilha selecionadas são incluídas no vetor que será persistido
        for lifeArea in lifeAreas {
            if lifeArea.selected {
                infoHandler.addPeripheralIslandToArray(category: lifeArea.name, name: lifeArea.name, healthStatus: 50)
            }
        }

        // O segue só é feito depois que a ilha é adicionada com sucesso no banco
        infoHandler.addAllPeripheralIslandsToDatabase {
            self.performSegue(withIdentifier: "fromSelectIslandToNameIsland", sender: self)
        }
    }
}

extension SelectIslandsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return lifeAreas.count
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
            let lifeArea = lifeAreas[indexPath.row]
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
