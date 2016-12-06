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
    
    let types = ["Default", "Bar", "Dining", "Wc", "Star", "Movies", "Atm", "Bike", "Flower", "Fitness"]
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        selectedEvent = nil
        loadSpotData()
        eventsTableView.reloadData()
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
        if currentSpot?.id == 1 {
            //currentSpot?.eventList.removeAll()
            
            let start1 = CommonMethods.sharedInstance.getDate(hour: 12)
            let end1 = CommonMethods.sharedInstance.getDate(hour: 13)
            let event1 = Event(name: "Лекция К.Хабенского", startTime: start1, endTime: end1)
            
            let start2 = CommonMethods.sharedInstance.getDate(hour: 13)
            let end2 = CommonMethods.sharedInstance.getDate(hour: 14)
            let event2 = Event(name: "Выступление В.Путина", startTime: start2, endTime: end2)
            
            let containsDefault = currentSpot?.eventList.contains { event in
                if event.name == "Выступление В.Путина" || event.name == "Лекция К.Хабенского" {
                    return true
                } else {
                    return false
                }
            }
            if !containsDefault! {
                currentSpot?.eventList.append(event1)
                currentSpot?.eventList.append(event2)
            }
        }
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }
    
    @IBAction func addEventClicked(_ sender: AnyObject) {
        if (currentSpot == nil) {
            if (nameTextBox.text?.isEmpty == true) {
                CommonMethods.sharedInstance.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
            } else {
                let name = nameTextBox.text!
                let descr = descriptionTextBox.text!
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
            }
        }
        performSegue(withIdentifier: "spotToAddEventSegue", sender: nil)
    }
    
//    func postSpot(_ spot: Spot) {
//        let name = spot.name
//        let descr = spot.descr
//        let long = spot.coordinate.longitude
//        let lat = spot.coordinate.latitude
//        let type = spot.type
//        let map_id = (map!.id)!
//        
//        var link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_spot&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\", \"type\":\"\(type)\",\"map\": \(map_id)}"
//        link = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        Alamofire.request(link) .responseJSON { response in
//            let id = JSON(response.result.value!)
//            spot.id = id.intValue
//        }
//    }

    var type: String?
    
    @IBAction func createSpotButtonClicked(_ sender: AnyObject) {
        if nameTextBox.text?.isEmpty == true {
            CommonMethods.sharedInstance.showAlert(self, title: "Empty name field", message: "Please enter a name of the spot")
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            
            if currentSpot == nil {
                let coordinate = marker?.position
                currentSpot = Spot(name: name, descr: descr, coordinate: coordinate!)
                currentSpot?.name = name
                currentSpot?.descr = descr
                if let type = type {
                    currentSpot?.type = type
                }
                //postSpot(currentSpot!)
            } else {
                currentSpot?.name = name
                currentSpot?.descr = descr
            
                if let type = type {
                    currentSpot?.type = type
                }
                //CommonMethods.sharedInstance.updateSpot(currentSpot!, map: map!)
            }
            if (map?.spotList.contains(currentSpot!) == false) {
                map?.spotList.append(currentSpot!)
            }
            
            mapViewController?.markerToSpotDictionary[marker!] = currentSpot
            
            marker?.map = mapView
            marker?.isDraggable = true
            
            if let image = image {
                changeImage(currentSpot!, image: image)
            }
            
            marker?.title = nameTextBox.text
            marker?.snippet = descriptionTextBox.text
            marker?.icon = UIImage(named: "\(currentSpot?.type)_pin")
            
            mapView?.selectedMarker = marker
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBAction func addPictureButtonClicked(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
//    func deleteSpot(_ spot: Spot) {
//        Alamofire.request("http://maps-staging.sandbox.daturum.ru/maps/items.json?method=destroy_spot&spot_id=\(spot.id!)&map_id=\((map?.id)!)")
//    }
    
    @IBAction func deleteButtonClicked(_ sender: AnyObject) {
        if let spot = currentSpot {
            map?.spotList.removeObject(spot)
            //deleteSpot(spot)
            navigationController?.popViewController(animated: true)
        }
    }
    
    var selectedEvent: Event?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EventViewController {
            controller.spot = currentSpot
            controller.currentEvent = selectedEvent
        }
    }
}

extension SpotViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SpotViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = currentSpot?.eventList.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell

        cell.eventNameLabel.text = currentSpot?.eventList[indexPath.row].name
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
            
        let startTime = currentSpot?.eventList[indexPath.row].startTime
        let endTime = currentSpot?.eventList[indexPath.row].endTime
        cell.periodLabel.text = dateFormatter.string(from: startTime! as Date) + " - " + dateFormatter.string(from: endTime! as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            currentSpot?.eventList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
}


extension SpotViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = currentSpot?.eventList[indexPath.row]
        self.performSegue(withIdentifier: "spotToAddEventSegue", sender: nil)
        eventsTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SpotViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func changeImage(_ spot: Spot, image: UIImage) {
        if (spot.pictureList.isEmpty == true) {
            spot.pictureList.append(image)
        } else {
            spot.pictureList[0] = image
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            spotImageView.image = image
            if let spot = currentSpot {
                changeImage(spot, image: image!)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SpotViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SpotTypeCell", for: indexPath) as! SpotTypeCell
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
    
    func highlightCell(_ cell: UICollectionViewCell) {
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.red.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        collectionView.visibleCells.forEach { $0.layer.borderWidth = 0 }
        highlightCell(cell!)
        type = types[indexPath.row]
        //currentSpot?.type = type!
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
}
