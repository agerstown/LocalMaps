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

class Map: NSObject {

    var id: String
    var name: String
    var descr: String
    var type: mapType
    var spotList: [Spot] = []
    var period: String
    var coordinates: [Double]
    var map: MKMapView = MKMapView()
    var image: UIImage = UIImage()
    
    init(id: String, name: String, descr: String, type: mapType, period: String, coordinates: [Double]) {
        self.id = id
        self.name = name
        self.descr = descr
        self.type = type
        self.period = period
        self.coordinates = coordinates
    }
}
