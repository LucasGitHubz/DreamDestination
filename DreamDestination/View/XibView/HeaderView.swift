//
//  HeaderView.swift
//  DreamDestination
//
//  Created by kuroro on 07/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//
import UIKit
import Reusable

class HeaderView: UIView, NibReusable {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changeImageButton: UIButton!

    var delegate: ProfilDelegateProtocol?
    
    func roundedImage() {
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
    }
}
