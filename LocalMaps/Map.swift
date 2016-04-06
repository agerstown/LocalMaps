//
//  Map.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import MapKit

@objc(Map)
class Map: NSObject {

    enum mapType {
        case permanent
        case temporary
    }
    
    var id: Int?
    
    var name: String
    var descr: String
    var type: mapType
    
    var spotList: [Spot] = []
    
    var place: GMSPlace?
    var coordinate: CLLocationCoordinate2D?
    var zoom: Float?
    var creator: String?
    
    var startDate: NSDate?
    var endDate: NSDate?
    
//    var northEastCoordinate: CLLocationCoordinate2D?
//    var southWestCoordinate: CLLocationCoordinate2D?
    
    var images: [UIImage] = [UIImage]()
   
    init(name: String, descr: String, type: mapType) {
        self.name = name
        self.descr = descr
        self.type = type
        super.init()
    }
}
