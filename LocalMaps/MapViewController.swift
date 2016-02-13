//
//  MapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var buttonDetails: UIButton!
    
    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self
        //locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}