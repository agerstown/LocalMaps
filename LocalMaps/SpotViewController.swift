//
//  AddSpotViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 14/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class SpotViewController: UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var addSpotButton: UIButton!
    @IBOutlet weak var addEventBarButton: UIBarButtonItem!
    
    var mapView: GMSMapView?
    var marker: GMSMarker?
    var map: Map?
    var mapViewController: MapViewController?
    
    var name: String?
    var descr: String?
    
    enum mode {
        case save
        case edit
    }
    
    var currentMode = mode.save
    
    let commonMethods = CommonMethodsForCotrollers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSpotData()
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissItems")
        view.addGestureRecognizer(tap)
    }
    
    func loadSpotData() {
        if let name = name {
            nameTextBox.text = name
            currentMode = mode.save
            addSpotButton.setTitle("Save", forState: UIControlState.Normal)
            self.title = "Edit spot"
        }
        if let descr = descr {
            descriptionTextBox.text = descr
        }
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }
    
    @IBAction func addSpotButtonClick(sender: AnyObject) {
        if nameTextBox.text?.isEmpty == true {
            commonMethods.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            
            if currentMode == mode.save {
                let coordinate = marker?.position
                let spot = Spot(name: name, descr: descr, coordinate: coordinate!)
                map?.spotList.append(spot)
                mapViewController?.markerToSpotDictionary[marker!] = spot
                marker?.map = mapView
                marker?.draggable = true
            }
            
            marker?.title = nameTextBox.text
            marker?.snippet = descriptionTextBox.text
            
            mapView?.selectedMarker = nil
            mapView?.selectedMarker = marker
            
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
}

extension SpotViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
