//
//  Pointer.swift
//  DreamDestination
//
//  Created by kuroro on 26/07/2020.
//  Copyright © 2020 lucasam. All rights reserved.
//

import MapKit
import UIKit

class Pointer: NSObject, MKAnnotation {
    // MARK: Properties
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
