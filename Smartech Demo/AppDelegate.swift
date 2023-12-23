//
//  AppDelegate.swift
//  Smartech Demo
//
//  //

import UIKit
import Firebase
import CoreLocation
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift
import GoogleSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, CLLocationManagerDelegate,  UNUserNotificationCenterDelegate, UINavigationBarDelegate, HanselDeepLinkListener{
    func onLaunchURL(URLString: String!) {
        //
    }
    
    
    var window: UIWindow?
    
    var VC:ViewController?
    var navigationVC:UINavigationController?
    var tabBar:UITabBarController?
    
    var locationManager = CLLocationManager()
    var isUserLoggedIn: Bool {
        return UserDefaults.standard.value(forKey: "userLogged") != nil
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if isUserLoggedIn == true {
            
            print("Already logged in")
            moveToTabbar(0)
            //
            print("\(UserDefaults.standard.value(forKey: "userLogged")!)")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBarSegue") as! UITabBarController
            tabBar.modalPresentationStyle = .fullScreen
            
            UIApplication.shared.windows.first?.rootViewController? = tabBar
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            //
        }
        
        
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        Smartech.sharedInstance().setDebugLevel(.verbose)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        Hansel.enableDebugLogs()
        UNUserNotificationCenter.current().delegate = self
        
    
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        self.getLocations()
        
     //test deeplink
        
        if let url = launchOptions?[.url] as? URL {
//                    handleDeepLink(url)
                }
//                return true

        
        return true
        
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print(url)
        return true
    }
    
    //MARK:- UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        SmartPush.sharedInstance().willPresentForegroundNotification(notification)
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("SMT-APP (didReceive):- \(response)")
        
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
        SmartPush.sharedInstance().didReceive(response)
        completionHandler()
        //        })
    }
    
      func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("SMT -BACKGROUND DELIVER", userInfo)
        
    }
    //MARK:- SmartechDelegate Method
//    func handleDeeplinkAction(withURLString deeplinkURLString: String, andCustomPayload customPayload: [AnyHashable : Any]?) {
//        //...
//        NSLog("DEEPLINK OLD: \(deeplinkURLString)")
////        print("Deeplink: \(deeplinkURLString)")
//        if customPayload != nil {
//            print("Custom Payload: \(customPayload!)")
//
//        }
//
//        //...
//    }
//
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handleBySmartech:Bool = Smartech.sharedInstance().application(app, open: url, options: options)
        print("URL:\(url)")
        //            ....
        if let scheme = url.scheme,
           scheme.localizedCaseInsensitiveCompare("smartechdemo") == .orderedSame,
           var finalHost = url.host {
            print("Final Host: \(finalHost)")
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
                print("TEST URL: ",parameters[$0.value!] as Any )
            }
            
            if finalHost == "px"{
                let tabBarController = UITabBarController()
                
                navigationVC?.pushViewController(tabBarController, animated: true)
                
                ////            smartechdemo://px
                (rootController: tabBarController, window:UIApplication.shared.keyWindow)
            }
            
        }
        
        
        if(!handleBySmartech) {
            //Handle the url by the app
            
        }else{
            return handleBySmartech
        }
        
        return ((GIDSignIn.sharedInstance.handle(url)) != nil)
    }
    
    func moveToTabbar(_ withIndex : Int){
        let tabBarController = UITabBarController()
        tabBarController.selectedIndex = 2
        
        (rootController: tabBarController, window:UIApplication.shared.keyWindow)
    }
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            NSLog("SMTLogger DEEPLINK NEW CALL: \(deeplinkURLString)")
//        })

    }
    
    
    func getLocations() -> Void {
                locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.authorizationStatus() == .restricted {
            
        }
        if CLLocationManager.authorizationStatus() == .denied {
            
        }
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            
        }
       
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("Error is ", error);
        
                if CLLocationManager.authorizationStatus() == .restricted {
                    print("restricted");
                }
                if CLLocationManager.authorizationStatus() == .denied {
                    print("denied");
                }
                if CLLocationManager.authorizationStatus() == .notDetermined {
                    print("notDetermined");
                }
                if CLLocationManager.authorizationStatus() == .authorizedAlways {
                    print("authorizedAlways");
                }
                if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                    print("authorizedWhenInUse");
                }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude
        
        let location = CLLocationCoordinate2DMake(lat, long)
        Smartech.sharedInstance().setUserLocation(location)

        print("lat", lat, "long", long)
        
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
    
    
}
