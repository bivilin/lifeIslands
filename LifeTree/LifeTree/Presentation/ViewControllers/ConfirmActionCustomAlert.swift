//
//  ConfirmActionCustomAlert.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 19/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class ConfirmActionCustomAlert: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var actionDetailsView: UIView!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet var dropImages: [UIImageView]!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteActionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let cornerRadius: CGFloat = 10
        self.actionDetailsView.layer.cornerRadius = cornerRadius
        self.confirmButton.layer.cornerRadius = cornerRadius
        self.deleteActionButton.layer.cornerRadius = cornerRadius
        self.closeButton.layer.cornerRadius = self.closeButton.frame.width/2
    }
}
