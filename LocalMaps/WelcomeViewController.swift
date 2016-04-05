//
//  WelcomeViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 07/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WelcomeViewController: UIViewController {

    @IBOutlet weak var buttonMapList: UIButton!
    @IBOutlet weak var bottonLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getMapsList() {
        
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/items.json?method=get_maps")
            .responseJSON { response in
                
                let maps = JSON(response.result.value!)
                for map in maps.arrayValue {
                    let name = map["name"].stringValue
                    let descr = map["description"].stringValue
                    
                    let startDate = map["start_date"].stringValue
                    let endDate = map["end_date"].stringValue
                    var mapType: Map.mapType?
                    if (startDate != "none" && endDate != "none" && startDate != "" && endDate != "") {
                        mapType = Map.mapType.temporary
                    } else {
                        mapType = Map.mapType.permanent
                    }
        
                    let map = Map(name: name, descr: descr, type: mapType!)
                    self.mapsList.append(map)
                }
                self.performSegueWithIdentifier("welcomeToMapsListSegue", sender: nil)
            }
    }
    
    var mapsList = [Map]()
    
    @IBAction func mapsListButtonClicked(sender: AnyObject) {
        getMapsList()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is MapListViewController {
            User.currentUser = User(name: "user1", password: "blabla")
            User.currentUser?.maps = mapsList
            print(User.currentUser?.maps)
        }
    }
    
}
