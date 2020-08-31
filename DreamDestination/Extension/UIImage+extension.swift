//
//  UIImage+extension.swift
//  DreamDestination
//
//  Created by kuroro on 09/08/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import UIKit

extension UIImage {
    func rotateCameraImageToProperOrientation(maxResolution: CGFloat) -> UIImage {
        let imgRef: CGImage = cgImage!
        let width: CGFloat = CGFloat(imgRef.width)
        let height: CGFloat = CGFloat(imgRef.height)

        var bounds: CGRect = CGRect(x: 0, y: 0, width: width, height: height)

        var scaleRatio: CGFloat = 1
        if width > maxResolution || height > maxResolution {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height *= scaleRatio
            bounds.size.width *= scaleRatio
        }

        var transform: CGAffineTransform = .identity
        let orient: UIImage.Orientation = imageOrientation
        let imageSize: CGSize = CGSize(width: imgRef.width, height: imgRef.height)

        switch imageOrientation {
        case .up :
            transform = .identity
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0, y: imageSize.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: 0, y: imageSize.width)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored :
            let storedHeight: CGFloat = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = storedHeight
            transform = CGAffineTransform(scaleX: -1, y: 1)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        default: break
        }

        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()

        if orient == .right || orient == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio)
            context!.translateBy(x: -height, y: 0)
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio)
            context!.translateBy(x: 0, y: -height)
        }

        context!.concatenate(transform)
        context!.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))

        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return imageCopy!
    }

    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    func compress(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
