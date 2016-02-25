//
//  User.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 06/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(User)
class User: NSManagedObject { //NSObject {

    @NSManaged var name: String
    @NSManaged var password: String
    var permanentMapsList: [Map] = []
    var temporaryMapsList: [Map] = []
    var mapList: [Map] = []
    
    static var currentUser: User?
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init(name: String, password: String) {
        self.init(entity: User.entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)
        self.name = name
        self.password = password
        let map1 = Map(name: "map1_" + name, descr: "first map", type: mapType.permanent)
        let map2 = Map(name: "map2_" + name, descr: "second map", type: mapType.temporary)
        mapList.append(map1)
        permanentMapsList.append(map1)
        mapList.append(map2)
        temporaryMapsList.append(map2)
    }
    
    class func allUsers() -> [User] {
        let request = NSFetchRequest(entityName: "User")
        var result: [AnyObject]?
        do {
            result = try CoreDataHelper.instance.context.executeFetchRequest(request)
        } catch { }
        
        return result as! [User]
    }
    
//    init(name: String, password: String) {
//        //super.init()
//        //self.name = name
//        //self.password = password
//        let map1 = Map(name: "map1_" + name, descr: "first map", type: mapType.permanent, period: "forever", coordinates: [0,0])
//        let map2 = Map(name: "map2_" + name, descr: "second map", type: mapType.temporary, period: "10.01.2016-10.05.2016", coordinates: [0,0])
//        mapList.append(map1)
//        permanentMapsList.append(map1)
//        mapList.append(map2)
//        temporaryMapsList.append(map2)
//    }
    
}
