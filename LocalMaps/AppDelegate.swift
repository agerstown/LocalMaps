//
//  AppDelegate.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 05/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyBYVuJxn1NegSXeRAHSBkzNcOf_Yyibq_M"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject: AnyObject]?) -> Bool {
            GMSServices.provideAPIKey(googleMapsApiKey)
            return true
    }
}

