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
        
        User.currentUser?.maps.removeAll()
        
        let temporaryMap = Map(name: "День Вышки", descr: "Лекции, мастер-классы, спорт и много музыки", type: Map.mapType.temporary)
        
        temporaryMap.id = 1
        temporaryMap.coordinate = CLLocationCoordinate2D(latitude: 55.7283648679523, longitude: 37.601290717721)
        temporaryMap.zoom = 15
        temporaryMap.creator = "Natasha"
        
        
        let startDateTime = CommonMethods.sharedInstance.getDate(hour: 11)
        temporaryMap.startDate = startDateTime
        
        let endDateTime = CommonMethods.sharedInstance.getDate(hour: 16)
        temporaryMap.endDate = endDateTime
        
        User.currentUser?.maps.append(temporaryMap)
        
        let permanentMap = Map(name: "Парк Сокольники", descr: "Самый большой парк Москвы", type: Map.mapType.permanent)
        
        permanentMap.id = 2
        permanentMap.coordinate = CLLocationCoordinate2D(latitude: 55.7950677, longitude: 37.6743927)
        permanentMap.zoom = 15
        permanentMap.creator = "Natasha"
        
        User.currentUser?.maps.append(permanentMap)
        self.copyToMapsList()
        self.tableViewMaps.reloadData()
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
        self.refreshControl.addTarget(self, action: #selector(MapListViewController.refreshTable), for: UIControlEvents.valueChanged)
        self.tableViewMaps.addSubview(self.refreshControl)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MapListViewController.addMapButtonClicked(_:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewMaps.reloadData()
    }
    
    func refreshTable()
    {
        getMapsList()
        self.refreshControl.endRefreshing()
        tableViewMaps.reloadData()
    }
    
    func addMapButtonClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "mapsListToAddMapSegue", sender: sender)
    }
    
    //MARK: Data send
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //куда мы направляемся
        if let controller = segue.destination as? MapItemViewController {
            if let map = sender as? Map {
                controller.title = map.name
                controller.map = map
            }
        }
    }

}

let sections = ["Permanent", "Temporary"]

extension MapListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return permanentMaps.count
        } else {
            return temporaryMaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewMaps.dequeueReusableCell(withIdentifier: "MapItemCell") as! MapItemCell
        
        if indexPath.section == 0 {
            cell.labelMapName.text = permanentMaps[indexPath.row].name
            cell.labelMapPeriod.text = nil
        } else {
            cell.labelMapName.text = temporaryMaps[indexPath.row].name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            
            let startDate = temporaryMaps[indexPath.row].startDate
            cell.labelMapPeriod.text = dateFormatter.string(from: startDate! as Date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            var mapToDelete: Map?
            if indexPath.section == 0 {
                mapToDelete = permanentMaps[indexPath.row]
            }
            else {
                mapToDelete = temporaryMaps[indexPath.row]
            }
            User.currentUser?.maps.removeObject(mapToDelete!)
            mapsList.removeObject(mapToDelete!)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var map: Map?
        if indexPath.section == 0 {
            map = permanentMaps[indexPath.row]
        } else {
            map = temporaryMaps[indexPath.row]
        }

        //убрать выделение ячейки
        tableViewMaps.deselectRow(at: indexPath, animated: true)

        self.performSegue(withIdentifier: "mapListToMapItem", sender: map)
    }
    
}

extension MapListViewController: UISearchBarDelegate {
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        mapsList.removeAll(keepingCapacity: false)
        
        for map in (User.currentUser?.maps)!
        {
            let name: NSString! = map.name as NSString
            let substringRange: NSRange! = name.range(of: substring, options: [.caseInsensitive])
            if (substringRange.location  == 0 || substring == "") {
                mapsList.append(map)
            }
        }
        
        tableViewMaps.reloadData()
    }
    
    func cancelSearch() {
        searchBarMap.resignFirstResponder()
        copyToMapsList()
        tableViewMaps.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") {
            cancelSearch()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let substring = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarMap.text = ""
        cancelSearch()
    }
}

