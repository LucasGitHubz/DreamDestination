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
        if #available(iOS 13.0, *) {
            self.standardAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            self.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        } else {
            // Fallback on earlier versions
        }
        
        if color != #colorLiteral(red: 0, green: 0.9014340753, blue: 0.6931453339, alpha: 1) {
            self.topItem?.backBarButtonItem?.tintColor = color
            let barButton = UIBarButtonItem()
            barButton.title = ""
            barButton.tintColor = color
            self.topItem?.backBarButtonItem = barButton
        } else {
            if #available(iOS 11.0, *) {
                self.prefersLargeTitles = true
            } else {
                // Fallback on earlier versions
            }
            self.topItem?.hidesBackButton = true
            self.topItem?.title = "Profil"
        }
    }
}
