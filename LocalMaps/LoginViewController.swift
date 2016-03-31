//
//  LoginViewController.swift
//  LocalMaps
//
//  Created by Natalia Nikitina on 11/02/16.
//  Copyright © 2016 Natalia Nikitina. All rights reserved.
//

import UIKit
import Alamofire

let userSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

class LoginViewController: UIViewController {

    @IBOutlet weak var buttonLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func fetch() {
        let url = NSURL(string: "http://maps-staging.sandbox.daturum.ru/maps/views/6-get-test.json")!
        
        let task = userSession.dataTaskWithURL(url) {
            data, response, error in
            
            let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! [String: AnyObject]
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                let message = json["test"] as! String
                print(message)
            })
            
        }
        task.resume()
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        //fetch()
//        Alamofire.request(.GET, "http://maps-staging.sandbox.daturum.ru/maps/views/6-get-test.json")
//            .responseJSON { response in
//                
//            if let json = response.result.value {
//                let message = json["test"] as! String
//                print(message)
//            }
//        }
//        
//        // POST Request with JSON-encoded Parameters
//        
//        
//        let parameters = [
//            "foo": [1,2,3],
//            "bar": [
//                "baz": "qux"
//            ]
//        ]
//        
//        Alamofire.request(.POST, "https://httpbin.org/post", parameters: parameters, encoding: .JSON)
        // HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? MapListViewController {
            User.currentUser = User(name: "user2", password: "blabla")
            //вот тут я должна по логину чувака подтягивать его конкретно
            controller.shouldAddAddButton = true
        }
    }

}
