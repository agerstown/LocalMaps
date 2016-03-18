//
//  CommonMethodsForCotrollers.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/18/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class CommonMethodsForCotrollers: UIViewController {
    func showAlert(controller: UIViewController, title: String, message: String) {
        let emptyNameFieldAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
        emptyNameFieldAlertController.addAction(OKAction)
        controller.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
    }
}
