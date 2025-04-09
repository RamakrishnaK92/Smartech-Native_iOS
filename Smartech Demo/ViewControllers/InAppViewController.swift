//
//  InAppViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 19/12/22.
//

import UIKit
import Smartech

class InAppViewController: UITableViewController {
    
//    var featureMgmt: FeatureVC!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func textIAM(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("InApp Message test", andPayload: ["type":"simple"])
        
    }
    
    @IBAction func imageIAM(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("InApp Message test", andPayload: ["type":"image"])
    }
    
    @IBAction func customHtmlIAM(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("InApp Message test", andPayload: ["type":"custom Html"])
    }
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidAppear(_ animated: Bool) {
      //  Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current page":"InAppMessage"])
        Smartech.sharedInstance().trackEvent("Product Purchase", andPayload: ["amount": 500.00])
            
    }
}
