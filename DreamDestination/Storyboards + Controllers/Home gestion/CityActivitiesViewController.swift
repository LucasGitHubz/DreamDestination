//
//  CityActivitiesViewController.swift
//  DreamDestination
//
//  Created by kuroro on 22/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CityActivitiesViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    private lazy var loadingController = LoadingViewController()
    private let imageController = ImageController()
    private var to = 1
    private var imagesTab = [UIImage]()
    var cityDatas = CityData()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundImage()
        tableView.backgroundColor = .clear
        navBarTitle.title = cityDatas.name
        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    }

    // MARK: Methods
    private func setBackgroundImage() {
        add(loadingController)
        imageController.getImage(childReference: "DestinationImages/Countries/\(cityDatas.country)/\(cityDatas.name)") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.cityImage.image = UIImage(data: data)
                    self.cityImage.blurImage()
                    self.setImagesTab()
                    self.loadingController.remove()
                case .failure(let error):
                    print(error)
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
                }
            }
        }
    }

    func completeImageTabByDefaultImages() {
        while imagesTab.count < cityDatas.activity.count {
            imagesTab.append(cityImage.image ?? #imageLiteral(resourceName: "loginScreen"))
        }
        tableView.reloadData()
    }

    private func setImagesTab() {
        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/\(cityDatas.country)/\(cityDatas.name)/", arrayToFetch: cityDatas.activity, to: to) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tab):
                    self.imagesTab = tab
                    self.tableView.reloadData()
                    self.to += 1
                    self.loadNextBach()
                    self.loadingController.remove()
                case .failure(let error):
                    self.presentAlert(message: error.errorDescription(), title: "Oups !")
                    self.completeImageTabByDefaultImages()
                }
            }
        }
    }

    private func loadNextBach() {
        guard imagesTab.count != cityDatas.activity.count else {
            return
        }

        if to > cityDatas.activity.count {
            to = cityDatas.activity.count
        }

        imageController.getAnImagesTab(childReference: "DestinationImages/Countries/\(cityDatas.country)/\(cityDatas.name)/", arrayToFetch: cityDatas.activity, to: to) { (result) in
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

    // MARK: IBAction
    @IBAction func didTapShowLocationButton(_ sender: Any) {
        performSegue(withIdentifier: "segueToMap", sender: self)
    }
}

// MARK: Prepare for segue
extension CityActivitiesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "segueToMap" {
            guard let successVC = segue.destination as? MapViewController else {
                return presentAlert(message: AlertMessage().programError, title: "Oups !")
            }

            successVC.cityDatas = cityDatas
        }
    }
}

// MARK: TableView gestion
extension CityActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDatas.activity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(cellType: CellView.self)
        let cell: CellView = tableView.dequeueReusableCell(for: indexPath)
        
        let activity = cityDatas.activity[indexPath.row]

        var image = UIImage()
        cell.cityImage.isHidden = true
        cell.activityIndicator.isHidden = false

        if indexPath.row < imagesTab.count {
            image = imagesTab[indexPath.row]
            cell.cityImage.isHidden = false
            cell.activityIndicator.isHidden = true
        }
        cell.cityName.text = activity
        cell.stackView.removeArrangedSubview(cell.activityLabel)
        cell.activityLabel.text = ""
        cell.cityImage.image = image

        cell.backgroundColor = .clear
        
        return cell
    }
}
