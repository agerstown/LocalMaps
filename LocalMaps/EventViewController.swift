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
    
    var spot: Spot?
    var currentEvent: Event?
    
    var time = "start"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameTextField.delegate = self
        startTimeTextField.delegate = self
        endTimeTextField.delegate = self
        
        loadEventData(currentEvent)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EventViewController.dismissItems))
        view.addGestureRecognizer(tap)
    }

    func loadEventData(selectedEvent: Event?) {
        if let event = selectedEvent {
            eventNameTextField.text = event.name
            formatAndSetDateToTextField(event.startTime!, textField: startTimeTextField)
            formatAndSetDateToTextField(event.endTime!, textField: endTimeTextField)
            
            addEventButton.setTitle("Save", forState: UIControlState.Normal)
            self.title = "Edit event"
        }
    }
    
    func dismissItems() {
        self.view.endEditing(true)
    }

    func formatAndSetDateToTextField(date: NSDate, textField: UITextField) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        textField.text = dateFormatter.stringFromDate(date)
    }
    
    func showSelectedTime(textField: UITextField) {
        formatAndSetDateToTextField(timePicker.date, textField: textField)
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
            
            CommonMethods.sharedInstance.showAlert(self, title: "Empty fields", message: message)
        } else if (startTime != nil && startTime!.isGreaterThanDate(endTime!)) {
                CommonMethods.sharedInstance.showAlert(self, title: "Incorrect time period", message: "Start time should be earlier than end")
        } else {
            let name = eventNameTextField.text
            if currentEvent == nil {
                currentEvent = Event(name: name!, startTime: startTime!, endTime: endTime!)
                spot!.eventList.append(currentEvent!)
            } else {
                if let start = startTime {
                    currentEvent!.startTime = start
                }
                if let end = endTime {
                    currentEvent!.endTime = end
                }
            }
            
            navigationController?.popViewControllerAnimated(true)
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
