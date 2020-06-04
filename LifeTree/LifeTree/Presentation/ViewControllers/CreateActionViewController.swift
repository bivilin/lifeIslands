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
    @IBOutlet weak var impactReasonTextView: UITextView!
    @IBOutlet weak var impactLevelSlider: UISlider!
    @IBOutlet weak var scrollView: UIScrollView!
    var isTextFieldSelected: Bool?
    var currentTextField: UITextField?
    var scrolledByKeyboard: Bool = false

    // Tratamento para caso a tela seja de edição, em vez de criação
    // Talvez substitua EditActionViewController
    var isViewForEditingAction: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura delegate para os TextField
        self.actionNameTextField.delegate = self
        self.impactReasonTextView.delegate = self

        // Reconhece quando o usuário inputa algo na textField e gatilha o .keyboardWillShowNotification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Adiciona gestos na interface
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(singleTap)

        // Imagem inicial do slider
        customizeSliderThumb()

        // Ajuste do campo de descrição
        self.impactReasonTextView.layer.borderWidth = 1
        self.impactReasonTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.impactReasonTextView.layer.cornerRadius = 5
    }

    // MARK: Keyboard Handling

    // Ajusta posição da ScrollView quando teclado aparece
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        var activeFieldMaxY: CGFloat = 0.0

        if self.isTextFieldSelected! {
            // Posição Y do TextField selecionado
            activeFieldMaxY = self.currentTextField!.frame.maxY - self.scrollView.contentOffset.y
        } else {
            activeFieldMaxY = self.impactReasonTextView.frame.maxY - self.scrollView.contentOffset.y
        }

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

    // MARK: Gestures

    // Single Tap
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        // Esconde o teclado quando o usuário clica fora dele
        self.view.endEditing(true)
    }

    // MARK: Slider

    // Altera label quando há movimentação do slider
    @IBAction func impactLevelChanged(_ sender: UISlider) {
        impactLevelSlider.value = roundf(impactLevelSlider.value)
        // Altera thumb do slider quando há movimentação
        customizeSliderThumb()
    }

    // Emoji do slider muda conforme o usuário altera a posição
    func customizeSliderThumb() {
        let imageName = "emoji" + String(impactLevelSlider.value)
        let dropImage = UIImage(named: imageName)
        let size = dropImage?.size
        let resizedDropImage = imageWithImage(image: dropImage ?? UIImage(), scaledToSize: CGSize(width: size!.width/2, height: size!.height/2))
        impactLevelSlider.setThumbImage(resizedDropImage, for: .normal)
    }

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    // MARK: Buttons
    
    @IBAction func confirmButton(_ sender: Any) {
        
        // Chack if action has a title
        if self.actionNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            // string contains non-whitespace characters
            
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlert") as! CustomAlertViewController
            customAlert.alertTitle = "Ops..."
            customAlert.alertDescription = "Você deve dar um nome à sua ação antes de salvá-la!"
            CustomAlertServices().presentAsAlert(show: customAlert, over: self)
        }
        else {
            // Cria Ação com dados inputados na UI
            let action = Action()
            
            action.actionId = UUID()
            action.name = actionNameTextField.text
            action.impactLevel = NSNumber(value: impactLevelSlider.value)
            action.impactReason = self.impactReasonTextView.text
            
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
}

    // MARK: Text Field Delegate

extension CreateActionViewController: UITextFieldDelegate {

    // Atualiza TextField sendo editado no momento
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isTextFieldSelected = true
        self.currentTextField = textField
    }

    // Esconde o teclado quando usuário aperta a tecla "return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
   // MARK: Text View Delegate

extension CreateActionViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.isTextFieldSelected = false
    }
}
