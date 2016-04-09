//
//  AddSpotViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 14/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SpotViewController: UIViewController {
    
    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var addEventBarButton: UIBarButtonItem!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var createSpotButton: UIBarButtonItem!
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    
    var mapView: GMSMapView?
    var marker: GMSMarker?
    var map: Map?
    var mapViewController: MapViewController?
    var currentSpot: Spot?
    
    let types = ["default", "bar", "dining", "wc", "star", "movies", "atm", "bike", "flower", "fitness"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        
        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.tableFooterView = UIView()
        
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SpotViewController.dismissItems))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadSpotData()
        eventsTableView.reloadData()
        selectedEvent = nil
    }
    
    func loadSpotData() {
        if let name = currentSpot?.name {
            nameTextBox.text = name
            createSpotButton.title = "Save"
            self.title = "Edit spot"
        }
        if let descr = currentSpot?.descr {
            descriptionTextBox.text = descr
        }
        if currentSpot?.pictureList.isEmpty == false {
            spotImageView.image = currentSpot?.pictureList[0]
        }
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }
    
    @IBAction func addEventClicked(sender: AnyObject) {
        if (currentSpot == nil) {
            if (nameTextBox.text?.isEmpty == true) {
                CommonMethodsForCotrollers.sharedInstance.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
            } else {
                let name = nameTextBox.text!
                let descr = descriptionTextBox.text!
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
            }
        }
        performSegueWithIdentifier("spotToAddEventSegue", sender: nil)
    }
    
    func postSpot(spot: Spot) {
        let name = spot.name
        let descr = spot.descr
        let long = spot.coordinate.longitude
        let lat = spot.coordinate.latitude
        let type = spot.type
        let map_id = (map!.id)!
        
        var link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_spot&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\", \"type\":\"\(type)\",\"map\": \(map_id)}"
        link = link.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, link) .responseJSON { response in
            print(response.result.value)
            let id = JSON(response.result.value!)
            spot.id = id.intValue
        }
    }

    var type: String?
    
    @IBAction func createSpotButtonClicked(sender: AnyObject) {
        if nameTextBox.text?.isEmpty == true {
            CommonMethodsForCotrollers.sharedInstance.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            
            if currentSpot == nil {
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
                currentSpot?.name = name
                currentSpot?.descr = descr
                postSpot(currentSpot!)
            }
        
            currentSpot?.name = name
            currentSpot?.descr = descr
            
            if let type = type {
                currentSpot?.type = type
            }
            
            if (map?.spotList.contains(currentSpot!) == false) {
                map?.spotList.append(currentSpot!)
            }
            
            mapViewController?.markerToSpotDictionary[marker!] = currentSpot
            
            marker?.map = mapView
            marker?.draggable = true
            
            if let image = image {
                if (currentSpot?.pictureList.isEmpty == true) {
                    currentSpot?.pictureList.append(image)
                } else {
                    currentSpot?.pictureList[0] = image
                }
            }
            
            marker?.title = nameTextBox.text
            marker?.snippet = descriptionTextBox.text
            marker?.icon = UIImage(named: "\(currentSpot?.type)_pin")
            
            mapView?.selectedMarker = marker
            
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBAction func addPictureButtonClicked(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func deleteSpot(spot: Spot) {
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/items.json?method=destroy_spot&spot_id=\(spot.id!)")
    }
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        if let spot = currentSpot {
            map?.spotList.removeObject(spot)
            deleteSpot(spot)
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

extension SpotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            spotImageView.image = image
            if (currentSpot?.pictureList.isEmpty == true) {
                currentSpot?.pictureList.append(image!)
            } else {
                currentSpot?.pictureList[0] = image!
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SpotViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SpotTypeCell", forIndexPath: indexPath) as! SpotTypeCell
        let image = UIImage(named: types[indexPath.row])
        cell.layer.borderWidth = 0
        if (types[indexPath.row] == currentSpot?.type) {
            highlightCell(cell)
        }
        cell.typeImageView.image = image
        return cell
    }
}

extension SpotViewController: UICollectionViewDelegate {
    
    func highlightCell(cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        collectionView.visibleCells().forEach { $0.layer.borderWidth = 0 }
        highlightCell(cell!)
        type = types[indexPath.row]
        currentSpot?.type = type!
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.layer.borderWidth = 0
    }
}