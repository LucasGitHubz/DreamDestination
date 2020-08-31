//
//  AppDelegate.swift
//  DreamDestination
//
//  Created by kuroro on 07/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableDebugging = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100.0
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        return true
    }
}
