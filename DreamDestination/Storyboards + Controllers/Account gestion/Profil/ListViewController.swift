//
//  ListViewController.swift
//  DreamDestination
//
//  Created by kuroro on 19/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseAuth

class ListViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!

    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private let userController = UserController()
    private var list = [String]()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        add(loadingController)
        getList()
    }

    // MARK: Methods
    private func checkIfTextFieldIsEmpty() -> Bool {
        guard textField.text != "" else {
            return true
        }
        return false
    }

    private func addDestinationToList() {
        add(loadingController)
        userController.updateSpecificData(collection: "users", document: Auth.auth().currentUser?.uid ?? "", field: "List", newValue: list) { (success) in
            DispatchQueue.main.async {
                if success {
                    self.getList()
                    self.textField.text = ""
                } else {
                    self.loadingController.remove()
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
                }
            }
        }
    }

    private func getList() {
        userController.getSpecificData(collection: "users", document: Auth.auth().currentUser?.uid ?? "", field: "List") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let listFetched):
                    self.list = listFetched as? [String] ?? [""]
                    if self.list == [""] || self.list == [] {
                        self.list.removeAll()
                        self.tableView.isHidden = true
                    } else {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                    self.loadingController.remove()
                case .failure(let error):
                    print(error)
                    self.loadingController.remove()
                }
            }
        }
    }

    // MARK: IBAction
    @IBAction func didTapAddButton(_ sender: Any) {
        backgroundLabel.isHidden = true
        tableView.isHidden = true
        textField.isHidden = false
    }
}

// MARK: TextField gestion
extension ListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if checkIfTextFieldIsEmpty() {
            presentAlert(message: AlertMessage().textFieldEmpty, title: "Oups !")
        } else {
            self.textField.isHidden = true
            backgroundLabel.isHidden = false
            list.append(textField.text ?? "")
            addDestinationToList()
        }
        return true
    }
}

// MARK: TableView gestion
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            addDestinationToList()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ListCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.label.text = "- \(list[indexPath.row])"
        
        return cell
    }
}
