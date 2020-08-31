//
//  CustomNavBarItem.swift
//  DreamDestination
//
//  Created by kuroro on 21/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func setStyle(color: UIColor) {
        self.isHidden = false
        self.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        self.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        if color != #colorLiteral(red: 0, green: 0.9014340753, blue: 0.6931453339, alpha: 1) {
            self.topItem?.backBarButtonItem?.tintColor = color
            let barButton = UIBarButtonItem()
            barButton.title = ""
            barButton.tintColor = color
            self.topItem?.backBarButtonItem = barButton
        } else {
            self.prefersLargeTitles = true
            self.topItem?.hidesBackButton = true
            self.topItem?.title = "Profil"
        }
    }
}
