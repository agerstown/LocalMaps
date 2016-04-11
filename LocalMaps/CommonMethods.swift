//
//  CommonMethodsForCotrollers.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/18/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire

class CommonMethods {
    
    static let sharedInstance = CommonMethods()
    
    func showAlert(controller: UIViewController, title: String, message: String) {
        let emptyNameFieldAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
        emptyNameFieldAlertController.addAction(OKAction)
        controller.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func startActivityIndicator(controller: UIViewController) {
        activityIndicator.center = controller.view.center
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func updateSpot(spot: Spot, map: Map) {
        if let id = spot.id {
        //let id = spot.id!
            let name = spot.name
            let descr = spot.descr
            let long = spot.coordinate.longitude
            let lat = spot.coordinate.latitude
            let type = spot.type
            let map_id = (map.id)!
        
            var link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_spot&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\", \"type\":\"\(type)\",\"map\": \(map_id)}&map_id=\(map_id)&spot_id=\(id)"
            link = link.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
            Alamofire.request(.GET, link)
        }
    }

    func updateMap(map: Map) {
        if let id = map.id {
        //let id = (map.id)!
            let name = map.name
            let descr = map.descr
            let long = map.coordinate!.longitude
            let lat = map.coordinate!.latitude
            let startDate = map.startDate
            let endDate = map.endDate
            var zoom: Float?
            if let zooom = map.zoom {
                zoom = zooom
            } else {
                zoom = 15
            }
        
            var type: String?
            var start = "None"
            var end = "None"
        
            var link = ""
        
            if map.type == Map.mapType.temporary {
                type = "Temporary"
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
                start = dateFormatter.stringFromDate(startDate!)
                end = dateFormatter.stringFromDate(endDate!)
            
                link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_map&data={\"map_id\":\"\(id)\", \"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"start_date\":\"\(start)\",\"end_date\":\"\(end)\",\"author\":\"Natasha\"}&map_id=\(id)"
            } else {
                type = "Permanent"
            
                link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_map&data={\"map_id\":\"\(id)\", \"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"author\":\"Natasha\"}&map_id=\(id)"
            }
        
            link = link.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
            Alamofire.request(.GET, link)
        }
    }
    
}
