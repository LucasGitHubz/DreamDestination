//
//  CustomImageView.swift
//  DreamDestination
//
//  Created by kuroro on 12/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    func setStyle() {
        self.layer.cornerRadius = 10
    }
}
