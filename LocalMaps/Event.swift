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
    var startTime: NSDate?
    var endTime: NSDate?
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
