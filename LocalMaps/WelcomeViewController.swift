//
//  WelcomeViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 07/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var buttonMapList: UIButton!
    @IBOutlet weak var bottonLogin: UIButton!
    
//    @IBAction func buttonMapListClick(sender: AnyObject) {
//        performSegueWithIdentifier("ShowAllMaps", sender: sender)
//    }
    
//    @IBAction func buttonLoginClick(sender: AnyObject) {
//        performSegueWithIdentifier("Login", sender: sender)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if segue.identifier == "ShowAllMaps" {
            if let controller = segue.destinationViewController as? MapListViewController {
                controller.user = User(id: "1", name: "user1", password: "blabla")
                //вообще я тут должна получать все карты что у нас есть
            }
        //}
    }
    
}
