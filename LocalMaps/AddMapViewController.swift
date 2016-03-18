//
//  AddMapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 2/24/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

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
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    let pickerData = ["Permanent","Temporary"]
    
    var selectedPlace: GMSPlace?
    
    var mapToPass: Map?
    
    var doesReallyEdit = true
    
    let commonMethods = CommonMethodsForCotrollers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        placeTextField.delegate = self
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissItems")
        view.addGestureRecognizer(tap)
        
        if let place = selectedPlace {
            placeTextField.text = place.name
            doesReallyEdit = true
        }
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }
    
    var type = "permanent"
    
    
    @IBAction func placeTextFieldEditingDidBegin(sender: AnyObject) {
        if doesReallyEdit == true {
            resultsViewController = GMSAutocompleteResultsViewController()
            resultsViewController?.delegate = self
            
            searchController = UISearchController(searchResultsController: resultsViewController)
            searchController?.searchResultsUpdater = resultsViewController
            
            let searchBar = (searchController?.searchBar)!
            searchBarConstraint.constant = 44.0
            searchBarHolderView.addSubview(searchBar)
            
            searchBar.delegate = self
            
            searchBar.placeholder = "Place"
            searchController?.hidesNavigationBarDuringPresentation = true
            
            // When UISearchController presents the results view, present it in
            // this view controller, not one further up the chain.
            self.definesPresentationContext = true

            searchBar.becomeFirstResponder()
        }
    }
    
    @IBAction func addSpotsButtonClicked(sender: AnyObject) {
        if (nameTextBox.text?.isEmpty == true || (startDateTextField.text?.isEmpty == true && type == "temporary") || (endDateTextField.text?.isEmpty == true && type == "temporary")) {
            
            var emptyFields = [String]()
            if (nameTextBox.text?.isEmpty == true) {
                emptyFields.append("a name of the map")
            }
            
            if type == "temporary" {
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
            
            commonMethods.showAlert(self, title: "Empty fields", message: message)

        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            if (type == "permanent") {
                mapToPass = Map(name: name, descr: descr)
            } else {
                mapToPass = EventMap(name: name, descr: descr, startDate: startDate!, endDate: endDate!)
            }

            mapToPass?.coordinate = selectedPlace?.coordinate
        }
    }
    
    @IBAction func mapTypeValueChanged(sender: AnyObject) {
        switch mapTypeSegmentedControl.selectedSegmentIndex
        {
            case 0:
                type = "permanent"
                startDateTextField.hidden = true
                endDateTextField.hidden = true
                addSpotsButtonConstraint.constant = 16
            case 1:
                type = "temporary"
                startDateTextField.hidden = false
                endDateTextField.hidden = false
                addSpotsButtonConstraint.constant = 88
            default:
                break;
        }
    }
    
    func showSelectedDate(textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        textField.text = dateFormatter.stringFromDate(datePicker.date)
        if (date == "start") {
            startDate = datePicker.date
        } else {
            endDate = datePicker.date
        }
    }
    
    var date = "start"
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    @IBAction func datePickerValueChanged(sender: AnyObject) {
        if (date == "start") {
            showSelectedDate(startDateTextField)
        } else {
            showSelectedDate(endDateTextField)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? MapViewController {
            controller.mode = "create"
            controller.map = mapToPass
            controller.title = nameTextBox.text
            controller.shouldAddCreateButton = true
        } 
    }
}

extension AddMapViewController: UITextFieldDelegate {
    //когда нажали return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //надо ли начать редактировать
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == startDateTextField {
            datePicker.hidden = false
            addSpotsButtonConstraint.constant = 296
            date = "start"
            if startDate == nil {
                showSelectedDate(startDateTextField)
            } else {
                datePicker.setDate(startDate!, animated: true)
            }
            dismissItems()
            return false
        } else if textField == endDateTextField {
            datePicker.hidden = false
            addSpotsButtonConstraint.constant = 296
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == nameTextBox || textField == descriptionTextBox || textField == placeTextField) {
            datePicker.hidden = true
            if (type == "permanent") {
                addSpotsButtonConstraint.constant = 16
            } else {
                addSpotsButtonConstraint.constant = 88
            }
        }
    }
    
}

extension AddMapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
        didAutocompleteWithPlace place: GMSPlace) {
            selectedPlace = place
            placeTextField.text = selectedPlace?.name
            hideSearchBar()
    }
    
    func hideSearchBar() {
        searchController?.active = false
        searchBarConstraint.constant = 0
        for view in searchBarHolderView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
        didFailAutocompleteWithError error: NSError){
            print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

extension AddMapViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        hideSearchBar()
    }
}
