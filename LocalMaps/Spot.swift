//
//  Spot.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

@objc(Spot)
class Spot: NSObject {
    
    var id: Int?
    var name: String
    var descr: String
    var type = ""
    var pictureList: [UIImage] = []
    var coordinate: CLLocationCoordinate2D
    var eventList: [Event] = []
    
    init(name: String, descr: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.descr = descr
        self.coordinate = coordinate
        super.init()
    }

}
