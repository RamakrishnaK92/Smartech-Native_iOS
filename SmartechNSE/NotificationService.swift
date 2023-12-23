//
//  NotificationService.swift
//  SmartechNSE
//
//  Created by Ramakrishna Kasuba on 08/12/22.
//

import UserNotifications
import SmartPush

class NotificationService: UNNotificationServiceExtension {
  
  let smartechServiceExtension = SMTNotificationServiceExtension()
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    //...
  if SmartPush.sharedInstance().isNotification(fromSmartech:request.content.userInfo){
      
      NSLog("SMT - NSE CALLED", request.content.userInfo)
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
