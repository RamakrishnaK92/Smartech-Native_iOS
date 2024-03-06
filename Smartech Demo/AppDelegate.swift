//
//  AppDelegate.swift
//  Smartech Demo
//
//  //

import UIKit
import Firebase
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift
import GoogleSignIn
import AppsFlyerLib
import SmartechNudges


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, CLLocationManagerDelegate,  UNUserNotificationCenterDelegate, UINavigationBarDelegate, HanselDeepLinkListener, DeepLinkDelegate{
    func onLaunchURL(URLString: String!) {
        //
    }
    func didResolveDeepLink(_ result: DeepLinkResult) {
        
        print("SMTLogg: \(String(describing: result.deepLink?.deeplinkValue))") // Step 3
        
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
        AppsFlyerLib.shared().deepLinkDelegate = self
        
        
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
    
    //MARK: SMT DEEPLINK CALLBACK
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        if deeplinkURLString.starts(with: "https://onelink"){
            let url = NSURL(string: deeplinkURLString)
            AppsFlyerLib.shared().handleOpen(url as URL?, options: nil)
            return
        }
        
        var newDeeplink = deeplinkURLString.components(separatedBy: "%")
        NSLog("SMTLogger DEEPLINK NEW CALL: \(newDeeplink[0])")
        
        
        handleDeepLink(url: newDeeplink[0])
        
        // Convert OneLink to Deep Link
        if let deepLinkURL = convertOneLinkToDeepLink(newDeeplink[0]) {
            handleDeepLinkCode(deepLinkURL)
        }
    }
    //
    func convertOneLinkToDeepLink(_ oneLinkURLString: String) -> URL? {
        // Parse the OneLink URL
        if let components = URLComponents(string: oneLinkURLString) {
            
            // Create the deep link URL
            // You might want to use your own deep link URL structure
            //          Onelink URL: https://netcore.onelink.me/Fqaw/fik922ai
            //          Expected URL: https://demo1.netcoresmartech.com/pod2_email_rashmi/
            var deepLinkComponents = URLComponents()
            deepLinkComponents.scheme = "netcore"
            deepLinkComponents.host = ""
            // Add necessary query parameters if any
            deepLinkComponents.queryItems = [
                URLQueryItem(name: "param1", value: "value1"),
                URLQueryItem(name: "param2", value: "value2")
            ]
            
            if let deepLinkURL = deepLinkComponents.url {
                return deepLinkURL
            }
        }
        
        return nil
    }
    
    func handleDeepLinkCode(_ deepLinkURL: URL) {
        // Handle the deep link URL in your app
        // You might want to navigate to a specific view controller or perform other actions
        // For example, you can use URL components to extract information from the deep link
        if let queryItems = URLComponents(url: deepLinkURL, resolvingAgainstBaseURL: false)?.queryItems {
            for item in queryItems {
                print("Parameter \(item.name): \(item.value ?? "")")
                // Handle each parameter as needed
            }
        }
    }
}



