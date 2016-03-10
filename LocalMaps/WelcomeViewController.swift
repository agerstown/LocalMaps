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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is MapListViewController {
            User.currentUser = User(name: "user1", password: "blabla")
            //вообще я тут должна получать все карты что у нас есть
        }
    }
    
}
