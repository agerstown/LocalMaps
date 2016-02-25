//
//  Map.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import MapKit

enum mapType {
    case permanent, temporary
}

@objc(Map)
class Map: NSObject {

    var name: String
    var descr: String
    var type: mapType
    var spotList: [Spot] = []
    var period: String?
    var coordinate: CLLocationCoordinate2D?
    var images: [UIImage] = [UIImage]()
    
    init(name: String, descr: String, type: mapType) {
        self.name = name
        self.descr = descr
        self.type = type
    }
}
