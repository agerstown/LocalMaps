//
//  MapItemViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 07/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapItemViewController: UIViewController {
    
    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var labelMapDescription: UILabel!
    @IBOutlet weak var buttonMap: UIBarButtonItem!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    var map: Map?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = map!.name
        
        if map?.type == Map.mapType.temporary { 
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeStyle = DateFormatter.Style.short
            let period = dateFormatter.string(from: (map?.startDate!)! as Date) + " - " + dateFormatter.string(from: (map?.endDate!)! as Date)
            periodLabel.text = period
        } else {
            imageViewConstraint.constant = 122
            periodLabel.isHidden = true
        }
        
        labelMapDescription.text = map!.descr
        
        if map?.id == 1 {
            map?.images.append((UIImage(named: "hse_day"))!)
        } else if map?.id == 2 {
            map?.images.append((UIImage(named: "sokolniki"))!)
        }
        
        if map!.images.count != 0 {
            imageViewMap.image = map!.images[0]
        }
    }
    
    @IBAction func mapButtonClicked(_ sender: AnyObject) {
        getSpots(map!)
        performSegue(withIdentifier: "MapItemToMapSegue", sender: nil)
    }
    
    func getSpots(_ map: Map) {
        
        map.spotList.removeAll()
        
        let coord1 = CLLocationCoordinate2D(latitude: 55.729730, longitude: 37.601215)
        let spot1 = Spot(name: "Кафе", descr: "Здесь можно вкусно покушать", coordinate: coord1)
        spot1.type = "Dining"
        map.spotList.append(spot1)
        
        let coord2 = CLLocationCoordinate2D(latitude: 55.729358, longitude: 37.605801)
        let spot2 = Spot(name: "Лекторий", descr: "Здесь можно послушать разные выступления", coordinate: coord2)
        spot2.type = "Star"
        spot2.id = 1
        map.spotList.append(spot2)
        
        let coord3 = CLLocationCoordinate2D(latitude: 55.729582, longitude: 37.597593)
        let spot3 = Spot(name: "Прокат", descr: "Здесь можно взять велосипед, самокат или скейт напрокат", coordinate: coord3)
        spot3.type = "Bike"
        map.spotList.append(spot3)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         self.title = "Back"
        //куда мы направляемся
        if let controller = segue.destination as? MapViewController {
            controller.title = map!.name
            controller.map = map
        } else if let controller = segue.destination as? AddMapViewController {
            controller.mapToPass = map
        }
    }

}
