//
//  NotificationViewController.swift
//  SmartechNC
//
//  Created by Ramakrishna Kasuba on 02/03/23.
//

import UIKit
import SmartPush

class NotificationViewController: SMTCustomNotificationViewController {
    
    @IBOutlet var customPNView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView = customPNView
    }
}


