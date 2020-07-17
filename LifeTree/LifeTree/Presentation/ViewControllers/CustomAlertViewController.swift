//
//  CustomAlertViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 29/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

protocol CustomAlertViewDelegate {
    func bottomButtonAction(alert: CustomAlertViewController)
    func dismisButtonAction(alert: CustomAlertViewController)
}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var alertDetailsView: UIView!
    @IBOutlet weak var inputTextField: UITextField!

    var alertTitle: String = ""
    var alertDescription: String = ""
    var hasBottomButton: Bool = false
    var hasDismissButton: Bool = true
    var hasTextField: Bool = false

    var delegate: CustomAlertViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background to mimic the iOS native Alert
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)

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
        self.inputTextField.isHidden = !self.hasTextField
    }

    @IBAction func bottomButtonAction( sender: Any) {
        self.delegate?.bottomButtonAction(alert: self)
    }

    @IBAction func dismissButtonAction( sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.dismisButtonAction(alert: self)
    }

}
