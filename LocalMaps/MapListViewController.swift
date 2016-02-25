//
//  MapListViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 05/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class MapListViewController: UIViewController {

    @IBOutlet var tableViewMaps: UITableView!
    @IBOutlet weak var searchBarMap: UISearchBar!
    
    var shouldAddAddButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewMaps.delegate = self
        tableViewMaps.dataSource = self
        tableViewMaps.tableFooterView = UIView() // убрать разделители пустых ячеек
        
        if shouldAddAddButton == true {
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMapButtonClicked:")
            self.navigationItem.rightBarButtonItem = addButton
        }
        
        //self.tableViewMaps.reloadData()
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
            return User.currentUser!.permanentMapsList.count //user!.permanentMapsList.count
        } else {
            return User.currentUser!.temporaryMapsList.count //user!.temporaryMapsList.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableViewMaps.dequeueReusableCellWithIdentifier("MapItemCell") as! MapItemCell
        
        if indexPath.section == 0 {
            cell.labelMapName.text = User.currentUser?.permanentMapsList[indexPath.row].name //map.name
        } else {
            cell.labelMapName.text = User.currentUser?.temporaryMapsList[indexPath.row].name
        }
        return cell
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var map: Map?
        if indexPath.section == 0 {
            map = User.currentUser?.permanentMapsList[indexPath.row]
        } else {
            map = User.currentUser?.temporaryMapsList[indexPath.row]
        }
        
        //переход на другой экран по segue
        self.performSegueWithIdentifier("mapListToMapItem", sender: map) //nil)
        
        //убрать выделение ячейки
        tableViewMaps.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

