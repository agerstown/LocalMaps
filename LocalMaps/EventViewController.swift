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
    
    let commonMethods = CommonMethodsForCotrollers()
    
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
        
        if (eventNameTextField.text?.isEmpty == true || startTimeTextField.text?.isEmpty == true || endTimeTextField.text?.isEmpty == true) {
            
            var emptyFields = [String]()
            if (eventNameTextField.text?.isEmpty == true) {
                emptyFields.append("a name of the event")
            }
            if (startTimeTextField.text?.isEmpty == true) {
                emptyFields.append("start time of the event")
            }
            if (endTimeTextField.text?.isEmpty == true) {
                emptyFields.append("end time of the event")
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
            //let name = eventNameTextField.text
            
        }
    }
}

extension EventViewController: UITextFieldDelegate {
    
    //когда нажали return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //надо ли начать редактировать
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == startTimeTextField {
            timePicker.hidden = false
            addButtonConstraint.constant = 240
            time = "start"
            if startTime == nil {
                showSelectedTime(startTimeTextField)
            } else {
                timePicker.setDate(startTime!, animated: true)
            }
            dismissItems()
            return false
        } else if textField == endTimeTextField {
            timePicker.hidden = false
            addButtonConstraint.constant = 240
            time = "end"
            if endTime == nil {
                showSelectedTime(endTimeTextField)
            } else {
                timePicker.setDate(endTime!, animated: true)
            }
            dismissItems()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == eventNameTextField) {
            timePicker.hidden = true
            addButtonConstraint.constant = 8
        }
    }
    
}
