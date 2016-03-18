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
    @IBOutlet weak var descriptionConstraint: NSLayoutConstraint!
    
    var map: Map?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = map!.name
        
        if let eventMap = map as? EventMap {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let period = dateFormatter.stringFromDate(eventMap.startDate) + " - " + dateFormatter.stringFromDate(eventMap.endDate)
            periodLabel.text = period
        } else {
            descriptionConstraint.constant = 24
            periodLabel.hidden = true
        }
        
        labelMapDescription.text = map!.descr
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
