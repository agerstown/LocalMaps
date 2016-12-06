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
        autocompleteTableView.isScrollEnabled = true;
        autocompleteTableView.tableFooterView = UIView()
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
            let createButton = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MapViewController.createMapButtonClicked(_:)))
            self.navigationItem.rightBarButtonItem = createButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addMarkers()
        locateMap()
    }
    
    func createMapButtonClicked(_ sender: UIBarButtonItem) {
        map?.coordinate = (mapView?.camera.target)!
        User.currentUser?.maps.append(map!)
        performSegue(withIdentifier: "mapToAllMapsSegue", sender: sender)
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
                marker.title = spot.name
                marker.snippet = spot.descr
                marker.map = mapView
                marker.isDraggable = true
                
                marker.icon = UIImage(named: "\(spot.type)_pin")
                
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
            mapView.camera = position!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SpotViewController {
            map?.coordinate = (mapView?.camera.target)!
            map?.zoom = (mapView?.camera.zoom)!
            //CommonMethods.sharedInstance.updateMap(map!)
            
            controller.marker = currentMarker
            controller.currentSpot = markerToSpotDictionary[currentMarker!]
            controller.mapView = mapView
            controller.map = map
            controller.mapViewController = self
        }
    }
    
}

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapSearchBar.resignFirstResponder()
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        currentMarker = GMSMarker(position: coordinate)
        performSegue(withIdentifier: "mapViewToAddSpotSegue", sender: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        for (markerDict, spotDict) in markerToSpotDictionary where markerDict == marker {
            spotDict.coordinate = marker.position
            //CommonMethods.sharedInstance.updateSpot(spotDict, map: map!)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        currentMarker = marker
        performSegue(withIdentifier: "mapViewToAddSpotSegue", sender: marker)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        map?.coordinate = position.target
        map?.zoom = position.zoom
        //CommonMethods.sharedInstance.updateMap(map!)
    }

}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        autocompleteTableHolder.isHidden = false
        searchAutocompleteEntriesWithSubstring("")
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //autocompleteTableHolder.hidden = false
        let substring = (searchBar.text! as NSString).replacingCharacters(in: range, with: text)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mapSearchBar.text = ""
        mapSearchBar.resignFirstResponder()
        autocompleteTableHolder.isHidden = true
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    func searchAutocompleteEntriesWithSubstring(_ substring: String)
    {
        autocompleteSpotNames.removeAll(keepingCapacity: false)
        
        for spotName in spotNames
        {
            let name: NSString! = spotName as NSString
            let substringRange: NSRange! = name.range(of: substring, options: [.caseInsensitive])
            if (substringRange.location  == 0 || substring == "") {
                autocompleteSpotNames.append(spotName)
            }
        }
        
        autocompleteTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteSpotNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AutoCompleteRowIdentifier"
        let cell = UITableViewCell(style: UITableViewCellStyle.default , reuseIdentifier: cellIdentifier)
        let index = indexPath.row as Int
        cell.textLabel!.text = autocompleteSpotNames[index]
        return cell
    }
    
    func allKeysForValue<K, V : Equatable>(_ dict: [K : V], val: V) -> [K] {
        return dict.filter{ $0.1 == val }.map{ $0.0 }
    }
    
    func getSelectedSpotByName(_ name: String) {
        var selectedSpot: Spot?
        for spot in (map?.spotList)! {
            if (spot.name == name) {
                selectedSpot = spot
                break
            }
        }
        let markers = allKeysForValue(markerToSpotDictionary, val: selectedSpot!)
        mapView.selectedMarker = markers[0]
        let position = GMSCameraPosition.camera(withLatitude: selectedSpot!.coordinate.latitude, longitude: selectedSpot!.coordinate.longitude, zoom: 17)
        mapView.animate(to: position)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRow(at: indexPath)!
        let spotName = selectedCell.textLabel!.text
        mapSearchBar.text = spotName
        getSelectedSpotByName(spotName!)
        autocompleteTableHolder.isHidden = true
        mapSearchBar.text = nil
        mapSearchBar.resignFirstResponder()
        
        //убрать выделение ячейки
        autocompleteTableView.deselectRow(at: indexPath, animated: true)
    }
}
