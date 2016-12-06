//
//  AddMapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 2/24/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GooglePlaces

class AddMapViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descriptionTextBox: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var searchBarHolderView: UIView!
    @IBOutlet weak var searchBarConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var addSpotsButton: UIButton!
    @IBOutlet weak var addSpotsButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addPhotosButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    let pickerData = ["Permanent","Temporary"]
    
    var selectedPlace: GMSPlace?
    
    var mapToPass: Map?
    
    var doesReallyEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapData()
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        placeTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        imagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddMapViewController.dismissItems))
        view.addGestureRecognizer(tap)
        
        if let place = selectedPlace {
            placeTextField.text = place.name
            doesReallyEdit = true
        }
    }
    
    func loadMapData() {
        if let map = mapToPass {
            nameTextBox.text = map.name
            descriptionTextBox.text = map.descr
            if let place = map.place {
                placeTextField.text = place.name
            }
            if map.type == Map.mapType.temporary {
                mapTypeSegmentedControl.selectedSegmentIndex = 1
                settingForTemporaryMap()
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.short
                dateFormatter.timeStyle = DateFormatter.Style.short
                startDate = map.startDate as Date?
                endDate = map.endDate as Date?
                startDateTextField.text = dateFormatter.string(from: startDate!)
                endDateTextField.text = dateFormatter.string(from: endDate!)
            }
            if let place = map.place {
                placeTextField.text = place.name
            }
            type = (mapToPass?.type)!
            addSpotsButton.isHidden = true
            saveButton.isHidden = false
            self.title = "Edit info"
        }
    }
    
    @IBAction func saveButtonClicked(_ sender: AnyObject) {
        mapToPass?.name = nameTextBox.text!
        mapToPass?.descr = descriptionTextBox.text!
        mapToPass?.type = type
        
        if let place = selectedPlace {
            mapToPass?.place = place
            mapToPass?.coordinate = place.coordinate
        }
        if let image = image {
            mapToPass?.images.append(image)
        }
        
        if mapToPass?.type == Map.mapType.temporary {
            mapToPass?.startDate = startDate!
            mapToPass?.endDate = endDate!
        } else {
            mapToPass?.startDate = nil
            mapToPass?.endDate = nil
        }
        
        //CommonMethods.sharedInstance.updateMap(mapToPass!)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }
    
    var type = Map.mapType.permanent
    
    @IBAction func placeTextFieldEditingDidBegin(_ sender: AnyObject) {
        if doesReallyEdit == true {
            resultsViewController = GMSAutocompleteResultsViewController()
            resultsViewController?.delegate = self
            
            searchController = UISearchController(searchResultsController: resultsViewController)
            searchController?.searchResultsUpdater = resultsViewController
            
            let searchBar = (searchController?.searchBar)!
            searchBarConstraint.constant = 44
            searchBarHolderView.addSubview(searchBar)
            
            nameConstraint.constant = 52
            
            searchBar.delegate = self
            
            searchBar.placeholder = "Place"
            searchController?.hidesNavigationBarDuringPresentation = true
            
            // When UISearchController presents the results view, present it in
            // this view controller, not one further up the chain.
            self.definesPresentationContext = true

            searchBar.becomeFirstResponder()
        }
    }
    
//    func postMap(_ map: Map) {
//        let name = map.name
//        let descr = map.descr
//        var long = 0.0
//        var lat = 0.0
//        if let coordinate = map.coordinate {
//            long = coordinate.longitude
//            lat = coordinate.latitude
//        }
//        let startDate = map.startDate
//        let endDate = map.endDate
//        var zoom: Float?
//        if let zooom = map.zoom {
//            zoom = zooom
//        } else {
//            zoom = 15
//        }
//        
//        var type: String?
//        var start = "None"
//        var end = "None"
//
//        var link = ""
//        
//        if map.type == Map.mapType.temporary {
//            type = "Temporary"
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
//            start = dateFormatter.string(from: startDate! as Date)
//            end = dateFormatter.string(from: endDate! as Date)
//            
//            link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_map&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"start_date\":\"\(start)\",\"end_date\":\"\(end)\",\"author\":\"Natasha\"}"
//        } else {
//            type = "Permanent"
//            
//            link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_map&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom!)\",\"type\": \"\(type!)\",\"author\":\"Natasha\"}"
//        }
//    
//        link = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        
//        
//        
//        Alamofire.request(link).responseJSON { response in
//            let id = JSON(response.result.value!)
//            self.mapToPass?.id = id.intValue
//        }
//    }
    
    @IBAction func addSpotsButtonClicked(_ sender: AnyObject) {
        if (nameTextBox.text?.isEmpty == true || (startDateTextField.text?.isEmpty == true && type == Map.mapType.temporary) || (endDateTextField.text?.isEmpty == true && type == Map.mapType.temporary)) {
            
            var emptyFields = [String]()
            if (nameTextBox.text?.isEmpty == true) {
                emptyFields.append("a name of the map")
            }
            
            if type == Map.mapType.temporary {
                if (startDateTextField.text?.isEmpty == true) {
                    emptyFields.append("start date of the event")
                }
                if (endDateTextField.text?.isEmpty == true) {
                    emptyFields.append("end date of the event")
                }
            }
            var message = "Please enter "
            if (emptyFields.count > 1) {
                for i in 0...(emptyFields.count - 2) {
                    message += emptyFields[i] + ", "
                }
            }
            
            message += emptyFields.last!
            
            CommonMethods.sharedInstance.showAlert(self, title: "Empty fields", message: message)

        } else if (startDate != nil && startDate!.isGreaterThanDate(endDate!)) {
                CommonMethods.sharedInstance.showAlert(self, title: "Incorrect time period", message: "Start date should be earlier than end")
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            if (type == Map.mapType.permanent) {
                mapToPass = Map(name: name, descr: descr, type: Map.mapType.permanent)
            } else {
                mapToPass = Map(name: name, descr: descr, type: Map.mapType.temporary)
                mapToPass!.startDate = startDate!
                mapToPass!.endDate = endDate!
            }

            mapToPass?.place = selectedPlace
            mapToPass?.coordinate = selectedPlace?.coordinate
            
            if let image = image {
                changeImage(mapToPass!, image: image) //mapToPass?.images.append(image)
            }
            
            //postMap(mapToPass!)
            
            performSegue(withIdentifier: "addMapToMapSegue", sender: nil)
        }
    }
    
    func changeImage(_ map: Map, image: UIImage) {
        if map.images.isEmpty {
            map.images.append(image)
        } else {
            map.images[0] = image
        }
    }
    
    func settingForTemporaryMap() {
        startDateTextField.isHidden = false
        endDateTextField.isHidden = false
        addSpotsButtonConstraint.constant = 88
        saveButtonConstraint.constant = 88
    
    }
    
    @IBAction func mapTypeValueChanged(_ sender: AnyObject) {
        switch mapTypeSegmentedControl.selectedSegmentIndex
        {
            case 0:
                type = Map.mapType.permanent
                startDateTextField.isHidden = true
                endDateTextField.isHidden = true
                datePicker.isHidden = true
                addSpotsButtonConstraint.constant = 16
                saveButtonConstraint.constant = 16
            case 1:
                type = Map.mapType.temporary
                settingForTemporaryMap()
            default:
                break;
        }
    }
    
    func showSelectedDate(_ textField: UITextField) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        if (date == "start") {
            startDate = datePicker.date
        } else {
            endDate = datePicker.date
        }
        textField.text = dateFormatter.string(from: datePicker.date)
    }
    
    var date = "start"
    
    var startDate: Date?
    var endDate: Date?
    
    @IBAction func datePickerValueChanged(_ sender: AnyObject) {
        if (date == "start") {
            showSelectedDate(startDateTextField)
        } else {
            showSelectedDate(endDateTextField)
        }
    }
    
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBAction func addPhotosButtonClicked(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MapViewController {
            //if let image = image {
            //    mapToPass!.images.append(image)
            //}
            controller.map = mapToPass
            controller.title = nameTextBox.text
            controller.shouldAddCreateButton = true
        } 
    }
}



extension AddMapViewController: UITextFieldDelegate {
    //когда нажали return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //надо ли начать редактировать
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == startDateTextField {
            datePicker.isHidden = false
            addSpotsButtonConstraint.constant = 296
            saveButtonConstraint.constant = 296
            date = "start"
            if startDate == nil {
                showSelectedDate(startDateTextField)
            } else {
                datePicker.setDate(startDate!, animated: true)
            }
            dismissItems()
            return false
        } else if textField == endDateTextField {
            datePicker.isHidden = false
            addSpotsButtonConstraint.constant = 296
            saveButtonConstraint.constant = 296
            date = "end"
            if endDate == nil {
                showSelectedDate(endDateTextField)
            } else {
                datePicker.setDate(endDate!, animated: true)
            }
            dismissItems()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == nameTextBox || textField == descriptionTextBox || textField == placeTextField) {
            datePicker.isHidden = true
            if (type == Map.mapType.permanent) {
                addSpotsButtonConstraint.constant = 16
                saveButtonConstraint.constant = 16
            } else {
                addSpotsButtonConstraint.constant = 88
                saveButtonConstraint.constant = 88
            }
        }
    }
    
}

extension AddMapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
        didAutocompleteWith place: GMSPlace) {
            selectedPlace = place
            placeTextField.text = selectedPlace?.name
            hideSearchBar()
    }
    
    func hideSearchBar() {
        searchController?.isActive = false
        searchBarConstraint.constant = 0
        nameConstraint.constant = 16
        for view in searchBarHolderView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
        didFailAutocompleteWithError error: Error){
            print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension AddMapViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideSearchBar()
    }
}

extension AddMapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            if let map = mapToPass {
                changeImage(map, image: image!) 
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
