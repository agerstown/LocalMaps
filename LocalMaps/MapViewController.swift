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
    
    var detailsView: UIView?
    var map: Map?
    var markerToSpotDictionary = [GMSMarker: Spot]()
    
    var canEdit = false
    var currentMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = User.currentUser?.name {
            if name != "user1" {
                canEdit = true
            }
        }
        mapView.delegate = self
        addMarkers()
    }

    func addMarkers() {
        for spot in (map?.spotList)! {
            let marker = GMSMarker(position: spot.coordinate)
            marker?.title = spot.name
            marker?.snippet = spot.descr
            marker?.map = mapView
            marker?.draggable = true
            markerToSpotDictionary[marker] = spot
        }
    }
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if canEdit == true {
            currentMarker = GMSMarker(position: coordinate)
            performSegueWithIdentifier("mapViewToAddSpotSegue", sender: nil)
        }
    }
    
    func mapView(mapView: GMSMapView!, didDragMarker marker: GMSMarker!) {
        for (markerDict, spotDict) in markerToSpotDictionary where markerDict == marker {
            spotDict.coordinate = marker.position
        }
        
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        currentMarker = marker
        performSegueWithIdentifier("mapViewToAddSpotSegue", sender: marker)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? SpotViewController {
            controller.marker = currentMarker
            controller.mapView = mapView
            controller.map = map
            controller.mapViewController = self
            
            if let marker = sender as? GMSMarker {
                controller.name = marker.title
                controller.descr = marker.snippet
            }
        }
    }

    
}