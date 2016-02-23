//
//  ProfileViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    let user: User = User(name: "user1", password: "blabla")
    
    @IBOutlet weak var mapsTableView: UITableView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var addMapButton: UIBarButtonItem!
    
    let sections: [String] = ["permanent", "temporary"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapsTableView.delegate = self
        mapsTableView.dataSource = self
        mapsTableView.tableFooterView = UIView() // убрать разделители пустых ячеек
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.mapList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mapsTableView.dequeueReusableCellWithIdentifier("MapItemCell") as! MapItemCell
        let map = user.mapList[indexPath.row]
        cell.labelMapName.text = map.name 
        return cell
    }
}


extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let map = user.mapList[indexPath.row]
        
        //переход на другой экран по segue
        self.performSegueWithIdentifier("mapListToMapItem", sender: map) //nil)
        
        //убрать выделение ячейки
        mapsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}




