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
    
    let pickerData = ["Permanent","Temporary"]
    
    var mapToPass: Map?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapTypePicker.delegate = self
        mapTypePicker.dataSource = self
        
        nameTextBox.delegate = self
        descriptionTextBox.delegate = self
        placeTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func placeTextFieldEditingDidBegin(sender: AnyObject) {
        
    }
    
    var type = mapType.permanent
    
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
