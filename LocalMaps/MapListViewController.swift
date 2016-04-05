//
//  MapListViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 05/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapListViewController: UIViewController {

    @IBOutlet var tableViewMaps: UITableView!
    @IBOutlet weak var searchBarMap: UISearchBar!
    
    var shouldAddAddButton: Bool?
    
    var mapsList = [Map]()
    
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
                
                User.currentUser?.maps = self.mapsList
                self.tableViewMaps.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMapsList()
        User.currentUser = User(name: "user2", password: "blabla")
        
        tableViewMaps.delegate = self
        tableViewMaps.dataSource = self
        tableViewMaps.tableFooterView = UIView() // убрать разделители пустых ячеек
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MapListViewController.addMapButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        tableViewMaps.reloadData()
    }
    
    func addMapButtonClicked(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("mapsListToAddMapSegue", sender: sender)
    }
    
    //MARK: Data send
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapItemViewController {
            if let map = sender as? Map {
                controller.title = map.name
                controller.map = map
            }
        }
    }

}

let sections = ["Permanent", "Temporary"]

extension MapListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return User.currentUser!.permanentMaps.count
        } else {
            return User.currentUser!.temporaryMaps.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableViewMaps.dequeueReusableCellWithIdentifier("MapItemCell") as! MapItemCell
        
        if indexPath.section == 0 {
            cell.labelMapName.text = User.currentUser?.permanentMaps[indexPath.row].name
            cell.labelMapPeriod.text = nil
        } else {
            cell.labelMapName.text = User.currentUser?.temporaryMaps[indexPath.row].name
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            let startDate = User.currentUser?.temporaryMaps[indexPath.row].startDate
            cell.labelMapPeriod.text = dateFormatter.stringFromDate(startDate!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var mapToDelete: Map?
            if indexPath.section == 0 {
                mapToDelete = User.currentUser?.permanentMaps[indexPath.row]
            }
            else {
                mapToDelete = User.currentUser?.temporaryMaps[indexPath.row]
            }
            User.currentUser?.maps.removeObject(mapToDelete!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var map: Map?
        if indexPath.section == 0 {
            map = User.currentUser?.permanentMaps[indexPath.row]
        } else {
            map = User.currentUser?.temporaryMaps[indexPath.row]
        }
        
        //переход на другой экран по segue
        self.performSegueWithIdentifier("mapListToMapItem", sender: map)
        
        //убрать выделение ячейки
        tableViewMaps.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

