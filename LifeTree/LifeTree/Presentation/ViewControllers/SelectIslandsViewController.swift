//
//  SelectIslandsViewController.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 03/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

struct LifeArea {
    var name: String
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
        LifeArea(name: "Finanças"),
        LifeArea(name: "Lazer"),
        LifeArea(name: "Espiritual")]

    var infoHandler = InformationHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lifeAreasTableView.delegate = self
        self.lifeAreasTableView.dataSource = self
        self.lifeAreasTableView.separatorStyle = .none

    }
    @IBAction func nextButton(_ sender: Any) {
        for lifeArea in lifeAreas {
            infoHandler.addPeripheralIslandToArray(category: lifeArea.name, name: lifeArea.name, healthStatus: 50)
        }
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
        // Célula única de conteúdo fixo acima da lista de ações
        case 0:
            let newFixedContentCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "titleHeader", for: indexPath)
            newFixedContentCell.selectionStyle = .none
            return newFixedContentCell
        case 1:
            // Lista de ações
            let lifeAreaTableCell = self.lifeAreasTableView.dequeueReusableCell(withIdentifier: "lifeAreaCell", for: indexPath) as! LifeAreaTableViewCell
            let lifeArea = lifeAreas[indexPath.row]
            lifeAreaTableCell.loadContents(island: lifeArea)
            return lifeAreaTableCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            lifeAreas[indexPath.row].selected = !lifeAreas[indexPath.row].selected
            //tableView.reloadData()
        }
    }


}
