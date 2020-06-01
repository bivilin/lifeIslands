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
    
    // Não funciona se abrirmos em cima de um modal
    func presentAsAlert(show customAlert: UIViewController, over context: UIViewController) {
        
        // Set up presentation mode
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        // Present alert
        context.present(customAlert, animated: true, completion: nil)
    }
    
}
