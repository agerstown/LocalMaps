//
//  CoreDataHelper.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 17/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    //singleton
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    private override init() {
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last! as NSURL
        let storeURL = docsURL.URLByAppendingPathComponent("base.sqlite")
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            abort()
        }
        
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType) //NSManagedObjectContext()
        context.persistentStoreCoordinator = coordinator
        super.init()
    }
    
    func save() {
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
