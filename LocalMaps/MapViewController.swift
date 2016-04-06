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

class MapViewController: UIViewController {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var autocompleteTableHolder: UIView!
    
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
    
    let autocompleteTableView = UITableView()
    var autocompleteSpotNames = [String]()
    
    var spotNames: [String] {
        get {
            var names = [String]()
            for spot in (map?.spotList)! {
                names.append(spot.name)
            }
            return names
        }
    }
    
    func addAutocompleteForSearchBar() {
        mapSearchBar.delegate = self
        autocompleteTableView.delegate = self;
        autocompleteTableView.dataSource = self;
        autocompleteTableView.scrollEnabled = true;
        let x = autocompleteTableHolder.frame.origin.x
        let y = autocompleteTableHolder.frame.origin.y
        let width = autocompleteTableHolder.frame.width
        let height = autocompleteTableHolder.frame.height
        autocompleteTableView.frame = CGRect(x: x, y: y - 104, width: width, height: height)
        autocompleteTableHolder.addSubview(autocompleteTableView)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAutocompleteForSearchBar()
        
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

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        mapSearchBar.resignFirstResponder()
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
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if currentMode == userMode.create && status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        autocompleteTableHolder.hidden = false
        let substring = (searchBar.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        mapSearchBar.resignFirstResponder()
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocompleteSpotNames.removeAll(keepCapacity: false)
        
        for spotName in spotNames
        {
            let name: NSString! = spotName as NSString
            let substringRange: NSRange! = name.rangeOfString(substring, options: [.CaseInsensitiveSearch])
            if (substringRange.location  == 0) {
                autocompleteSpotNames.append(spotName)
            }
        }
        
        autocompleteTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteSpotNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AutoCompleteRowIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: cellIdentifier)
        let index = indexPath.row as Int
        cell.textLabel!.text = autocompleteSpotNames[index]
        return cell
    }
    
    func allKeysForValue<K, V : Equatable>(dict: [K : V], val: V) -> [K] {
        return dict.filter{ $0.1 == val }.map{ $0.0 }
    }
    
    func getSelectedSpotByName(name: String) {
        var selectedSpot: Spot?
        for spot in (map?.spotList)! {
            if (spot.name == name) {
                selectedSpot = spot
                break
            }
        }
        let markers = allKeysForValue(markerToSpotDictionary, val: selectedSpot!)
        mapView.selectedMarker = markers[0]
        let position = GMSCameraPosition.cameraWithLatitude(selectedSpot!.coordinate.latitude, longitude: selectedSpot!.coordinate.longitude, zoom: map!.zoom!)
        mapView.animateToCameraPosition(position)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let spotName = selectedCell.textLabel!.text
        mapSearchBar.text = spotName
        getSelectedSpotByName(spotName!)
        autocompleteTableHolder.hidden = true
        mapSearchBar.text = nil
        mapSearchBar.resignFirstResponder()
        
        //убрать выделение ячейки
        autocompleteTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
