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
    var selectedIslands: [LifeArea]?
    var infoHandler = InformationHandler()

    var scrolledByKeyboard: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        
        // Reconhece quando o usuário inputa algo na textField e gatilha o .keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func nexButtonAction(_ sender: Any) {
        
        if self.textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            // string contains non-whitespace characters
            
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlert") as! CustomAlertViewController
            customAlert.alertTitle = "Ops..."
            customAlert.alertDescription = "Você deve escrever seu nome - ou a maneira como quer ser chamado - antes de prosseguir!"
            CustomAlertServices().presentAsAlert(show: customAlert, over: self)
        } else {
            
            // Changes userDefault so that the SceneDelegate knows the user has already done the app's onboarding and therefore change the initial ViewController
            UserDefaults.standard.set(true, forKey: "notFirstInApp")
            
            // Nome do usuário é persistido na ilha central
            if let userName = textField.text {
                // O segue para a próxima tela só é feito após a criação do dado ter sido feita com sucesso.
                self.loadData(name: userName) {
                    self.performSegue(withIdentifier: "fromNameIslandToMainScreen", sender: self)
                }
            }
        }
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
            self.scrollView.contentOffset.y += maxVisibleY - keyboardFrame.height
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
            self.scrollView.contentOffset.y -= (self.scrollView.frame.height - keyboardFrame.height) - keyboardFrame.height
        }

        // Atualiza flag para posição padrão, sem scroll
        self.scrolledByKeyboard = false
    }

    // MARK: Create Core Data

    func loadData(name: String, completion: @escaping () -> Void) {
        if let selectedIslands = selectedIslands {
            for selectedIsland in selectedIslands {
                    infoHandler.addPeripheralIslandToArray(category: selectedIsland.name, name: selectedIsland.name, healthStatus: 50)
            }
        }

        // O segue só é feito depois que a ilha é adicionada com sucesso no banco
        infoHandler.addAllPeripheralIslandsToDatabase {
            self.infoHandler.createSelf(name: name, currentHealth: 50) {
                completion()
            }
        }
    }
}
