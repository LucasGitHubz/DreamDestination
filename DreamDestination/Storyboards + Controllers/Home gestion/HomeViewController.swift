//
//  HomeViewController.swift
//  DreamDestination
//
//  Created by kuroro on 07/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

protocol HomeDelegateProtocol {
    func displayCountryData(countryName: String, segue: String, nameCity: String?, activitiesIndex: Int?)
}

class HomeViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var bottomLabel: CustomLabel!
    @IBOutlet weak var botButton: CustomButton!
    @IBOutlet weak var viewForCollection: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var botView: UIView!

    // MARK: Properties
    let loadingController = LoadingViewController()
    private let countryController = CountryController()
    private let imageController = ImageController()
    private var countryDatas = CountryDatas()
    private var cityDatas = CityData()
    private var countries = [String]()
    private var topDestinations = [String]()
    private var allCities = [[String]]()
    private var imagesTab = [UIImage]()
 
    // MARK: CollectionView setup
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(HorizontalCollectionCell.self, forCellWithReuseIdentifier: "Cell")
        return collection
    }()
    
    private func addCollectionToView() {
        viewForCollection.addSubview(collectionView)
        
        collectionView.backgroundColor = .none
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: viewForCollection.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: viewForCollection.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: viewForCollection.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: viewForCollection.bottomAnchor).isActive = true
        loadingController.remove()
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCountries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: Methods
    func searchUserDestination() {
        guard let userDestination = textField.text, userDestination != "" else {
            presentAlert(message: AlertMessage().textFieldEmpty, title: "Oups !")
            return
        }
        // If user desired destination is a country
        for countryIndex in 0...countries.count - 1 where userDestination.uppercaseMaker() == countries[countryIndex] {

            getDataOfCountry(countryName: countries[countryIndex], segue: "segueToTopDestination", nameCity: nil, activitiesIndex: nil)
            return
        }
        
        for cityIndex in 0...allCities.count - 1 {
            for activitiesIndex in 0...allCities[cityIndex].count - 1 where userDestination.uppercaseMaker() == allCities[cityIndex][activitiesIndex] {
                getDataOfCountry(countryName: countries[cityIndex], segue: "segueToCityVC", nameCity: userDestination.uppercaseMaker(), activitiesIndex: activitiesIndex)
                return
            }
        }
        presentAlert(message: AlertMessage().noDestinationAvailable, title: "Oups !")
    }
    
    @objc func collectionButtonAction(sender: UIButton) {
        add(loadingController)
        getDataOfCountry(countryName: sender.titleLabel?.text ?? "", segue: "segueToTopDestination", nameCity: nil, activitiesIndex: nil)
    }

    // MARK: IBAction
    @IBAction func didTapSeeAllDestinationsButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToAllDestination", sender: self)
    }
}

// MARK: Fetched datas from Database
extension HomeViewController {
    func setCountries() {
        add(loadingController)
        countryController.getList(listOf: "Countries") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries?["List"] as? [String] ?? [""]
                    self.setTopDestinations()
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                }
            }
        }
    }

    func setTopDestinations() {
        countryController.getList(listOf: "TopCountries") { (result) in
            switch result {
            case .success(let topCountries):
                self.topDestinations = topCountries?["List"] as? [String] ?? [""]
                self.setCities()
            case .failure(let error):
                self.presentAlert(message: error.errorDescription(), title: "Oups !")
            }
        }
    }

    func setCities() {
        countryController.getList(listOf: "Cities") { (result) in
            switch result {
            case .success(let cities):
                let citiesArray = cities?["List"] as? [String] ?? [""]
                // Change citiesArray ex:
                // ["a, a, a, a", "b, b, b, b"] to -> [["a, a, a, a"], ["b, b, b, b"]]
                for index in 0...citiesArray.count - 1 {
                    var arrayOfString = [String]()
                    arrayOfString.append(citiesArray[index])
                    self.allCities += arrayOfString.map { $0.components(separatedBy: ", ")
                    }
                }
                self.setimagesTab()
            case .failure(let error):
                self.presentAlert(message: error.errorDescription(), title: "Oups !")
            }
        }
    }

    func setimagesTab() {
        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/", arrayToFetch: topDestinations, to: topDestinations.count) { (result) in
            switch result {
            case .success(let tab):
                self.imagesTab = tab
                self.addCollectionToView()
            case .failure(_):
                self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
            }
        }
    }

    func getDataOfCountry(countryName: String, segue: String, nameCity: String?, activitiesIndex: Int?) {
        countryController.getCountry(countryName: countryName) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let country):
                    self.countryDatas = country
                    if segue == "segueToCityVC", nameCity != nil, activitiesIndex != nil {
                        self.cityDatas.country = self.countryDatas.title
                        self.cityDatas.name = nameCity ?? ""
                        self.cityDatas.activity = self.countryDatas.numberOfActivities[activitiesIndex ?? 0]
                    }
                    self.loadingController.remove()
                    self.performSegue(withIdentifier: segue, sender: self)
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                }
            }
        }
    }
}

// MARK: Prepare for segue
extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToTopDestination" {
            guard let successTopVC = segue.destination as? TopDestinationViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successTopVC.countryDatas = countryDatas
        }
    
        if segue.identifier == "segueToAllDestination" {
            guard let successAllVC = segue.destination as? AllDestinationViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successAllVC.delegate = self
            successAllVC.countries = countries
        }

        if segue.identifier == "segueToCityVC" {
            guard let successCityVC = segue.destination as? CityActivitiesViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successCityVC.cityDatas = cityDatas
        }
    }
}

// MARK: TextField gestion
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchUserDestination()
        return true
    }
}

// MARK: CollectionView gestion
extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: viewForCollection.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topDestinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HorizontalCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.button.tag = indexPath.row
        cell.button.setTitle(topDestinations[indexPath.row], for: .normal)
        cell.button.addTarget(self, action: #selector(self.collectionButtonAction), for: .touchUpInside)
        cell.locationLabel.text = topDestinations[indexPath.row]
        cell.imageView.image = imagesTab[indexPath.row]
        
        return cell
    }
}

// MARK: Protocol gestion
extension HomeViewController: HomeDelegateProtocol {
    func displayCountryData(countryName: String, segue: String, nameCity: String?, activitiesIndex: Int?) {
        getDataOfCountry(countryName: countryName, segue: segue, nameCity: nameCity, activitiesIndex: activitiesIndex)
    }
}
