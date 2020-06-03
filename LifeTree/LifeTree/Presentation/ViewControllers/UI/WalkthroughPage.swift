//
//  WalkthroughPageController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 01/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

protocol WalkthroughDelegate {
    func didPressStartButton()
}

class WalkthroughPage: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var walkthroughDelegate: WalkthroughDelegate? = nil
    
    @IBAction func startButtonAction(_ sender: Any) {
        if let delegate: WalkthroughDelegate = self.walkthroughDelegate {
            delegate.didPressStartButton()
        }
    }
    
}
