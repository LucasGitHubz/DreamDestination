//
//  ItineraryViewController.swift
//  DreamDestination
//
//  Created by kuroro on 28/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class ItineraryViewController: UIViewController {
    // MARK: IBOutlet
    @IBAction func unwindToItinerary(segue: UIStoryboardSegue) {
    }

    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private var userController = UserController()
    private var textFieldTab = [UITextField]()
    private let itineraryInformationsNeeded = ["Destination (Ville/Etat/Region) :",
                                               "Budget (par personne en €) :",
                                               "Durée :",
                                               "Centres d'intérêts (optionnel) :",
                                               "Notes supplémentaires (optionnel) :"]
    private let itineraryPlaceholders = ["Ex: France, Côte d'azur",
                                               "Ex: Entre 1500 - 2000",
                                               "Ex: 2 semaines",
                                               "Ex: Musées, jardins, etc...",
                                               "Ex: Enfants, handicap, etc..."]

    // MARK: Methods
    private func checkEmptyTextField() -> Bool {
        guard textFieldTab[0].text != "",
            textFieldTab[1].text != "",
            textFieldTab[2].text != "" else {
                return false
        }
        return true
    }

    @objc func submit() {
        if !checkEmptyTextField() {
            presentAlert(message: AlertMessage().emptyTextField, title: "Oups !")
            return
        }
        for textField in textFieldTab {
            textField.text = ""
        }
        presentAlert(message: "Nous avons bien reçu votre demande ! Nous vous tiendrons au courant par mail lorsque votre itinéraire sera prêt.", title: "Merci de votre confiance !")
    }
}

// MARK: TableView gestion
extension ItineraryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryInformationsNeeded.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 5 else {
            tableView.register(cellType: SubmitButtonCell.self)
            let cell: SubmitButtonCell = tableView.dequeueReusableCell(for: indexPath)

            cell.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
            
            return cell
        }

        guard let cell: ItineraryCell = tableView.dequeueReusableCell(withIdentifier: "ItineraryCell", for: indexPath) as? ItineraryCell else {
            return UITableViewCell()
        }
        
        cell.label.text = itineraryInformationsNeeded[indexPath.row]
        cell.textField.placeholder = itineraryPlaceholders[indexPath.row]
        cell.textField.tag = indexPath.row
        textFieldTab.append(cell.textField)
        
        return cell
    }
}
