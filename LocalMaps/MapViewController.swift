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
    
    var canEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = user?.name {
            if name != "user1" {
                canEdit = true
            }
        }
        mapView.delegate = self
    }

    var currentMarker: GMSMarker?
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if canEdit == true {
            currentMarker = GMSMarker(position: coordinate)
            performSegueWithIdentifier("mapViewToAddSpotSegue", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? AddSpotViewController {
            controller.marker = currentMarker
            controller.mapView = mapView
        }
    }

    
}