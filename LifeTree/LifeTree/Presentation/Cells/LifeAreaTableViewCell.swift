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


    override func awakeFromNib() {
        super.awakeFromNib()

        // Definindo estilo arredondado e sombreamento
        self.contourView.layer.cornerRadius = 6
        self.contourView.layer.masksToBounds = false
        self.contourView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contourView.layer.shadowColor = UIColor.black.cgColor
        self.contourView.layer.shadowOpacity = 0.10
        self.contourView.layer.shadowRadius = 4

        self.lifeAreaLabel.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)
        self.selectionStyle = .none
    }

    // Método para popular conteúdos da célula (texto e imagem)
    func loadContents(islandName: String) {
        //self.islandTextField.placeholder = islandName
        self.lifeAreaLabel.text = islandName
    }
}
