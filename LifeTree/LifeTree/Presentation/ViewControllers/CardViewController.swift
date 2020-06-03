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
    
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var progressSeason: UICircularProgressRing!
    @IBOutlet weak var statusDescriptionLabel: UILabel!
    @IBOutlet weak var islandSKView: SKView!
    
    var selfIsland: SelfIsland?
    var islandSKScene = SKScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up self island SKScene
        self.islandSKView.allowsTransparency = true
        self.islandSKView.presentScene(islandSKScene)
        
        // colocando a linha do pod em cima do circulo imagem
        progressSeason.style = .ontop
        
        SelfIslandDataServices.getFirstSelfIsland { (error, selfIsland) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if let selfIsland = selfIsland {
                    self.selfIsland = selfIsland
                    self.nameIsland.text = selfIsland.name
                }
            }
        }
    }
    
    func loadProgress() {
        
        //carrega dados da saude e define as estaçoes.
        guard let currentHealth = selfIsland?.currentHealthStatus as? Double else {return}
        let lastHeath = selfIsland?.lastHealthStatus as! Double
        let season = UpdateIslandsHealth.getSeason(currentHealth: currentHealth, lastHealth: lastHeath)
        seasonLabel.text = season?.name
        statusDescriptionLabel.text = season?.description
        
        //random para testar os circulos, substituir o season por : CGFloat(Int.random(in: 0...100))/100
        
        var progress: CGFloat = 0
        var indicatorImageName = ""

        // swift para saber em que ponto do circulo o calculo irá cair
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
        case .none:
            break
        }
        
        // troca de imagem do indicador de acordo com a estação e roda a animação.
        let indicatorSeason = UICircularRingValueKnobStyle(size: 60, color: .clear, image: UIImage(named: indicatorImageName))
        progressSeason.valueKnobStyle = indicatorSeason
        progressSeason.startProgress(to: progress, duration: 3)
        print(progress)
    }
}

