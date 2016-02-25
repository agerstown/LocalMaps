//
//  LoginViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? MapListViewController {
            User.currentUser = User(name: "user2", password: "blabla")
            //вот тут я должна по логину чувака подтягивать его конкретно
            controller.shouldAddAddButton = true
        }
    }

}
