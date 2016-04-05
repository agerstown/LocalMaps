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
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var labelMapDescription: UILabel!
    @IBOutlet weak var buttonMap: UIBarButtonItem!
    @IBOutlet weak var imageViewConstraint: NSLayoutConstraint!
    
    var map: Map?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        self.title = map!.name
        
        if map?.type == Map.mapType.temporary { 
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let period = dateFormatter.stringFromDate((map?.startDate!)!) + " - " + dateFormatter.stringFromDate((map?.endDate!)!)
            periodLabel.text = period
        } else {
            imageViewConstraint.constant = 64
            periodLabel.hidden = true
        }
        
        labelMapDescription.text = map!.descr
        if map!.images.count != 0 {
            imageViewMap.image = map!.images[0]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //куда мы направляемся
        if let controller = segue.destinationViewController as? MapViewController {
            controller.title = map!.name
            controller.map = map
        } else if let controller = segue.destinationViewController as? AddMapViewController {
            controller.mapToPass = map
        }
    }

}
