//
//  User.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Foundation

@objc(User)
class User: NSObject {

    var name: String
    var password: String
    var permanentMapsList = [Map]()
    var temporaryMapsList = [EventMap]()
    
    static var currentUser: User?
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
        let map1 = Map(name: "map1_" + name, descr: "first map")
        
        let start = NSDate(timeIntervalSinceNow: NSTimeInterval(60))
        let end = NSDate(timeIntervalSinceNow: NSTimeInterval(600))
        
        let map2 = EventMap(name: "map2_" + name, descr: "second map", startDate: start, endDate: end)
        map2.images.append((UIImage(named: "photo"))!)

        permanentMapsList.append(map1)
        temporaryMapsList.append(map2)
    }
}
