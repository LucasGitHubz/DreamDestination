//
//  CustomItineraryTextField.swift
//  DreamDestination
//
//  Created by kuroro on 03/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomItineraryTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setStyle()
    }
    
    func setStyle() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1.5, width: frame.width, height: 1.5)
        bottomLine.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
