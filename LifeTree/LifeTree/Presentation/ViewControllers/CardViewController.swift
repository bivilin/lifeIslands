//
//  CardViewController.swift
//  LifeTree
//
//  Created by Victoria Andressa S. M. Faria on 29/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var nameIsland: UILabel!
    @IBOutlet weak var phrase: UILabel!
    
    var selfIsland: SelfIsland?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}
