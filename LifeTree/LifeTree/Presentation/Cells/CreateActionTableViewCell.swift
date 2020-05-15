//
//  CreateActionTableViewCell.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 14/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class CreateActionTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var contourView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()

        // Label design
        // TODO: Mudar para cor da identidade visual
        self.label.textColor = UIColor.lightGray
        self.label.text = "+ Adicionar nova"

        // Definindo estilo arredondado e sombreamento
        self.contourView.layer.cornerRadius = 6
        self.contourView.layer.masksToBounds = false
        self.contourView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contourView.layer.shadowColor = UIColor.black.cgColor
        self.contourView.layer.shadowOpacity = 0.10
        self.contourView.layer.shadowRadius = 4
    }
}
