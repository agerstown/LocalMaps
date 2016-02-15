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
            controller.user = User(id: "2", name: "user2", password: "blabla")
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: nil)
            controller.navigationItem.rightBarButtonItem = addButton
            //вот тут я должна по логину чувака подтягивать его конкретно
        }
    }

}
