//
//  NotificationService.swift
//  SmartechNSE
//
//  Created by Ramakrishna Kasuba on 08/12/22.
//

import UserNotifications
import SmartPush
import UIKit

class NotificationService: UNNotificationServiceExtension {
  
  let smartechServiceExtension = SMTNotificationServiceExtension()
    
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    //...
      
     
      if SmartPush.sharedInstance().isNotification(fromSmartech: request.content.userInfo){

      NSLog("SMTL-APP - NSE CALLED")
          smartechServiceExtension.didReceive(request, withContentHandler: contentHandler)
        }
    //...
  }
  
  override func serviceExtensionTimeWillExpire() {
    //...
    smartechServiceExtension.serviceExtensionTimeWillExpire()
    //...
  }
}

