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
    
    //var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMaps.delegate = self
        tableViewMaps.dataSource = self
        tableViewMaps.tableFooterView = UIView() // убрать разделители пустых ячеек
    }
    
    //MARK: Data send
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapItemViewController {
            if let map = sender as? Map {
                controller.title = map.name
                controller.map = map
                //controller.user = user
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
        let maps = User.currentUser!.permanentMapsList + User.currentUser!.temporaryMapsList //user!.permanentMapsList + user!.temporaryMapsList
        //let map = user!.mapList[indexPath.row]
        cell.labelMapName.text = maps[indexPath.row].name //map.name
        return cell
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let map = User.currentUser!.mapList[indexPath.row] //user!.mapList[indexPath.row]
        
        //переход на другой экран по segue
        self.performSegueWithIdentifier("mapListToMapItem", sender: map) //nil)
        
        //убрать выделение ячейки
        tableViewMaps.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

