//
//  ConfirmActionCustomAlert.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 19/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

protocol CustomAlertViewDelegate: class {
    func reloadActionsTableView()
}

class ActionCustomAlertViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var actionDetailsView: UIView!
    @IBOutlet weak var actionTitle: UILabel!
    @IBOutlet weak var actionDescription: UILabel!
    @IBOutlet var dropImages: [UIImageView]!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteActionButton: UIButton!
    
    var action = Action()
    var island = PeripheralIsland()
    var delegate: CustomAlertViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background to mimic the iOS native Alert
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Change corner Radius of major visual elements
        let cornerRadius: CGFloat = 10
        self.actionDetailsView.layer.cornerRadius = cornerRadius
        self.confirmButton.layer.cornerRadius = cornerRadius
        self.deleteActionButton.layer.cornerRadius = cornerRadius
        self.closeButton.layer.cornerRadius = self.closeButton.frame.width/2
        
        // Change the labels do it displays the information for the selected action
        self.actionTitle.text = self.action.name
        self.actionDescription.text = self.action.impactReason
        
        // Display the correct number of drops given by that action
        guard let numberOfDrops = self.action.impactLevel else {return}
        for i in 0...(dropImages.count - 1) {
            if i >= Int(truncating: numberOfDrops) {
                self.dropImages[i].isHidden = true
            }
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        performSegue(withIdentifier: "toCultivateIsland", sender: self)
    }
    
    @IBAction func dismissActionAlert(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        ActionDataServices.deleteAction(action: self.action) { (error) in
            print(error as Any)
        }
        self.delegate?.reloadActionsTableView()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCultivateIsland" {
            let destination = segue.destination as! CultivateIslandViewController
            guard let numberOfDrops = self.action.impactLevel else {return}
            destination.numberOfDrops = Int(truncating: numberOfDrops)
            destination.island = self.island
        }
    }
}
