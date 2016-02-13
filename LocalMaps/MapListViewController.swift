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
    
    var user: User?// = User(id: "1", name: "user1", password: "blabla")
    
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
                //controller.descr = map.descr
                //controller.image = map.image
                controller.map = map
            }
        }
    }

}


extension MapListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user!.mapList.count //10 //array count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewMaps.dequeueReusableCellWithIdentifier("MapItemCell") as! MapItemCell
        //var item = array[indexPath.row]
        let map = user!.mapList[indexPath.row]
        cell.labelMapName.text = map.name //"\(indexPath.row*10) rub"
        return cell
    }
}


extension MapListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let map = user!.mapList[indexPath.row]
        
        //переход на другой экран по segue
        self.performSegueWithIdentifier("mapListToMapItem", sender: map) //nil)
        
        //убрать выделение ячейки
        tableViewMaps.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

