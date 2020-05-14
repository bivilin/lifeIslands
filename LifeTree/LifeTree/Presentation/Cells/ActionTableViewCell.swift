//
//  ActionTableViewCell.swift
//  LifeTree
//
//  Created by Beatriz Viseu Linhares on 11/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dropImage: UIImageView!
    @IBOutlet weak var contourView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.label.numberOfLines = 0
        self.label.lineBreakMode = .byWordWrapping


        // Definindo borda e estilo arredondado
        self.contourView.layer.borderWidth = 1
        self.contourView.backgroundColor = UIColor.white
        self.contourView.layer.cornerRadius = 6
        self.contourView.layer.borderColor = UIColor.white.cgColor

        self.contourView.layer.masksToBounds = false
        self.contourView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contourView.layer.shadowColor = UIColor.black.cgColor
        self.contourView.layer.shadowOpacity = 0.10
        self.contourView.layer.shadowRadius = 4
    }
}
