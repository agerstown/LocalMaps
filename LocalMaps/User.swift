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
    var maps = [Map]()
    //var permanentMapsList = [Map]()
    //var temporaryMapsList = [Map]()
    
    var permanentMaps: [Map] {
        get {
            var mapsOfType = [Map]()
            for map in maps {
                if (map.type == Map.mapType.permanent) {
                    mapsOfType.append(map)
                }
            }
            return mapsOfType
        }
    }

    var temporaryMaps: [Map] {
        get {
            var mapsOfType = [Map]()
            for map in maps {
                if (map.type == Map.mapType.temporary) {
                    mapsOfType.append(map)
                }
            }
            return mapsOfType
        }
    }
    
    static var currentUser: User?
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
        let map1 = Map(name: "map1_" + name, descr: "first map", type: Map.mapType.permanent)
        
        let start = NSDate(timeIntervalSinceNow: NSTimeInterval(60))
        let end = NSDate(timeIntervalSinceNow: NSTimeInterval(600))
        
        let map2 = Map(name: "map2_" + name, descr: "second map", type: Map.mapType.temporary)
        map2.startDate = start
        map2.endDate = end
        
        map2.images.append((UIImage(named: "photo"))!)

        //permanentMapsList.append(map1)
        //temporaryMapsList.append(map2)
        maps.append(map1)
        maps.append(map2)
    }
    
//    func getMapsOfType(type: Map.mapType) -> [Map] {
//        var mapsOfType = [Map]()
//        for map in maps {
//            if (map.type == type) {
//                mapsOfType.append(map)
//            }
//        }
//        return mapsOfType
//    }
}
