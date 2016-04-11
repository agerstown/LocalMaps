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
    
    var refreshControl: UIRefreshControl!

    var mapsList = [Map]()
    
    var permanentMaps: [Map] {
        get {
            var mapsOfType = [Map]()
            for map in mapsList {
                if (map.type == Map.mapType.permanent) {
                    mapsOfType.append(map)
                }
            }
            return mapsOfType
        }
    }
    
    var temporaryMaps: [Map] {
        get {
            var mapsOfType = [Map]()
            for map in mapsList {
                if (map.type == Map.mapType.temporary) {
                    mapsOfType.append(map)
                }
            }
            return mapsOfType
        }
    }
    
    func getMapsList() {
        
        CommonMethodsForCotrollers.sharedInstance.startActivityIndicator(self)
        
        mapsList.removeAll()
        
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/items.json?method=get_maps")
            .responseJSON { response in
                
                let maps = JSON(response.result.value!)
                for map in maps.arrayValue {
                    let id = map["id"].intValue
                    let name = map["name"].stringValue
                    let descr = map["description"].stringValue
                    let type = map["type"].stringValue
                    let longitude = map["longitude"].doubleValue
                    let latitude = map["latitude"].doubleValue
                    let zoom = map["zoom"].floatValue
                    let creator = map["creator"].stringValue
                    
                    let startDate = map["start_date"].stringValue
                    let endDate = map["end_date"].stringValue
                    
                    var mapType: Map.mapType?
                    if (type == "Temporary") {
                        mapType = Map.mapType.temporary
                    } else {
                        mapType = Map.mapType.permanent
                    }
                    
                    let newMap = Map(name: name, descr: descr, type: mapType!)
                    
                    newMap.id = id
                    newMap.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    newMap.zoom = zoom
                    newMap.creator = creator
                    
                    if (newMap.type == Map.mapType.temporary) {
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
                        
                        newMap.startDate = dateFormatter.dateFromString(startDate)
                        newMap.endDate = dateFormatter.dateFromString(endDate)
                    }
                    
                    User.currentUser?.maps.append(newMap)
                }
                
                CommonMethodsForCotrollers.sharedInstance.stopActivityIndicator()
                
                self.copyToMapsList()
                self.tableViewMaps.reloadData()
        }
    }

    func copyToMapsList() {
        mapsList.removeAll()
        for map in (User.currentUser?.maps)! {
            mapsList.append(map)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.currentUser = User(name: "user2", password: "blabla")
        getMapsList()
        
        searchBarMap.delegate = self
        
        tableViewMaps.delegate = self
        tableViewMaps.dataSource = self
        tableViewMaps.tableFooterView = UIView() // убрать разделители пустых ячеек
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(MapListViewController.refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        self.tableViewMaps.addSubview(self.refreshControl)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(MapListViewController.addMapButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        tableViewMaps.reloadData()
    }
    
    func refreshTable()
    {
        getMapsList()
        self.refreshControl.endRefreshing()
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
            return permanentMaps.count
        } else {
            return temporaryMaps.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableViewMaps.dequeueReusableCellWithIdentifier("MapItemCell") as! MapItemCell
        
        if indexPath.section == 0 {
            cell.labelMapName.text = permanentMaps[indexPath.row].name
            cell.labelMapPeriod.text = nil
        } else {
            cell.labelMapName.text = temporaryMaps[indexPath.row].name
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            
            let startDate = temporaryMaps[indexPath.row].startDate
            cell.labelMapPeriod.text = dateFormatter.stringFromDate(startDate!)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func deleteMap(map: Map) {
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/items.json?method=destroy_map&map_id=\(map.id!)")
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var mapToDelete: Map?
            if indexPath.section == 0 {
                mapToDelete = permanentMaps[indexPath.row]
            }
            else {
                mapToDelete = temporaryMaps[indexPath.row]
            }
            User.currentUser?.maps.removeObject(mapToDelete!)
            mapsList.removeObject(mapToDelete!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            deleteMap(mapToDelete!)
        }
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var map: Map?
        if indexPath.section == 0 {
            map = permanentMaps[indexPath.row]
        } else {
            map = temporaryMaps[indexPath.row]
        }

        //убрать выделение ячейки
        tableViewMaps.deselectRowAtIndexPath(indexPath, animated: true)

        self.performSegueWithIdentifier("mapListToMapItem", sender: map)
    }
    
}

extension MapListViewController: UISearchBarDelegate {
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        mapsList.removeAll(keepCapacity: false)
        
        for map in (User.currentUser?.maps)!
        {
            let name: NSString! = map.name as NSString
            let substringRange: NSRange! = name.rangeOfString(substring, options: [.CaseInsensitiveSearch])
            if (substringRange.location  == 0 || substring == "") {
                mapsList.append(map)
            }
        }
        
        tableViewMaps.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let substring = (searchBar.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarMap.text = ""
        searchBarMap.resignFirstResponder()
        copyToMapsList()
        tableViewMaps.reloadData()
    }
}

