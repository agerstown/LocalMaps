//
//  AddSpotViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 14/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class AddSpotViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBix: UITextField!
    @IBOutlet weak var addSpotButton: UIButton!
    
    //var mapViewController: UIViewController?
    var marker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addSpotButtonClick(sender: AnyObject) {
        marker?.title = nameTextBox.text
        navigationController?.popViewControllerAnimated(true)
    }
    
}
