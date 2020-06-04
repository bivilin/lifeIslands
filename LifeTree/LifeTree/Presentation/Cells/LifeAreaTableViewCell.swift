//
//  LifeAreaTableViewCell.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 03/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class LifeAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var contourView: UIView!
    @IBOutlet weak var islandTextField: UITextField!
    @IBOutlet weak var lifeAreaLabel: UILabel!
    @IBOutlet weak var lifeAreaIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Definindo estilo arredondado e sombreamento
        self.contourView.layer.cornerRadius = 6
        self.contourView.layer.masksToBounds = false
        self.contourView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contourView.layer.shadowColor = UIColor.black.cgColor
        self.contourView.layer.shadowOpacity = 0.10
        self.contourView.layer.shadowRadius = 4

        self.lifeAreaLabel.textColor = .textColor
        self.selectionStyle = .none
    }

    // Método para popular conteúdos da célula (texto e imagem)
    func loadContents(island: LifeArea) {
        // Nome da ilha
        self.lifeAreaLabel.text = island.name

        // Config para usar pdf como imagem
        let tintableImage = island.icon.withRenderingMode(.alwaysTemplate)
        lifeAreaIcon.image = tintableImage

        // Diferenciação visual de célula selecionada e não selecionada
        if island.selected {
            self.contourView.backgroundColor = .selectionColor
            self.lifeAreaLabel.textColor = .white
            self.lifeAreaIcon.tintColor = .white
        }
        else {
            self.contourView.backgroundColor = .white
            self.lifeAreaLabel.textColor = .textColor
            self.lifeAreaIcon.tintColor = .selectionColor
        }
    }
}
