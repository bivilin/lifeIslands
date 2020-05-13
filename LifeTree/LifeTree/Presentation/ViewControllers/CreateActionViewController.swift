//
//  EditActionViewController.swift
//  LifeTree
//
//  Created by Joyce Simão Clímaco on 24/04/20.
//  Copyright © 2020 Beatriz Viseu Linhares. All rights reserved.
//

import UIKit

class CreateActionViewController: UIViewController {

    var island: PeripheralIsland?
    @IBOutlet weak var actionNameTextField: UITextField!
    @IBOutlet weak var impactReasonTextField: UITextField!
    @IBOutlet weak var impactLevelSlider: UISlider!
    @IBOutlet weak var impactLevelLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    var currentTextField: UITextField?
    var scrolledByKeyboard: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura delegate para os TextField
        self.actionNameTextField.delegate = self
        self.impactReasonTextField.delegate = self

        // Reconhece quando o usuário inputa algo na textField e gatilha o .keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)


        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Adiciona gestos na interface
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
    }

    // MARK: Keyboard Handling

    // Ajusta posição da ScrollView quando teclado aparece
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        // Posição Y do TextField selecionado
        let activeFieldMaxY = self.currentTextField!.frame.maxY - self.scrollView.contentOffset.y

        // Valor máximo do Y para que não seja sobreposto pelo teclado
        let maxVisibleY = self.scrollView.frame.height - keyboardFrame.height

        // Se TextField seria coberto, scrolla o conteúdo para cima
        if activeFieldMaxY >= maxVisibleY {
            self.scrollView.contentOffset.y += keyboardFrame.height
            scrolledByKeyboard = true
        }
    }

    // Ajusta posição da ScrollView quando o teclado desaparece
    @objc func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        // Se a tela foi scrollada, retorna para a posição anterior
        if scrolledByKeyboard {
            self.scrollView.contentOffset.y -= keyboardFrame.height
        }

        // Atualiza flag para posição padrão, sem scroll
        scrolledByKeyboard = false
    }

    // MARK: Gestures

    // Single Tap
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Esconde o teclado quando o usuário clica fora dele
        self.view.endEditing(true)
    }

    // MARK: Buttons

    // Altera label quando há movimentação do slider
    @IBAction func impactLevelChanged(_ sender: Any) {
        impactLevelLabel.text = String(format: "%.2f", impactLevelSlider.value * 100) + "%"
    }

    @IBAction func confirmButton(_ sender: Any) {

        // Cria Ação com dados inputados na UI
        let action = Action()

        action.actionId = UUID()
        action.name = actionNameTextField.text
        action.impactLevel = NSNumber(value: impactLevelSlider.value)
        action.impactReason = impactReasonTextField.text

        if let relatedIsland = self.island {
            // Persiste ação no banco de dados
            ActionDataServices.createAction(action: action, relatedIsland: relatedIsland) { (error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                    print("Ação criada com sucesso.")
                }
            }
        } else {
            print("Objeto Ilha Periférica não foi carregado nessa classe")
        }

        // Retorna para a PeripheralCardViewController
        self.performSegue(withIdentifier: "unwindToPeriphalIsland", sender: nil)
    }
}

    // MARK: Text Field Delegate

extension CreateActionViewController: UITextFieldDelegate {

    // Atualiza TextField sendo editado no momento
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }

    // Esconde o teclado quando usuário aperta a tecla "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
