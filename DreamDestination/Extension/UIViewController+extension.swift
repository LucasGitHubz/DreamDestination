//
//  UIViewController+extension.swift
//  DreamDestination
//
//  Created by kuroro on 15/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseFirestore

extension UIViewController {
// MARK: AlertGestion
    struct AlertMessage {
        // Program or Internet errors
        let programError = "L'application a rencontré une erreur inconnue. Veuillez la redémarrer."
        let errorInternet = "Vérifiez que votre connexion internet est bien active, puis recommencer."

        // Localisation Map errors
        let errorAdress = "Erreur de localisation inconnue, veuillez taper le nom de l'endroit directement dans la barre de recherche"
        let textFieldEmpty = "Veuillez renseigner une destination avant de poursuivre."
        let noDestinationAvailable = "Désolé, cette destination n'a pas encore été enregistrée dans l'application."
        let noPlacesAvailable = "Désolé, ce/cette lieu/ville n'est pas disponible dans ce Pays/Etat ! Pensez tout de même à vérifier l'orthographe de l'endroit puis réessayer."

        // Itinerary errors
        let emptyTextField = "Veuillez remplir les champs obligatoires avant de soumettre le formulaire."

        // Authentification errors
        let loginTextFieldsEmpty = "Veuillez saisir votre e-mail ainsi que votre mot de passe avant de continuer."
        let passwordIsntSecure = "Votre mot de passe doit contenir au moins 8 charactères, dont un chiffe et un charactère spécial."

        // Upload/Change profil picture indication
        let uploadImage = "Le changement d'image sur votre profil peut prendre quelques minutes."

        // Reset password alert
        let resetMessage = "Un mail de réinitialisation a été envoyé sur votre adresse mail !"
    }
    
    func presentAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title,
                                        message: message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: Child gestion
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
