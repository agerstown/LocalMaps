//
//  Spot.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class Spot: NSObject {

    var id: String
    var name: String
    var descr: String
    var pictureList: [UIImage] = []
    var coordinates: [Double]
    var eventList: [Event] = []
    
    init(id: String, name: String, descr: String, coordinates: [Double]) {
        self.id = id
        self.name = name
        self.descr = descr
        self.coordinates = coordinates
    }
}
