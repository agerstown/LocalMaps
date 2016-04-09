//
//  CommonMethodsForCotrollers.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/18/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class CommonMethodsForCotrollers: UIViewController {
    
    static let sharedInstance = CommonMethodsForCotrollers()
    
    func showAlert(controller: UIViewController, title: String, message: String) {
        let emptyNameFieldAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
        emptyNameFieldAlertController.addAction(OKAction)
        controller.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
    }
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func startActivityIndicator(controller: UIViewController) {
        activityIndicator.center = view.center
        controller.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
