//
//  LoaderViewController.swift
//  DreamDestination
//
//  Created by kuroro on 01/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    // MARK: Property
    private lazy var activityIndicator = UIActivityIndicatorView(
        style: .whiteLarge
    )

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = #colorLiteral(red: 0, green: 0.9014340753, blue: 0.6931453339, alpha: 1)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
