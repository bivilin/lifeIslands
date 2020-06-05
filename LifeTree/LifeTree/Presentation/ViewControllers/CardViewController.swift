//
//  CardViewController.swift
//  LifeTree
//
//  Created by Victoria Andressa S. M. Faria on 29/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import UICircularProgressRing
import SpriteKit
import SceneKit

class CardViewController: UIViewController{
    
    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var phrase: UILabel!
    @IBOutlet weak var islandImage: UIImageView!

    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var progressSeason: UICircularProgressRing!
    @IBOutlet weak var statusDescriptionLabel: UILabel!

    var selfIsland: SelfIsland?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // colocando a linha do pod em cima do circulo imagem
        progressSeason.style = .ontop
        
        SelfIslandDataServices.getFirstSelfIsland { (error, selfIsland) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if let selfIsland = selfIsland {
                    self.selfIsland = selfIsland
                    self.nameIsland.text = selfIsland.name
                    self.updateImage(island: self.selfIsland)
                }
            }
        }
    }
    
    func loadProgress() {

        // Define uma estação default para caso a ilha ainda não tenha sido carregada
        var season: Season = .spring

        if let island = selfIsland {
            //carrega dados da saude e define as estaçoes.
            let currentHealth = island.currentHealthStatus as! Double
            let lastHeath = island.lastHealthStatus as! Double
            if let newSeason = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath) {
                season = newSeason
            }
        }

        // Atualiza UI para a nova estação
        self.seasonLabel.text = season.name
        self.seasonLabel.textColor = season.color
        self.islandImage.image = UIImage(named: season.imageNamed)
        self.statusDescriptionLabel.text = season.description
        
        //random para testar os circulos, substituir o season por : CGFloat(Int.random(in: 0...100))/100
        var progress: CGFloat = 0
        var indicatorImageName = ""

        // switch para saber em que ponto do circulo o calculo irá cair
        switch season {
        case .autumn:
            progress = CGFloat(Int.random(in: 45...55))
            indicatorImageName = "autumn"
        case .spring:
            let i = Int.random(in: 1...10)
            if i % 2 == 0 {
                progress = CGFloat(Int.random(in: 1...6))
            } else {
                progress = CGFloat(Int.random(in: 94...100))
            }
            indicatorImageName = "spring"
            break
        case .summer:
            progress = CGFloat(Int.random(in: 17...25))
            indicatorImageName = "summer"
            break
        case .winter:
            progress = CGFloat(Int.random(in: 70...80))
            indicatorImageName = "winter"
        }
        
        // troca de imagem do indicador de acordo com a estação e roda a animação.
        let indicatorSeason = UICircularRingValueKnobStyle(size: 60, color: .clear, image: UIImage(named: indicatorImageName))
        progressSeason.valueKnobStyle = indicatorSeason
        progressSeason.startProgress(to: progress, duration: 3)
        print(progress)
    }

    // Atualiza imagem da ilha no card
    func updateImage(island: SelfIsland?) {
        guard let island = island else {
            print("Island not found. Image will not be updated.")
            return
        }
        // Definindo estação
        let currentHealth = island.currentHealthStatus as! Double
        let lastHeath = island.lastHealthStatus as! Double
        let season = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath)
        if let imageNamed = season?.imageNamed {
            islandImage.image = UIImage(named: imageNamed)
        }
    }
}

