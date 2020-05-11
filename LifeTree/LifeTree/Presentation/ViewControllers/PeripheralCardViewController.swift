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
}
