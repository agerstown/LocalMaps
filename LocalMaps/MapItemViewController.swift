//
//  MapItemViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 07/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapItemViewController: UIViewController {
    
    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var labelMapDescription: UILabel!
    @IBOutlet weak var buttonMap: UIBarButtonItem!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    var map: Map?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.title = map!.name
        
        if map?.type == Map.mapType.temporary { 
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let period = dateFormatter.stringFromDate((map?.startDate!)!) + " - " + dateFormatter.stringFromDate((map?.endDate!)!)
            periodLabel.text = period
        } else {
            imageViewConstraint.constant = 64
            periodLabel.hidden = true
        }
        
        labelMapDescription.text = map!.descr
        if map!.images.count != 0 {
            imageViewMap.image = map!.images[0]
        }
    }
    
    @IBAction func mapButtonClicked(sender: AnyObject) {
        getSpots(map!)
    }
    
    func getSpots(map: Map) {
        
        CommonMethods.sharedInstance.startActivityIndicator(self)
        
        map.spotList.removeAll()
        
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/items.json?method=get_spots&map_id=\(map.id!)")
            .responseJSON { response in
                let spots = JSON(response.result.value!)
                for spot in spots.arrayValue {
                    let id = spot["id"].intValue
                    let name = spot["name"].stringValue
                    let descr = spot["description"].stringValue
                    let longitude = spot["longitude"].doubleValue
                    let latitude = spot["latitude"].doubleValue
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let type = spot["type"].stringValue
                    
                    let newSpot = Spot(name: name, descr: descr, coordinate: coordinate)
                    newSpot.type = type
                    newSpot.id = id
                    map.spotList.append(newSpot)
                }
                
                CommonMethods.sharedInstance.stopActivityIndicator()
                
                self.performSegueWithIdentifier("MapItemToMapSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         self.title = "Back"
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapViewController {
            controller.title = map!.name
            controller.map = map
        } else if let controller = segue.destinationViewController as? AddMapViewController {
            controller.mapToPass = map
        }
    }

}
