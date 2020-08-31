//
//  CovidIndicatorViewController.swift
//  DreamDestination
//
//  Created by kuroro on 27/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CovidIndicatorViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!

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
        private func getList() {
            userController.getSpecificData(collection: "CovidCountries", document: "List", field: "Countries") { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let listFetched):
                        self.list = listFetched as? [String] ?? [""]
                        self.tableView.reloadData()
                        self.loadingController.remove()
                    case .failure(let error):
                        print(error)
                        self.loadingController.remove()
                    }
                }
            }
        }
    }

    // MARK: TableView gestion
extension CovidIndicatorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CovidCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        cell.label.text = "- \(list[indexPath.row])"
        
        return cell
    }
}
