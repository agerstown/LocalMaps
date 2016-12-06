//
//  AppDelegate.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 05/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyBYVuJxn1NegSXeRAHSBkzNcOf_Yyibq_M"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            GMSPlacesClient.provideAPIKey(googleMapsApiKey)
            GMSServices.provideAPIKey(googleMapsApiKey)
            return true
    }
}

