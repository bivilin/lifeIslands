//
//  CardViewController.swift
//  LifeTree
//
//  Created by Victoria Andressa S. M. Faria on 29/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit
import UICircularProgressRing

class CardViewController: UIViewController{
    
    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var phrase: UILabel!
    
    @IBOutlet weak var progressSeason: UICircularProgressRing!
    
//    let dropsMock = CGFloat(Int.random(in: 0...100))/100
    
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
                }
            }
        }
    }
    
    func loadProgress() {
        
        let dropsMock = CGFloat(Int.random(in: 0...100))/100
        
        let moodPercentuation = dropsMock
    
        var progress: CGFloat = 0
        var indicatorImageName = ""
        
        if moodPercentuation >= 0.0 && moodPercentuation <= 0.2 {
            progress = CGFloat(Int.random(in: 70...80))
            indicatorImageName = "winter"
        } else if moodPercentuation >= 0.21 && moodPercentuation <= 0.5 {
            progress = CGFloat(Int.random(in: 45...55))
            indicatorImageName = "autumn"
        } else if moodPercentuation >= 0.51 && moodPercentuation <= 0.7 {
            progress = CGFloat(Int.random(in: 17...25))
            indicatorImageName = "summer"
        } else if moodPercentuation >= 0.71 && moodPercentuation <= 1.0 {
            let i = Int.random(in: 1...10)
            if i % 2 == 0 {
                progress = CGFloat(Int.random(in: 1...6))
            } else {
                progress = CGFloat(Int.random(in: 94...100))
            }
            indicatorImageName = "spring"
        }
        
//        switch moodPercentuation {
//        case 0.2:
//            progress = 75
//            indicatorImageName = "winter"
//        case 0.4:
//            progress = 50
//            indicatorImageName = "autumn"
//        case 0.6:
//            progress = 22
//            indicatorImageName = "summer"
//        case 0.8:
//            progress = 17
//            indicatorImageName = "summer"
//        default:
//            progress = 100
//            indicatorImageName = "spring"
//        }
        
        let indicatorSeason = UICircularRingValueKnobStyle(size: 60, color: .clear, image: UIImage(named: indicatorImageName))
        progressSeason.valueKnobStyle = indicatorSeason
        progressSeason.startProgress(to: progress, duration: 3)
        print(progress)
    }
    
    
} // end class

