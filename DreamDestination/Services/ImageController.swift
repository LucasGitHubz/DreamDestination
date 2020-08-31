//
//  ImageController.swift
//  DreamDestination
//
//  Created by kuroro on 16/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseStorage

enum FetchImageError: Error {
    case objectNotFound
    case error

    func errorDescription() -> String {
        switch self {
        case .objectNotFound: return "Pas encore d'image disponible pour ce lieu. Nous travaillons activement à combler ce manque."
        case .error: return "Une erreur est survenue, veuillez relancer l'application en vérifiant que votre connexion internet est bien active."
        }
    }
}

class ImageController {
    // MARK: Properties
    private let storage = Storage.storage()
    private var imageDownloadURL = String()
    private var imageTab = [UIImage]()
    private var counter = 0

    // MARK: Methods
    func handlingError(error: Error) -> FetchImageError {
        if let errCode = StorageErrorCode(rawValue: error._code) {

            switch errCode {
            case .objectNotFound:
                return FetchImageError.objectNotFound
            default:
                return FetchImageError.error
            }
        }
        return FetchImageError.error
    }

    func uploadImage(_ image: UIImage, childReference: String, completionHandler: @escaping (Bool) -> Void) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(childReference)
        let maxResolution: CGFloat = max(image.size.width, image.size.height)
        let imagetest = image.rotateCameraImageToProperOrientation(maxResolution: maxResolution)
        
        guard let data = imagetest.compress(.lowest) else {
            return
        }
        
        imageRef.putData(data, metadata: nil) { (metadata, error) in
            DispatchQueue.main.async {
                if metadata != nil {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    
    private func getImageURL(_ childReference: String) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child(childReference)
        
        imageRef.downloadURL { (url, _) in
            guard let downloadURL = url else {
                return
            }
            self.imageDownloadURL = downloadURL.absoluteString
        }
    }
    
    func getImage(childReference: String, completionHandler: @escaping (Result<Data, FetchImageError>) -> Void) {
        let convertedString = stringConverter(stringTab: [childReference])
        getImageURL(convertedString[0])
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child(convertedString[0])
        
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data {
                completionHandler(.success(data))
            } else if let error = error {
                completionHandler(.failure(self.handlingError(error: error)))
            }
        }
    }

    func getAnImagesTab(childReference: String, arrayToFetch: [String], to: Int, completionHandler: @escaping (Result<[UIImage], FetchImageError>) -> Void) {
        let convertedArray = stringConverter(stringTab: arrayToFetch)

        if counter == to {
            completionHandler(.success(imageTab))
        } else {
            getImage(childReference: "\(childReference)\(convertedArray[counter])") { (result) in
                switch result {
                case .success(let data):
                    self.imageTab.append(UIImage(data: data) ?? #imageLiteral(resourceName: "loading"))
                    self.counter += 1
                    self.getAnImagesTab(childReference: childReference, arrayToFetch: convertedArray, to: to, completionHandler: completionHandler)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func stringConverter(stringTab: [String]) -> [String] {
        var tabConverted = stringTab

        for index in 0...tabConverted.count - 1 {
            var tab = tabConverted[index].map({ String($0) })
            for idx in 0...tab.count - 1 {
                switch tab[idx] {
                case "É":
                    tab[idx] = "E"
                case "â", "à":
                    tab[idx] = "a"
                case "ç":
                    tab[idx] = "c"
                case "é", "è", "ê":
                    tab[idx] = "e"
                case "î", "ï":
                    tab[idx] = "i"
                case "ô":
                    tab[idx] = "o"
                default:
                    break
                }
            }
            tabConverted[index] = tab.joined(separator: "")
        }
        return tabConverted
    }
}
