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
    }
}
