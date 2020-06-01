//
//  FixedContentCell.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 20/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import SpriteKit

class FixedContentCell: UITableViewCell {

    var peripheralIsland: PeripheralIsland?
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var islandSKView: SKView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    // Carrega SKScene e infos das labels
    func loadContents(island: PeripheralIsland, scene: SKScene) {

        // Set up the SKView for the island
        self.islandSKView?.presentScene(scene)
        self.islandSKView?.allowsTransparency = true

        // Definindo estação
        let currentHealth = island.currentHealthStatus as! Double
        let lastHeath = island.lastHealthStatus as! Double
        let season = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath)
        self.seasonLabel.text = season?.name
        self.seasonLabel.textColor = season?.color

        // Definindo texto da estação
        self.statusDescriptionLabel.text = season?.description
    }

}
