//
//  RegistrationViewController.swift
//  DreamDestination
//
//  Created by kuroro on 24/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordtextField: UITextField!

    // MARK: Properties
    private let loadingViewController = LoadingViewController()
    private let userController = UserController()
    
    // MARK: Methods
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    private func validateTextField() -> String? {
        guard nameTextField.text != "" ||
            firstNameTextField.text != "" ||
            emailTextField.text != "" ||
            passwordtextField.text != "" else {
                return "Veuillez saisir votre e-mail ainsi que votre mot de passe avant de continuer."
        }
        
        guard let password = passwordtextField.text else {
            return "Votre mot de passe doit contenir au moins 8 charactères, dont un chiffre et un caractère spécial."
        }
        
        if !isPasswordValid(password) {
            return "Votre mot de passe doit contenir au moins 8 charactères, dont un chiffre et un caractère spécial."
        }
        
        return nil
    }

    private func signUp() {
        add(loadingViewController)
        let error = validateTextField()
        let email = emailTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = nameTextField.text ?? ""
        let password = passwordtextField.text ?? ""
        
        guard error == nil else {
            loadingViewController.remove()
            presentAlert(message: error ?? AlertMessage().programError, title: "Oups !")
            return
        }
        
        userController.inscription(email: email, password: password) { (result) in
            switch result {
            case .failure(let error):
                self.loadingViewController.remove()
                self.presentAlert(message: error.errorDescription(), title: "Oups !")
            case .success(let result):
                self.userController.addNewUserToDB(lastName: lastName, firstName: firstName, uid: result.user.uid, email: email) { (success) in
                    if success {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.loadingViewController.remove()
                        self.presentAlert(message: AlertMessage().programError, title: "Oups !")
                    }
                }
            }
        }
    }

    // MARK: IBAction
    @IBAction func didTapSignUpButton(_ sender: Any) {
        signUp()
    }
}

// MARK: TextField gestion
extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        signUp()
        return true
    }
}
