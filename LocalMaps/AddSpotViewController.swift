//
//  AddSpotViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 14/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class AddSpotViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var addSpotButton: UIButton!
    @IBOutlet weak var descriptionTextBox: UITextField!
    
    var mapView: GMSMapView?
    var marker: GMSMarker?
    var map: Map?
    var mapViewController: MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addSpotButtonClick(sender: AnyObject) {
        if nameTextBox.text?.isEmpty == true {
            let emptyNameFieldAlertController = UIAlertController(title: "Empty name field", message: "Please enter a name of the spot", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            emptyNameFieldAlertController.addAction(OKAction)
            
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            let coordinate = marker?.position
        
            let spot = Spot(name: name, descr: descr, coordinate: coordinate!)
            map?.spotList.append(spot)
            mapViewController?.markerToSpotDictionary[marker!] = spot
        
            marker?.title = nameTextBox.text
            marker?.snippet = descriptionTextBox.text
            marker?.map = mapView
            marker?.draggable = true
        
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
}
