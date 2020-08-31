//
//  TopLocationViewController.swift
//  DreamDestination
//
//  Created by kuroro on 12/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class TopDestinationViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var textField: UITextField!

    // MARK: Properties
    var cityDatas = CityData()
    var countryDatas = CountryDatas()
    private lazy var loadingController = LoadingViewController()
    private var imagesTab = [UIImage]()
    private let imageController = ImageController()
    private var to = 5

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navBarTitle.title = countryDatas.title
        setBackgroundImage()
        tableView.backgroundColor = .clear
        cityDatas.country = countryDatas.title
        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }

    // MARK: Methods
    private func setBackgroundImage() {
        add(loadingController)
        imageController.getImage(childReference: "DestinationImages/Countries/\(countryDatas.title)") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.imageView.image = UIImage(data: data)
                    self.imageView.blurImage()
                    self.loadingController.remove()
                    self.setImagesTab()
                case .failure(_):
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
                }
            }
        }
    }

    func completeImageTabByDefaultImages() {
        while imagesTab.count < countryDatas.cityName.count {
            imagesTab.append(#imageLiteral(resourceName: "homeImageView"))
        }
    }

    private func setImagesTab() {
        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/\(countryDatas.title)/", arrayToFetch: countryDatas.cityName, to: to) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tab):
                    self.imagesTab = tab
                    self.tableView.reloadData()
                    self.to += 1
                    self.loadNextBach()
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                    self.completeImageTabByDefaultImages()
                }
            }
        }
    }

    private func loadNextBach() {
        guard imagesTab.count != countryDatas.cityName.count else {
            return
        }

        if to > countryDatas.cityName.count {
            to = countryDatas.cityName.count
        }

        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/\(countryDatas.title)/", arrayToFetch: countryDatas.cityName, to: to) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tab):
                    self.imagesTab = tab
                    self.to += 1
                    self.tableView.reloadData()
                    self.loadNextBach()
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                    self.completeImageTabByDefaultImages()
                }
            }
        }
    }

    func searchUserDestination() {
        guard let userDestination = textField.text, userDestination != "" else {
            presentAlert(message: AlertMessage().textFieldEmpty, title: "Oups !")
            return
        }

        for countryIndex in 0...countryDatas.cityName.count - 1 where userDestination.uppercaseMaker() == countryDatas.cityName[countryIndex] {
            cityDatas.name = countryDatas.cityName[countryIndex]
            cityDatas.activity = countryDatas.numberOfActivities[countryIndex]

            performSegue(withIdentifier: "segueToCityVC", sender: self)
            return
        }
        
        presentAlert(message: AlertMessage().noPlacesAvailable, title: "Oups !")
    }

    // MARK: IBAction
    @IBAction func didTapShowLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMap", sender: self)
    }
}

// MARK: TextField gestion
extension TopDestinationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchUserDestination()
        return true
    }
}

// MARK: Prepare for segue
extension TopDestinationViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCityVC" {
            guard let successCityVC = segue.destination as? CityActivitiesViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successCityVC.cityDatas = cityDatas

        } else if segue.identifier == "segueToMap" {
            guard let successMapVC = segue.destination as? MapViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            cityDatas.name = countryDatas.title
            successMapVC.cityDatas = cityDatas
        }
    }
}

// MARK: TableView gestion
extension TopDestinationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        cityDatas.name = countryDatas.cityName[indexPath.row]
        cityDatas.activity = countryDatas.numberOfActivities[indexPath.row]
        
        performSegue(withIdentifier: "segueToCityVC", sender: self)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryDatas.cityName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(cellType: CellView.self)
        let cell: CellView = tableView.dequeueReusableCell(for: indexPath)
        
        let cityName = countryDatas.cityName[indexPath.row]
        let activity = "\(countryDatas.numberOfActivities[indexPath.row].count) activité(s) à découvrir"
        var image = UIImage()
        cell.cityImage.isHidden = true
        cell.activityIndicator.isHidden = false

        if indexPath.row < imagesTab.count {
            image = imagesTab[indexPath.row]
            cell.cityImage.isHidden = false
            cell.activityIndicator.isHidden = true
        }
        
        cell.cityName.text = cityName
        cell.activityLabel.text = activity
        cell.cityImage.image = image

        cell.backgroundColor = .clear
        
        return cell
    }
}
