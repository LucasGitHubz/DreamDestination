//
//  BigCellView.swift
//  DreamDestination
//
//  Created by kuroro on 21/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit
import Reusable

class BigCellView: UITableViewCell, NibReusable {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
}
