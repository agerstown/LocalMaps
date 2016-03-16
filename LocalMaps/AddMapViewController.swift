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
        if nameTextBox.text?.isEmpty == true {
            let emptyNameFieldAlertController = UIAlertController(title: "Empty name field", message: "Please enter a name of the map", preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
            emptyNameFieldAlertController.addAction(OKAction)
            self.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
            
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
                addSpotsButtonConstraint.constant = 8
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
            controller.startDate = startDate
            controller.endDate = endDate
            controller.title = nameTextBox.text
            controller.shouldAddCreateButton = true
        } 
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AddMapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func startDateEditingDidBegin(sender: AnyObject) {
        datePicker.hidden = false
        addSpotsButtonConstraint.constant = 296
        date = "start"
        showSelectedDate(startDateTextField)
        dismissItems()
    }
    
    @IBAction func endDateEditingDidBegin(sender: AnyObject) {
        datePicker.hidden = false
        addSpotsButtonConstraint.constant = 296
        date = "end"
        showSelectedDate(endDateTextField)
        dismissItems()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == nameTextBox || textField == descriptionTextBox || textField == placeTextField) {
            datePicker.hidden = true
            addSpotsButtonConstraint.constant = 88
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
