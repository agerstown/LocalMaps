//
//  Event.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class Event: NSObject {

    var name: String
    var startTime: Date?
    var endTime: Date?
    
    init(name: String, startTime: Date, endTime: Date) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }
}
