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
    @IBOutlet weak var impactLevelSlider: UISlider!
    @IBOutlet weak var impactLevelLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura delegate para o TextField
        self.actionNameTextField.delegate = self

        // Adiciona gestos na interface
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
    }

    // MARK: Gestures

    // Single Tap
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Esconde o teclado quando o usuário clica fora dele
        self.view.endEditing(true)
    }

    // Altera label quando há movimentação do slider
    @IBAction func impactLevelChanged(_ sender: Any) {
        impactLevelLabel.text = String(format: "%.2f", impactLevelSlider.value * 100) + "%"
    }

    // MARK: Buttons
    @IBAction func confirmButton(_ sender: Any) {

        // Cria Ação com dados inputados na UI
        let action = Action()

        action.actionId = UUID()
        action.name = actionNameTextField.text
        action.impactLevel = NSNumber(value: impactLevelSlider.value)

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

    // Esconde o teclado quando usuário aperta a tecla "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
