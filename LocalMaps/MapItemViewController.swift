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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelMapDescription.text = map!.descr //descr
        //imageViewMap.image = map!.image // image
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapViewController {
            controller.title = map!.name
            controller.map = map
        }
    }

}
