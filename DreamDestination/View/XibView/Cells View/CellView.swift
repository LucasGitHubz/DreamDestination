//
//  CellView.swift
//  DreamDestination
//
//  Created by kuroro on 12/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class CellView: UITableViewCell, NibReusable {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var cityName: CustomLabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var cityImage: CustomImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        cityName.text = ""
        activityLabel.text = ""
    }
}
