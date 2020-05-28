//
//  CustomAlertViewController.swift
//  
//
//  Created by Joyce Simão Clímaco on 28/05/20.
//

import Foundation
import UIKit

protocol CustomAlertViewDelegate {
    func bottomButtonAction()
}

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var alertDetailsView: UIView!
    
    var alertTitle: String = ""
    var alertDescription: String = ""
    var hasBottomButton: Bool = false
    var hasDismissButton: Bool = true
    
    var delegate: CustomAlertViewDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update labels
        self.titleLabel.text = self.alertTitle
        self.descriptionLabel.text = self.alertDescription
        
        // Set up cornerRadius
        self.dismissButton.layer.cornerRadius = self.dismissButton.frame.width/2
        let cornerRadius: CGFloat = 15
        self.bottomButton.layer.cornerRadius = cornerRadius
        self.alertDetailsView.layer.cornerRadius = cornerRadius
        
        // Hide or show bottom buttons
        self.bottomButton.isHidden = !self.hasBottomButton
        self.dismissButton.isHidden = !self.hasDismissButton
    }
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        self.delegate?.bottomButtonAction()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
