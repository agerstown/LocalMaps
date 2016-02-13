//
//  MapItemViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 07/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit

class MapItemViewController: UIViewController {
    
    @IBOutlet weak var imageViewMap: UIImageView!
    @IBOutlet weak var labelMapDescription: UILabel!
    @IBOutlet weak var buttonMap: UIBarButtonItem!
    
    var map: Map?
    //var descr: String?
    //var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMapDescription.text = map!.descr //descr
        imageViewMap.image = map!.image // image
        //imageViewMap.backgroundColor = UIColor.blackColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapViewController {
            //if let map = sender as? Map {
                controller.title = map!.name
                //controller.mapView = map!.map
            //}
        }
    }

}
