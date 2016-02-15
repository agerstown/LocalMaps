//
//  MapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var user: User?
    var detailsView: UIView?
    
    enum mode {
        case view
        case edit
    }
    
    var currentMode = mode.view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = user?.name {
            if name != "user1" {
                let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addSpot")
                
                self.navigationItem.rightBarButtonItem = addButton
            }
        }
        mapView.delegate = self
    }
    
    func addSpot() {
        currentMode = mode.edit
    }

    var currentMarker: GMSMarker?
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        if currentMode == mode.edit {
            currentMarker = GMSMarker(position: coordinate)
            performSegueWithIdentifier("mapViewToAddSpotSegue", sender: nil)
            currentMarker?.map = mapView
            currentMode = mode.view
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? AddSpotViewController {
            controller.marker = currentMarker
        }
    }

    
}