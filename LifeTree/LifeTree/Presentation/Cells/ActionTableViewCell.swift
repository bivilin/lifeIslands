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

        // Permitindo múltiplas linhas na célula da TableView
        self.label.numberOfLines = 0
        self.label.lineBreakMode = .byWordWrapping


        // Definindo estilo arredondado e sombreamento
        self.contourView.layer.cornerRadius = 6
        self.contourView.layer.masksToBounds = false
        self.contourView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.contourView.layer.shadowColor = UIColor.black.cgColor
        self.contourView.layer.shadowOpacity = 0.10
        self.contourView.layer.shadowRadius = 4
        self.selectionStyle = .none
    }

    // Método para popular conteúdos da célula (texto e imagem)
    func loadContents(action: Action) {
        self.label?.text = action.name
        // Altera imagem de acordo com o nível de impacto da ação
        do {
            try self.setDropImage(impactLevel: action.impactLevel as! Double)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    // Altera a imagem da gota na célula de acordo com o nível de impacto da ação
    func setDropImage(impactLevel: Double) throws {
        switch impactLevel {
        case 1:
            dropImage.image = UIImage(named: "drop1")
        case 2:
            dropImage.image = UIImage(named: "drop2")
        case 3:
            dropImage.image = UIImage(named: "drop3")
        case 4:
            dropImage.image = UIImage(named: "drop4")
        case 5:
            dropImage.image = UIImage(named: "drop5")
        default:
            dropImage.image = nil
            throw Errors.InvalidImpactLevel
        }
    }
}
