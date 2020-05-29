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
    var islandID: UUID?

    var numberOfDrops: Int = 1
    var island = PeripheralIsland()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up interface
        cultivateButton.layer.cornerRadius = 10
        self.displayDrops()
        self.phraseLabel.text = "Ao fazer essa atividade, você ganhou \(self.numberOfDrops) gotas para cultivar essa área"
    }
    
    @IBAction func cultivateButtonAction(_ sender: Any) {
        self.updateHealth()
    }
    
    func updateHealth() {
        print("===== ATUALIZANDO SAÚDE =====")
        self.island.lastHealthStatus = self.island.currentHealthStatus
        if let currentHealth = self.island.currentHealthStatus {
            self.island.currentHealthStatus = Double(truncating: currentHealth) * 1.1 as NSNumber
        }
        self.island.lastActionDate = Date()

        PeripheralIslandDataServices.updatePeripheralIsland(island: island) { (error) in
            if error == nil {
                PeripheralIslandDataServices.findById(objectID: self.island.islandId ?? UUID()) { (error, island) in
                    print("Saúde Atualizada com sucesso.")
                    print("Saúde Atual: \(String(describing: island?.currentHealthStatus))")
                    print("Saúde Anterior: \(island?.lastHealthStatus ?? 0)")
                    self.performSegue(withIdentifier: "unwindToPeriphalIslandAfterActionIsDone", sender: self)
                }
            }
        }
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
}
