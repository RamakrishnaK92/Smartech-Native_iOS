//
//  NotificationService.swift
//  SmartechNSE
//
//  Created by Ramakrishna Kasuba on 08/12/22.

import UserNotifications
import SmartPush
import UIKit

class NotificationService: UNNotificationServiceExtension {
  
    let smartechServiceExtension = SMTNotificationServiceExtension()
  
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        
        // Create a mutable copy of the notification content
        guard let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(request.content)
            return
        }
        
        // Check if the notification is from Smartech
        if SmartPush.sharedInstance().isNotification(fromSmartech: bestAttemptContent.userInfo) {
            
            
            // Handle Smartech-specific processing
            smartechServiceExtension.didReceive(request) { bestAttemptContent in
                
                NSLog("SMTLogger Updated content: \(bestAttemptContent.userInfo)")
                
                // Add badge key to the updated content
                self.addBadge(to: bestAttemptContent, contentHandler: contentHandler)
                
            }
            
            
        }
    }
  
    override func serviceExtensionTimeWillExpire() {
        // Call Smartech's service extension timeout handler
        smartechServiceExtension.serviceExtensionTimeWillExpire()
    }
  
    // Helper function to add a badge key to the notification content
    private func addBadge(to content: UNNotificationContent, contentHandler: @escaping (UNNotificationContent) -> Void) {
        // Ensure we are working with mutable content
        guard let mutableContent = content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(content)
            return
        }

        // Retrieve the current badge count from UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.netcore.SmartechApp") // Use your App Group here
        var badgeCount = defaults?.integer(forKey: "badgeCount") ?? 0

        // Increment the badge count
        badgeCount += 1
        defaults?.set(badgeCount, forKey: "badgeCount")

        // Set the badge key in the notification content
        mutableContent.badge = NSNumber(value: badgeCount)
        
        // Pass the modified content to the content handler
        contentHandler(mutableContent)
       

    }
}

