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
    @IBOutlet weak var eventsTableView: UITableView!
    
    var mapView: GMSMapView?
    var marker: GMSMarker?
    var map: Map?
    var mapViewController: MapViewController?
    
    var name: String?
    var descr: String?
    
    let commonMethods = CommonMethodsForCotrollers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSpotData()
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.tableFooterView = UIView() 
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissItems")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        eventsTableView.reloadData()
        selectedEvent = nil
    }
    
    func loadSpotData() {
        if let name = name {
            nameTextBox.text = name
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
    
    var currentSpot: Spot?
    
    
    @IBAction func addEventClicked(sender: AnyObject) {
        if (currentSpot == nil) {
            if (nameTextBox.text?.isEmpty == true) {
                commonMethods.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
            } else {
                let name = nameTextBox.text!
                let descr = descriptionTextBox.text!
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
            }
        }
        performSegueWithIdentifier("spotToAddEventSegue", sender: nil)
    }
    
    @IBAction func addSpotButtonClick(sender: AnyObject) {
        if nameTextBox.text?.isEmpty == true {
            commonMethods.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            
            if currentSpot == nil {
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
            }
            map?.spotList.append(currentSpot!)
            mapViewController?.markerToSpotDictionary[marker!] = currentSpot
            marker?.map = mapView
            marker?.draggable = true
            
            marker?.title = nameTextBox.text
            marker?.snippet = descriptionTextBox.text
            
            mapView?.selectedMarker = marker
            
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    var selectedEvent: Event?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? EventViewController {
            controller.spot = currentSpot
            controller.currentEvent = selectedEvent
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

extension SpotViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = currentSpot?.eventList.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = eventsTableView.dequeueReusableCellWithIdentifier("EventTableViewCell") as! EventTableViewCell

        cell.eventNameLabel.text = currentSpot?.eventList[indexPath.row].name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
        let startTime = currentSpot?.eventList[indexPath.row].startTime
        let endTime = currentSpot?.eventList[indexPath.row].endTime
        cell.periodLabel.text = dateFormatter.stringFromDate(startTime!) + " - " + dateFormatter.stringFromDate(endTime!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            currentSpot?.eventList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
}


extension SpotViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedEvent = currentSpot?.eventList[indexPath.row]
        self.performSegueWithIdentifier("spotToAddEventSegue", sender: nil)
        eventsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}