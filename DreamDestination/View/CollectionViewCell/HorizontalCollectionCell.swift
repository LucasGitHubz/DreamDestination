//
//  CustomCollectionCell.swift
//  DreamDestination
//
//  Created by kuroro on 12/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

class HorizontalCollectionCell: UICollectionViewCell {
    // MARK: ImageView creation
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10

        return image
    }()

    // MARK: Label creation
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Medium", size: 23)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.layer.shadowOpacity = 0.9
        label.clipsToBounds = true

        return label
    }()

    // MARK: Button creation
    let button: UIButton = {
        let setButton = UIButton()
        setButton.translatesAutoresizingMaskIntoConstraints = false
        setButton.contentMode = .scaleAspectFill
        setButton.clipsToBounds = true

        return setButton
    }()

    // MARK: Methods to add the views created above and set their constraints
    private func addLabelToContentView() {
        contentView.addSubview(locationLabel)

        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    private func addButtonAndImageToContentView() {
        
        let views = [button, imageView]
        
        views.forEach { (view) in
            contentView.addSubview(view)

            view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

        addButtonAndImageToContentView()
        addLabelToContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
