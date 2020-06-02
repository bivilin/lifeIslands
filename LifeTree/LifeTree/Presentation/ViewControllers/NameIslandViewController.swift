//
//  NameIslandViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 02/06/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class NameIslandViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrolledByKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        // self.textField.resignFirstResponder()
        return true
    }

    // Ajusta posição da ScrollView quando teclado aparece
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        let activeFieldMaxY: CGFloat = self.textField.frame.maxY - self.scrollView.contentOffset.y

        // Valor máximo do Y para que não seja sobreposto pelo teclado
        let maxVisibleY = self.scrollView.frame.height - keyboardFrame.height

        // Se TextField seria coberto, scrolla o conteúdo para cima
        if activeFieldMaxY >= maxVisibleY {
            self.scrollView.contentOffset.y += keyboardFrame.height
            self.scrolledByKeyboard = true
        }
    }

    // Ajusta posição da ScrollView quando o teclado desaparece
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        // Se a tela foi scrollada, retorna para a posição anterior
        if self.scrolledByKeyboard {
            self.scrollView.contentOffset.y -= keyboardFrame.height
        }

        // Atualiza flag para posição padrão, sem scroll
        self.scrolledByKeyboard = false
    }
}
