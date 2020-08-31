//
//  CustomLabel.swift
//  DreamDestination
//
//  Created by kuroro on 12/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }

    private func setStyle() {
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.shadowOpacity = 0.4
    }
}
