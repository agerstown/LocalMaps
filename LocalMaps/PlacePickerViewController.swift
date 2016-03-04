//
//  PlacePickerViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 2/29/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class PlacePickerViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    //var resultView: UITextView?
    
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? AddMapViewController {
            controller.selectedPlace = selectedPlace
            controller.doesReallyEdit = false
        }
    }

}



