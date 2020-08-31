//
//  ConnexionServiceController.swift
//  DreamDestination
//
//  Created by kuroro on 06/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

protocol SignInProtocol {
     func signIn(_ email: String, _ password: String)
}

class ConnexionController: UIViewController {
    // MARK: Properties
    private var connexionScreen = ConnexionScreenController.instantiate()
    private lazy var stateController = StateController()
    private let userController = UserController()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        add(stateController)
        connexionScreen.delegate = self
        stateController.transition(to: .render(connexionScreen))
    }

    // MARK: Methods
    private func checkIfTextFieldsAreNotEmpty(_ email: String, _ password: String) -> Bool {
        if email == "" || password == "" {
            return false
        }
        return true
    }
    
    private func processToAuthentification(_ email: String, _ password: String) {
        stateController.transition(to: .loading)
        if checkIfTextFieldsAreNotEmpty(email, password) {
            userController.connexion(email: email, password: password) { (error) in
                self.stateController.transition(to: .render(self.connexionScreen))
                self.presentAlert(message: error?.errorDescription() ?? "", title: "Oups !")
            }
        } else {
            self.stateController.transition(to: .render(connexionScreen))
            presentAlert(message: AlertMessage().loginTextFieldsEmpty, title: "Oups !")
        }
    }
}

// MARK: Protocol gestion
extension ConnexionController: SignInProtocol {
    func signIn(_ email: String, _ password: String) {
        processToAuthentification(email, password)
    }
}
