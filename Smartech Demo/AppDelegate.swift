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
import AppsFlyerLib


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
        
        UIFont.overrideInitialize()
        
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        Smartech.sharedInstance().setDebugLevel(.verbose)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        Hansel.enableDebugLogs()
        Hansel.setAppFont("Trueno")
        
        UNUserNotificationCenter.current().delegate = self
        
        
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        LocationManager.shared.requestLocationAuthorization()
        
        
        if let url = launchOptions?[.url] as? URL {
            
        }
        UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Trueno"))
        
        
        AppsFlyerLib.shared().appsFlyerDevKey = "gSN6uycoztm9E4dH6EbdZK"
        AppsFlyerLib.shared().appleAppID = "Y344Y7796A.com.netcore.SmartechApp"
        
//        AppsFlyerLib.shared().addPushNotificationDeepLinkPath(["af_push_link"])
        AppsFlyerLib.shared().addPushNotificationDeepLinkPath(["smtPayload", "deeplink"])
        
        
        //  Set isDebug to true to see AppsFlyer debug logs
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().start()
        
//        application.registerForRemoteNotifications()
        return true
    }
    
    func handleDeepLink(url:String){
        if let webUrl = URL(string: url){
            UIApplication.shared.canOpenURL(webUrl)
        }
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
    /*
     You can create an instance of your custom font in source code. To do this, you need to know the font name. However, the name of the font isn’t always obvious, and rarely matches the font file name. A quick way to find the font name is to get the list of fonts available to your app, which you can do with the following code:
     
     Once you know the font name, create an instance of the custom font using UIFont. If your app supports Dynamic Type, you can also get a scaled instance of your font, as shown here:
     
     
     
     */    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
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
    
    //MARK: SMT DEEPLINK CALLBACK
    
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        
        var newDeeplink = deeplinkURLString.components(separatedBy: "%")
        NSLog("SMTLogger DEEPLINK NEW CALL: \(newDeeplink[0])")
        
        AppsFlyerLib.shared().addPushNotificationDeepLinkPath(["smtPayload", "deeplink"])
        handleDeepLink(url: newDeeplink[0])
        
        
    }
    
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



