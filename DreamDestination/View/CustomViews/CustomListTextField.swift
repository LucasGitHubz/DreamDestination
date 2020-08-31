//
//  CustomListTextField.swift
//  DreamDestination
//
//  Created by kuroro on 19/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomListTextField: UITextField {
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
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.5)
        bottomLine.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        layer.addSublayer(bottomLine)
    }
}
