//
//  MapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
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
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if shouldAddCreateButton == true {
            let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MapViewController.createMapButtonClicked(_:)))
            self.navigationItem.rightBarButtonItem = createButton
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if mode == "create" {
            currentMode = userMode.create
        } else if let name = User.currentUser?.name {
            if name != "user1" {
                currentMode = userMode.edit
            }
        }
        
        addMarkers()
        locateMap()
    }
    
//    func postMap(map: Map) {
//        let name = map.name
//        let descr = map.descr
//        let long = map.coordinate!.longitude
//        let lat = map.coordinate!.latitude
//        let zoom = (map.zoom)!
//        
//        var type: String?
//        if map.type == Map.mapType.temporary {
//            type = "Temporary"
//        } else {
//            type = "Permanent"
//        }
//        
//        var link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_map&data={\"name\":\"\(name)\",\"description\":\"\(descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\(zoom)\",\"type\": \"\(type!)\",\"author\":\"Natasha\"}"
//        link = link.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())!
//        
//        //todo дату еще добавить
//        
//        Alamofire.request(.GET, link) .responseJSON { response in
//            let id = JSON(response.result.value!)
//            self.map?.id = id.intValue
//        }
//    }
    
    func createMapButtonClicked(sender: UIBarButtonItem) {
        map?.coordinate = (mapView?.camera.target)!
        //todo ???  map?.zoom = (mapView?.camera.zoom)!
        User.currentUser?.maps.append(map!)
        
        //postMap(map!)
        
        performSegueWithIdentifier("mapToAllMapsSegue", sender: sender)
    }
    
    func removeAllSpots() {
        for marker in markerToSpotDictionary.keys {
            marker.map = nil
        }
        markerToSpotDictionary.removeAll()
    }
    
    func addMarkers() {
        removeAllSpots()
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
            controller.currentSpot = markerToSpotDictionary[currentMarker!]
            controller.mapView = mapView
            controller.map = map
            controller.mapViewController = self
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
