//
//  User.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String
    var password: String
    var permanentMapsList: [Map] = []
    var temporaryMapsList: [Map] = []
    var mapList: [Map] = []
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
        let map1 = Map(name: "map1_" + name, descr: "first map", type: mapType.permanent, period: "forever", coordinates: [0,0])
        let map2 = Map(name: "map2_" + name, descr: "second map", type: mapType.temporary, period: "10.01.2016", coordinates: [0,0])
        mapList.append(map1)
        permanentMapsList.append(map1)
        mapList.append(map2)
        temporaryMapsList.append(map2)
    }
    
}
