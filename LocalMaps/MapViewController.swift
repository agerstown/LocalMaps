//
//  MapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var startDate: NSDate?
    var endDate: NSDate?
    
    var detailsView: UIView?
    var map: Map?
    var markerToSpotDictionary = [GMSMarker: Spot]()
    
    var mode: String?
    
    enum userMode {
        case edit
        case create
        case look
    }
    
    var currentMode = userMode.look
    var currentMarker: GMSMarker?
    
    let locationManager = CLLocationManager()
    
    var shouldAddCreateButton: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "create" {
            currentMode = userMode.create
        } else if let name = User.currentUser?.name {
            if name != "user1" {
                currentMode = userMode.edit
            }
        }
        
        addMarkers()
        locateMap()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if shouldAddCreateButton == true {
            let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "createMapButtonClicked:")
            self.navigationItem.rightBarButtonItem = createButton
        }
    }
    
    func createMapButtonClicked(sender: UIBarButtonItem) {
        map?.coordinate = (mapView?.camera.target)!
        map?.zoom = (mapView?.camera.zoom)!
        
        if let map = map as? EventMap {
            User.currentUser?.temporaryMapsList.append(map)
        } else {
            User.currentUser?.permanentMapsList.append(map!)
        }
        
        performSegueWithIdentifier("mapToAllMapsSegue", sender: sender)
    }
    
    func addMarkers() {
        if (map?.spotList)?.isEmpty == false {
            for spot in (map?.spotList)! {
                let marker = GMSMarker(position: spot.coordinate)
                marker?.title = spot.name
                marker?.snippet = spot.descr
                marker?.map = mapView
                marker?.draggable = true
                markerToSpotDictionary[marker] = spot
            }
        }
    }
    
    func locateMap() {
        if let coordinate = map?.coordinate {
            var position: GMSCameraPosition?
            if let zoom = map?.zoom {
                position = GMSCameraPosition(target: coordinate, zoom: zoom, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.viewingAngle)
            } else {
                position = GMSCameraPosition(target: coordinate, zoom: 15, bearing: mapView.camera.bearing, viewingAngle: mapView.camera.viewingAngle)
            }
            mapView.camera = position
        }
    }
    
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D) {
        if currentMode == userMode.edit || currentMode == userMode.create {
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
        } else if let controller = segue.destinationViewController as? MapListViewController {
            controller.shouldAddAddButton = true
        }
    }
    
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if currentMode == userMode.create && status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
}
