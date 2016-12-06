//
//  CommonMethods.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/18/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire

class CommonMethods {
    
    static let sharedInstance = CommonMethods()
    
    func showAlert(_ controller: UIViewController, title: String, message: String) {
        let emptyNameFieldAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel) { (action) in }
        emptyNameFieldAlertController.addAction(OKAction)
        controller.present(emptyNameFieldAlertController, animated: true, completion: nil)
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func startActivityIndicator(_ controller: UIViewController) {
        activityIndicator.center = controller.view.center
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func getDate(hour: Int) -> Date {
        var dateComponents1 = DateComponents()
        dateComponents1.year = 2016
        dateComponents1.month = 9
        dateComponents1.day = 9
        dateComponents1.timeZone = TimeZone(abbreviation: "GMT") // Japan Standard Time
        dateComponents1.hour = hour
        dateComponents1.minute = 00
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        return userCalendar.date(from: dateComponents1)!
    }
    
//    func updateSpot(_ spot: Spot, map: Map) {
//        if let id = spot.id {
//            let name = spot.name
//            let descr = spot.descr
//            let long = spot.coordinate.longitude
//            let lat = spot.coordinate.latitude
//            let type = spot.type
//            let map_id = (map.id)!
//        
//            var link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_spot&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\", \"type\":\"\(type)\",\"map\": \(map_id)}&map_id=\(map_id)&spot_id=\(id)"
//            link = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//            Alamofire.request(link)
//        }
//    }

//    func updateMap(_ map: Map) {
//        if let id = map.id {
//            let name = map.name
//            let descr = map.descr
//            let long = map.coordinate!.longitude
//            let lat = map.coordinate!.latitude
//            let startDate = map.startDate
//            let endDate = map.endDate
//            var zoom: Float?
//            if let zooom = map.zoom {
//                zoom = zooom
//            } else {
//                zoom = 15
//            }
//        
//            var type: String?
//            var start = "None"
//            var end = "None"
//        
//            var link = ""
//        
//            if map.type == Map.mapType.temporary {
//                type = "Temporary"
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
//                start = dateFormatter.string(from: startDate! as Date)
//                end = dateFormatter.string(from: endDate! as Date)
//            
//                link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_map&data={\"map_id\":\"\(id)\", \"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"start_date\":\"\(start)\",\"end_date\":\"\(end)\",\"author\":\"Natasha\"}&map_id=\(id)"
//            } else {
//                type = "Permanent"
//            
//                link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=update_map&data={\"map_id\":\"\(id)\", \"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"author\":\"Natasha\"}&map_id=\(id)"
//            }
//        
//            link = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//            Alamofire.request(link)
//        }
//    }
    
}
