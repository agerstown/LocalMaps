//
//  Event.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class Event: NSObject {

    var date: [Int]
    var id: String
    var name: String
    var descr: String
    
    init(date: [Int], id: String, name: String, descr: String) {
        self.date = date
        self.id = id
        self.name = name
        self.descr = descr
    }
}
