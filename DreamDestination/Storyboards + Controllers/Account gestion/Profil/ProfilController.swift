//
//  ProfilViewController.swift
//  DreamDestination
//
//  Created by kuroro on 25/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import FirebaseAuth

@objc protocol ProfilDelegateProtocol {
    func setImageProfil()

    func showList()

    func showCovidIncator()

    func signOut()

    func resetPassword()
}

class ProfilController: UIViewController {
    // MARK: Properties
    private let userId = Auth.auth().currentUser?.uid
    private let profilScreen = ProfilViewController.instantiate()
    private lazy var stateController = StateController()
    private let userController = UserController()
    private let imageController = ImageController()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        add(stateController)
        getDocument()
    }

    // MARK: Methods
    private func getDocument() {
        userController.getUser { (result) in
            switch result {
            case .success(let userDatas):
                self.profilScreen.fullName = userDatas.fullName
                self.profilScreen.email = userDatas.email
                self.profilScreen.delegate = self
                self.profilScreen.headerView.changeImageButton.addTarget(self, action: #selector(self.setImageProfil), for: .touchUpInside)
                self.downloadImage()
            case .failure(_):
                self.logOut()
            }
        }
    }
    
    func logOut() {
        stateController.transition(to: .loading)
        userController.signOut { (success) in
            if !success {
                self.stateController.transition(to: .render(self.profilScreen))
                self.presentAlert(message: AlertMessage().programError, title: "Oups !")
            }
        }
    }
}

// MARK: ImagePickerController set up + fetch and upload image gestion
extension ProfilController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showPicker(source: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = source
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    private func checkPhotoLibraryPermission(type: UIImagePickerController.SourceType) {
        let statusLibraryAccess = PHPhotoLibrary.authorizationStatus()
        switch statusLibraryAccess {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({ status in
                switch status {
                case .authorized:
                    self.checkPhotoLibraryPermission(type: .photoLibrary)
                case .notDetermined, .denied, .restricted:
                    self.askPermission(type)
                default:
                    break
                }})
        case .authorized:
            showPicker(source: type)
        default:
            break
        }
    }
    
    private func checkCameraPermission(type: UIImagePickerController.SourceType) {
        let statusCameraAccess = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch statusCameraAccess {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { status in
                if status == true {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        self.showPicker(source: type)
                    } else {
                        print("Camera not available")
                    }
                } else {
                    self.askPermission(type)
                }
            })
        case .denied, .restricted:
            askPermission(type)
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(source: type)
            } else {
                print("Camera not available")
            }
        default:
            break
        }
    }
    
    private func askPermission(_ sender: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            if sender == .photoLibrary {
                let alert = UIAlertController(title: "Photo library", message: "Library access is necessary to use this app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                self.present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Camera", message: "Camera access is necessary to use this app", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    func chooseImage() {
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_:UIAlertAction) in
            self.checkPhotoLibraryPermission(type: .photoLibrary)
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_:UIAlertAction) in
            self.checkCameraPermission(type: .camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func uploadImage(_ image: UIImage) {
        stateController.transition(to: .loading)
        imageController.uploadImage(image, childReference: "images/\(userId ?? "test")") { (success) in
            DispatchQueue.main.async {
                if success {
                    self.downloadImage()
                } else {
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Oups !")
                }
            }
        }
    }
    
    func downloadImage() {
        imageController.getImage(childReference: "images/\(userId ?? "")") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageData):
                    self.profilScreen.headerView.userImageView.image = UIImage(data: imageData)
                    self.stateController.transition(to: .render(self.profilScreen))
                    self.profilScreen.headerView.changeImageButton.setBackgroundImage(.none, for: .normal)
                case .failure(_):
                    self.stateController.transition(to: .render(self.profilScreen))
                    self.profilScreen.headerView.changeImageButton.setBackgroundImage(UIImage(named: "imageProfilBackground"), for: .normal)
                }
            }
        }
    }
}

// MARK: Protocol gestion
extension ProfilController: ProfilDelegateProtocol {
    func showList() {
        profilScreen.performSegue(withIdentifier: "segueToList", sender: self)
    }

    func showCovidIncator() {
        profilScreen.performSegue(withIdentifier: "segueToCovidVC", sender: self)
    }

    func setImageProfil() {
        chooseImage()
    }

    func signOut() {
        logOut()
    }

    func resetPassword() {
        stateController.transition(to: .loading)
        userController.resetPassword(email: Auth.auth().currentUser?.email ?? "") { (success) in
            DispatchQueue.main.async {
                if success {
                    self.stateController.transition(to: .render(self.profilScreen))
                    self.presentAlert(message: AlertMessage().resetMessage, title: "Réinitialisation")
                } else {
                    self.stateController.transition(to: .render(self.profilScreen))
                    self.presentAlert(message: AlertMessage().errorInternet, title: "Une erreur est survenue !")
                }
            }
        }
    }
}
