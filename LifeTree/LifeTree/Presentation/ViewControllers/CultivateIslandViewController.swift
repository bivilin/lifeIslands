//
//  CultivateIslandViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 20/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class CultivateIslandViewController: UIViewController {
    
    @IBOutlet weak var dropsImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cultivateButton: UIButton!
    @IBOutlet weak var phraseLabel: UILabel!
    
    var numberOfDrops: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cultivateButton.layer.cornerRadius = 10
        self.displayDrops()
        self.phraseLabel.text = "Ao fazer essa atividade, você ganhou \(self.numberOfDrops) gotas para cultivar essa área"
    }
    
    func displayDrops() {
        
        var image: UIImage? = UIImage()
        switch self.numberOfDrops {
        case 1:
            image = UIImage(named: "1drop")
        case 2:
            image = UIImage(named: "2drops")
        case 3:
            image = UIImage(named: "3drops")
        case 4:
            image = UIImage(named: "4drops")
        default:
            image = UIImage(named: "5drops")
        }
        self.dropsImageView.image = image
    }
    
    @IBAction func cultivateButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "unwindToPeriphalIslandAfterActionIsDone", sender: self)
    }
}
