//
//  CustomTabBarViewController.swift
//  DreamDestination
//
//  Created by kuroro on 05/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import FirebaseAuth

class CustomTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navController = UINavigationController(rootViewController: ProfilController())
        viewControllers?.append(navController)
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.refreshTabBar(ProfilController())
                self.setDesignTabBar("Profil")
            } else {
                self.refreshTabBar(ConnexionController())
                self.setDesignTabBar("Se connecter")
            }
        }
        
    }
    
    private func setDesignTabBar(_ title: String) {
        let image = UIImage(systemName: "person")
        let tabBarItem = UITabBarItem(title: title, image: image, tag: 3)
        viewControllers?[3].tabBarItem = tabBarItem
        
    }
    
    private func refreshTabBar(_ vc: UIViewController) {
        let navController = UINavigationController(rootViewController: vc)
        viewControllers?[3] = navController
    }
}
