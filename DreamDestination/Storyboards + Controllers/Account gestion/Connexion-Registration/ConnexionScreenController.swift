//
//  ConnexionViewController.swift
//  DreamDestination
//
//  Created by kuroro on 06/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class ConnexionScreenController: UIViewController, StoryboardBased {
    // MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: Property
    var delegate: SignInProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.blurImage()
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: IBAction
    @IBAction func didTapConnexionButton(_ sender: Any) {
        delegate?.signIn(emailTextField.text ?? "", passwordTextField.text ?? "")
    }
}

// MARK: TextField gestion
extension ConnexionScreenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.signIn(emailTextField.text ?? "", passwordTextField.text ?? "")
        return true
    }
}
