//
//  User.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class User: NSObject {

    var id: String
    var name: String
    var password: String
    var permanentMapsList: [Map] = []
    var temporaryMapsList: [Map] = []
    var mapList: [Map] = []
    
    init(id: String, name: String, password: String) {
        self.id = id
        self.name = name
        self.password = password
        let map1 = Map(id: "1", name: "map1_" + name, descr: "first map", type: mapType.permanent, period: "forever", coordinates: [0,0])
        let map2 = Map(id: "2", name: "map2_" + name, descr: "second map", type: mapType.temporary, period: "10.01.2016", coordinates: [0,0])
        mapList.append(map1)
        permanentMapsList.append(map1)
        mapList.append(map2)
        temporaryMapsList.append(map2)
    }
    
}
