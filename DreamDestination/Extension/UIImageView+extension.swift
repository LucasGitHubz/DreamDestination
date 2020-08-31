//
//  UIImageView+extension.swift
//  DreamDestination
//
//  Created by kuroro on 15/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

extension UIImageView {
    func blurImage() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.opacity = 0.9
        self.addSubview(blurEffectView)
    }

    private func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }

    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
