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

    var name: String
    var descr: String
    
    var spotList: [Spot] = []
    
    var coordinate: CLLocationCoordinate2D?
    var zoom: Float?
    var creator: User?
    
//    var northEastCoordinate: CLLocationCoordinate2D?
//    var southWestCoordinate: CLLocationCoordinate2D?
    
    var images: [UIImage] = [UIImage]()
   
    init(name: String, descr: String) {
        self.name = name
        self.descr = descr
        super.init()
    }
}

@objc(EventMap)
class EventMap: Map {
    var period: String?
}
