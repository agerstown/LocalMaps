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
    @IBOutlet weak var mapTypePicker: UIPickerView!
    @IBOutlet weak var addSpotsButton: UIButton!
    @IBOutlet var tapGestureRecogniser: UITapGestureRecognizer!
    @IBOutlet weak var searchBarHolderView: UIView!
    @IBOutlet weak var searchBarConstraint: NSLayoutConstraint!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    
    let pickerData = ["Permanent","Temporary"]
    
    var selectedPlace: GMSPlace?
    
    var mapToPass: Map?
    
    var doesReallyEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapTypePicker.delegate = self
        mapTypePicker.dataSource = self
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        placeTextField.delegate = self
        
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
    
    var type = mapType.permanent
    
    
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
            self.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
            emptyNameFieldAlertController.addAction(OKAction)
            
        } else {
            let name = nameTextBox.text!
            let descr = descriptionTextBox.text!
            mapToPass = Map(name: name, descr: descr, type: type)
//            mapToPass?.northEastCoordinate = selectedPlace?.viewport.northEast
//            mapToPass?.southWestCoordinate = selectedPlace?.viewport.southWest
            mapToPass?.coordinate = selectedPlace?.coordinate
           // mapToPass?.zoom
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

extension AddMapViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}

extension AddMapViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Permanent" {
            type = mapType.permanent
        } else {
            type = mapType.temporary
        }
    }
}

extension AddMapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
            // TODO: handle the error.
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
