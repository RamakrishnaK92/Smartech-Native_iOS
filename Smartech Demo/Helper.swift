//
//  Helper.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 17/12/22.
//

import Foundation
import CoreLocation
import Smartech

func getLoginStatus(){
    
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    
    public func requestLocationAuthorization() {
        self.locationManager.delegate = self
        let currentStatus = CLLocationManager.authorizationStatus()
        
        // Only ask authorization if it was never asked before
        guard currentStatus == .notDetermined else { return }
        
        // Starting on iOS 13.4.0, to get .authorizedAlways permission, you need to
        // first ask for WhenInUse permission, then ask for Always permission to
        // get to a second system alert
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                    
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude
        
        let location = CLLocationCoordinate2DMake(lat, long)
        Smartech.sharedInstance().setUserLocation(location)
        
        print("lat", lat, "long", long)
        
    }
    
}




//MARK: Process to redirect to Notification settings page after user denied permissions initially

//    func goToAppNotificationSettings() {
//        let alertController = UIAlertController(
//            title: "Notification Permissions",
//            message: "Please enable notifications for this app in Settings.",
//            preferredStyle: .alert
//        )
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
//            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                return
//            }
//            if UIApplication.shared.canOpenURL(settingsUrl) {
//                UIApplication.shared.open(settingsUrl, completionHandler: nil)
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alertController.addAction(settingsAction)
//        alertController.addAction(cancelAction)
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
//
//            self.window?.rootViewController?.present(alertController, animated: true)
//        })
//
//    }

//    func applicationWillEnterForeground(_ application: UIApplication) {
//
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.getNotificationSettings { [self] settings in
//            if settings.authorizationStatus == .denied {
//
//                print("Selected Deny")
//                goToAppNotificationSettings()
//
//            } else{
//                print("Selected Allow")
//            }
//        }
//
//    }




