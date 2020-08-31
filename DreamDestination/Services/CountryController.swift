//
//  CountryController.swift
//  DreamDestination
//
//  Created by kuroro on 16/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseFirestore

enum CountryError: Error {
    case error

    func errorDescription() -> String {
        switch self {
        case .error: return "Une erreur est survenue, veuillez relancer l'application en vérifiant que votre connexion internet est bien active."
        }
    }
}

class CountryController {
    // MARK: Property
    private let db = Firestore.firestore()

    // MARK: Methods
    func getList(listOf: String, completionHandler: @escaping (Result<[String: Any]?, CountryError>) -> Void) {
        let docRef = db.collection("ListCountriesAndCities").document(listOf)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                completionHandler(.success(dataDescription))
            } else {
                let errorName = CountryError.error
                completionHandler(.failure(errorName))
            }
        }
    }
    
    func getCountry(countryName: String, completionHandler: @escaping (Result<CountryDatas, CountryError>) -> Void) {
        let docRef = db.collection("Countries").document(countryName)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                let country = self.setCountryDataObject(dataDescription, countryName)
                
                completionHandler(.success(country))
            } else {
                let errorName = CountryError.error
                completionHandler(.failure(errorName))
            }
        }
    }
    
    private func setCountryDataObject (_ dictionnaryOfData: [String: Any]?, _ countryName: String) -> CountryDatas {
        let citiesString = dictionnaryOfData?["Cities"] as? String ?? ""
        var cities = [String]()
        let activitiesArray = dictionnaryOfData?["Activities"] as? [String] ?? [""]
        var activities = [[String]]()
        // Change citiesArray ex:
        // ["a, a, a, a, a"] to -> ["a", "a", "a", "a", "a"]
        cities = citiesString.components(separatedBy: ", ")
        
        // Change activitiesArray ex:
        // ["a, a, a, a", "b, b, b, b"] to -> [["a, a, a, a"], ["b, b, b, b"]]
        for index in 0...activitiesArray.count - 1 {
            var arrayOfString = [String]()
            arrayOfString.append(activitiesArray[index])
            activities += arrayOfString.map { $0.components(separatedBy: ", ") }
        }
        return CountryDatas(title: countryName, cityName: cities, numberOfActivities: activities)
    }
}
