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
    }

    @IBAction func impactLevelChanged(_ sender: Any) {
        impactLevelLabel.text = String(format: "%.2f", impactLevelSlider.value * 100) + "%"
    }

    @IBAction func confirmButton(_ sender: Any) {
        let action = Action()

        action.actionId = UUID()
        action.name = actionNameTextField.text
        action.impactLevel = NSNumber(value: impactLevelSlider.value)

        if let relatedIsland = self.island {
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
        self.performSegue(withIdentifier: "unwindToPeriphalIsland", sender: nil)
    }
}
