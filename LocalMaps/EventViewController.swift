//
//  EventViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 3/14/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var addButtonConstraint: NSLayoutConstraint!
    
    var time = "start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameTextField.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissItems")
        view.addGestureRecognizer(tap)
    }

    func dismissItems() {
        self.view.endEditing(true)
    }

    func showSelectedTime(textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        textField.text = dateFormatter.stringFromDate(timePicker.date)
        if (time == "start") {
            startTime = timePicker.date
        } else {
            endTime = timePicker.date
        }
    }
    
    var startTime: NSDate?
    var endTime: NSDate?
    
    @IBAction func timePickerValueChanged(sender: AnyObject) {
        if (time == "start") {
            showSelectedTime(startTimeTextField)
        } else {
            showSelectedTime(endTimeTextField)
        }
    }
    
    @IBAction func addEventButtonClicked(sender: AnyObject) {
        if eventNameTextField.text?.isEmpty == true {
            let emptyNameFieldAlertController = UIAlertController(title: "Empty name field", message: "Please enter a name of the event", preferredStyle: UIAlertControllerStyle.Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
            emptyNameFieldAlertController.addAction(OKAction)
            self.presentViewController(emptyNameFieldAlertController, animated: true, completion: nil)
            
        } else {
            let name = eventNameTextField.text
            
        }
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension EventViewController: UITextFieldDelegate {
    
    @IBAction func eventNameEditingDidBegin(sender: AnyObject) {
        timePicker.hidden = true
        addButtonConstraint.constant = 8
    }
    
    @IBAction func startTimeEditingDidBegin(sender: AnyObject) {
        timePicker.hidden = false
        addButtonConstraint.constant = 240
        time = "start"
        showSelectedTime(startTimeTextField)
        dismissItems()
    }
    
    @IBAction func endTimeEditingDidBegin(sender: AnyObject) {
        timePicker.hidden = false
        addButtonConstraint.constant = 240
        time = "end"
        showSelectedTime(endTimeTextField)
        dismissItems()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
