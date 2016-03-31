//
//  MapViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire

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
            let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.Plain, target: self, action: "createMapButtonClicked:")
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
    
    func createMapButtonClicked(sender: UIBarButtonItem) {
        map?.coordinate = (mapView?.camera.target)!
        
        map?.zoom = (mapView?.camera.zoom)!
        
        var type: String?
        if map?.type == Map.mapType.temporary {
            User.currentUser?.temporaryMapsList.append(map!)
            type = "Temporary"
        } else {
            User.currentUser?.permanentMapsList.append(map!)
            type = "Permanent"
        }
        
        let long = map!.coordinate!.longitude
        let lat = map!.coordinate!.latitude
        
        let link = "http://maps-staging.sandbox.daturum.ru/maps/views/11-items.html?method=add_map&data={\"name\":\"\(map!.name)\",\"description\":\"\(map!.descr)\",\"longitude\":\"\(long)\",\"latitude\":\"\(lat)\",\"zoom\": \"\((map!.zoom)!)\",\"type\": \"\(type!)\",\"author\":\"Natasha\"}"
        
//        let parameters = [
//            "name": map!.name,
//            "description" : map!.descr,
//            "longitude" : String(map!.coordinate?.longitude),
//            "latitude" : String(map!.coordinate?.latitude),
//            "zoom" : String(map!.zoom),
//            "type" : type!,
//            "author" : "Natasha"
//        ]
        
        print(link)
        
        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/views/6-get-test.json") //link
            .responseJSON { response in
//                
//                if let json = response.result.value {
//                    let message = json["test"] as! String
//                    print(message)
//                }
        }
        
//        data={ "name": "Тестовая карта",
//            "description": "Test Map, Test Map, Test Map",
//            "longitude": "34.12313",
//            "latitude": "12.14123",
//            "zoom": "10",
//            "type": "Permanent",
//            "author": "Andru" }
        
        //Alamofire.request(.POST, "http://maps.sandbox.daturum.ru/maps/views/11-items.html?method=add_map&data=", parameters: parameters).responseJSON { response in
        //    print("Response JSON: \(response.result.value)")
        //}
        // HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}

        
        performSegueWithIdentifier("mapToAllMapsSegue", sender: sender)
    }
    
    func addMarkers() {
        print(map)
        print(map?.spotList.count)
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
//            
//            if let marker = sender as? GMSMarker {
//                controller.name = marker.title
//                controller.descr = marker.snippet
//            }
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
