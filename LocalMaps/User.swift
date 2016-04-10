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
    }

}
