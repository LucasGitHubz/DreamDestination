//
//  CustomTextField.swift
//  DreamDestination
//
//  Created by kuroro on 01/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class CustomAuthentificationTextField: UITextField {
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
        bottomLine.frame = CGRect(x: 0.0, y: frame.height - 1, width: frame.width, height: 1.0)
        bottomLine.backgroundColor = #colorLiteral(red: 0, green: 0.9014340753, blue: 0.6931453339, alpha: 1)
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
}
