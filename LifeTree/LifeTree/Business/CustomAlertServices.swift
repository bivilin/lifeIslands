//
//  CustomAlertServices.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 28/05/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import Foundation
import UIKit

class CustomAlertServices {
    
    func presentAsAlert(show customAlert: UIViewController, over context: UIViewController) {
        
        // Set up background to mimic the iOS native Alert
        customAlert.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Set up presentation mode
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Present alert
        context.present(customAlert, animated: true, completion: nil)
    }
    
}
