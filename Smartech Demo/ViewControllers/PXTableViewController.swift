//
//  PXTableViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 20/12/22.
//

import UIKit
import Smartech

class PXViewController: UITableViewController {
    
//    let feature: FeatureVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func multipleChoice(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"MCQ"])
    }
    
    @IBAction func feedback(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"feedback"])
    }
    @IBAction func beaconCTA(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"beacon with CTA"])
    }
    @IBAction func tooltipCTA(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"tooltip with CTA"])
    }
    
    @IBAction func welcomeNudgeCTA(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"welcome with CTA"])
    }
    
    @IBAction func spotlightCTA(_ sender: Any) {
        Smartech.sharedInstance().trackEvent("Nudge test", andPayload: ["type":"spotlight with CTA"])
    }
    
    @IBAction func featureManagement(_ sender: UIButton) {
       
//        let vc = storyboard?.instantiateViewController(withIdentifier: "featureVC") as FeatureVC
    }
    
    
   
}
