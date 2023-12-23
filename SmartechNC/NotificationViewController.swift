//
//  NotificationViewController.swift
//  SmartechNC
//
//  Created by Ramakrishna Kasuba on 02/03/23.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SmartPush

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var customBgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SmartPush.sharedInstance().loadCustomNotificationContentView(customBgView)
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        SmartPush.sharedInstance().didReceiveCustomNotification(notification)
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        SmartPush.sharedInstance().didReceiveCustomNotificationResponse(response) { (option) in
            completion(option)
        }
    }
}
