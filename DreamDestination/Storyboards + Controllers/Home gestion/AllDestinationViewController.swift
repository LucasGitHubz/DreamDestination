//
//  AllDestinationViewController.swift
//  DreamDestination
//
//  Created by kuroro on 21/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class AllDestinationViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private let homeController = HomeViewController()
    private let imageController = ImageController()
    private var countryDatas = CountryDatas()
    private var cityDatas = CityData()
    private var imagesTab = [UIImage]()
    var countries = [String]()
    var delegate: HomeDelegateProtocol?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setimagesTab()
        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    }

    // MARK: Methods
    func setimagesTab() {
        add(loadingController)
        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/", arrayToFetch: countries, to: countries.count) { (result) in
            switch result {
            case .success(let tab):
                self.imagesTab = tab
                self.tableView.reloadData()
                self.loadingController.remove()
            case .failure(_):
                self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
            }
        }
    }
}

// MARK: TableView gestion
extension AllDestinationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        add(homeController.loadingController)
        delegate?.displayCountryData(countryName: countries[indexPath.row], segue: "segueToTopDestination", nameCity: nil, activitiesIndex: nil)
        homeController.loadingController.remove()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(cellType: BigCellView.self)
        let cell: BigCellView = tableView.dequeueReusableCell(for: indexPath)
        
        let name = countries[indexPath.row]
        var image = UIImage()
        cell.countryImage.isHidden = true
        cell.activityIndicator.isHidden = false

        if indexPath.row < imagesTab.count {
            image = imagesTab[indexPath.row]
            cell.countryImage.isHidden = false
            cell.activityIndicator.isHidden = true
        }
        
        cell.countryName.text = name
        cell.countryImage.image = image
        
        return cell
    }
}
