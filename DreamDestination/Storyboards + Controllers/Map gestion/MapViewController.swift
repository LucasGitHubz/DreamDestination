//
//  MapViewController.swift
//  DreamDestination
//
//  Created by kuroro on 25/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate {
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBar: UINavigationItem!
    
    // MARK: Properties
    private var longitude = Double()
    private var latitude = Double()
    private var coordinateInit: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var resultSearchController: UISearchController? = nil
    var cityDatas = CityData()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchBar()

        if cityDatas.country != "" || cityDatas.name != "" {
            zoomOnAdressGiven()
        } else {
            toogleActivityIndicator(shown: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setStyle(color: #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    }
    
    // MARK: Methods
    private func toogleActivityIndicator(shown: Bool) {
            activityIndicator.isHidden = shown
    }

    private func setSearchBar() {
        let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as? LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        guard let searchBar = resultSearchController?.searchBar else {
            return
        }

        searchBar.sizeToFit()
        searchBar.placeholder = "Rechercher un lieu"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable?.mapView = mapView
        locationSearchTable?.handleMapSearchDelegate = self
    }

    private func makeAdress() -> String {
        var adress = String()

        switch cityDatas.country {
        case "Californie":
            cityDatas.country = "United States, California"
            switch cityDatas.name {
            case "Alabama Hills", "Point Reyes":
                cityDatas.country = "California"
            case "Channel Islands National Park", "Pinnacles National Park":
                cityDatas.country = "United States"
            case "Redwood National Park":
                cityDatas.name = "Redwood National and State Parks"
            case "Désert de Mojave":
                cityDatas.name = "Mojave Desert"
            case "Mariposa Grove":
                cityDatas.name = "Yosemite National Park"
            default:
                break
            }
        case "Italie":
            cityDatas.country = "Italy"
        case "France":
            switch cityDatas.name {
            case "Monaco":
                cityDatas.country = ""
            case "Verdon":
                cityDatas.name = "Aiguines"
            default:
                break
            }
        case "Espagne":
            if cityDatas.name == "Saint-Jacques-de-Compostelle" {
                cityDatas.country = "Santiago de Compostela"
                cityDatas.name = ""
            }
        case "Floride":
            cityDatas.country = "United States, Florida"
            switch cityDatas.name {
            case "Big Cypress National Preserve":
                cityDatas.name = "Ochopee"
            case "Ginnie Springs":
                cityDatas.name = "High Springs"
            default:
                break
            }

        default:
            break
        }

        if cityDatas.name != "", cityDatas.name != cityDatas.country {
            adress = "\(cityDatas.country), \(cityDatas.name)"
            return adress
        }

        adress = cityDatas.country
        return adress
    }
    
    private func zoomOnAdressGiven() {
        CLGeocoder().geocodeAddressString(makeAdress(), completionHandler: { placemarks, error in
            if error != nil {
                self.presentAlert(message: AlertMessage().errorAdress, title: "Oups !")
                
            }
            
            if let placemark = placemarks?[0] {
                self.longitude = placemark.location?.coordinate.longitude ?? 0.0
                self.latitude = placemark.location?.coordinate.latitude ?? 0.0
                
                let span = MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
                let region = MKCoordinateRegion(center: self.coordinateInit, span: span)
                self.mapView.setRegion(region, animated: true)
                
                let pointer = Pointer(title: self.cityDatas.name, coordinate: self.coordinateInit)
                self.mapView.addAnnotation(pointer)
                
                self.toogleActivityIndicator(shown: true)
            }
        })
    }
}

// MARK: Protocol gestion
extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        toogleActivityIndicator(shown: false)
        mapView.removeAnnotations(mapView.annotations)
        let pointer = Pointer(title: placemark.name ?? "", coordinate: placemark.coordinate)
        mapView.addAnnotation(pointer)
        let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        toogleActivityIndicator(shown: true)
    }
}
