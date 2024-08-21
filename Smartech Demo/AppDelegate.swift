//
//  AppDelegate.swift
//  Smartech Demo
//
//  //

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseAuth
import FirebaseCore
import Smartech
import SmartPush
import UserNotifications
import UserNotificationsUI
import IQKeyboardManagerSwift
import GoogleSignIn
import AppsFlyerLib
import SmartechNudges
import MoEngageSDK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, CLLocationManagerDelegate,  UNUserNotificationCenterDelegate, UINavigationBarDelegate, HanselDeepLinkListener, DeepLinkDelegate, MoEngageMessagingDelegate{
    
    var window: UIWindow?
    
    var VC:ViewController?
    var navigationVC:UINavigationController?
    var tabBar:UITabBarController?
    
    var locationManager = CLLocationManager()
    var isUserLoggedIn: Bool {
        return UserDefaults.standard.value(forKey: "userLogged") != nil
    }
    
    
    
    func onLaunchURL(URLString: String!) {
        //
    }
    
    //    func containerAvailable(container: TAGContainer!) {
    //      container.refresh()
    //    }
    
    //Onelink deeplink case
    func didResolveDeepLink(_ result: DeepLinkResult) {
        
        print("SMTLogg: \(String(describing: result.deepLink?.deeplinkValue))") // Step 3
        
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        if isUserLoggedIn == true {
            
            print("Already logged in")
            moveToTabbar(2)
            //
            print("\(UserDefaults.standard.value(forKey: "userLogged")!)")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let tabBar = storyBoard.instantiateViewController(withIdentifier: "tabBarSegue") as! UITabBarController
            tabBar.modalPresentationStyle = .fullScreen
            
            
            Smartech.sharedInstance().setUserIdentity(VC?.email ?? "")
            print(VC?.email)
            
            UIApplication.shared.windows.first?.rootViewController? = tabBar
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            //
        }
        
        UIFont.overrideInitialize()
        
        
        //MARK: FIREBASE SDK INIT
        FirebaseApp.configure()
        //        let GTM = TAGManager.instance()
        //        GTM.logger.setLogLevel(kTAGLoggerLogLevelVerbose)
        //
        //        TAGContainerOpener.openContainerWithId("GTM-M6QRHT25",  // change the container ID "GTM-PT3L9Z" to yours
        //            tagManager: GTM, openType: kTAGOpenTypePreferFresh,
        //            timeout: nil,
        //            notifier: self)
        
        
        //MARK: SMARTECH SDK INIT
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        Smartech.sharedInstance().setDebugLevel(.verbose)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        Hansel.enableDebugLogs()
        Hansel.setAppFont("Trueno")

        
        IQKeyboardManager.shared.enable = true
        LocationManager.shared.requestLocationAuthorization()
        
        
//        if let url = launchOptions?[.url] as? URL {
//            
//        }
//        UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Trueno"))
        
//        MARK: APPSFLYER SDK INIT
//                AppsFlyerLib.shared().appsFlyerDevKey = "gSN6uycoztm9E4dH6EbdZK"
//                AppsFlyerLib.shared().appleAppID = "Y344Y7796A.com.netcore.SmartechApp"
//                AppsFlyerLib.shared().deepLinkDelegate = self
//        
//          Set isDebug to true to see AppsFlyer debug logs
//
//        AppsFlyerLib.shared().isDebug = true
//        AppsFlyerLib.shared().start()
        
        //MARK: MOENGAGE SDK INIT
        let sdkConfig = MoEngageSDKConfig(appId: "892S3LHOIZHLLNQ8DUXQNL83", dataCenter: .data_center_01);
        
        // MoEngage SDK Initialization
        // Separate initialization methods for Dev and Prod initializations
//#if DEBUG
        MoEngage.sharedInstance.initializeDefaultTestInstance(sdkConfig)
//#else
//        MoEngage.sharedInstance.initializeDefaultLiveInstance(sdkConfig)
//#endif
      
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
        
        UNUserNotificationCenter.current().delegate = self
        
        
        return true
    }
    
    
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        SmartPush.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.setPushToken(deviceToken)
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        SmartPush.sharedInstance().didFailToRegisterForRemoteNotificationsWithError(error)
        
        //Call only if MoEngageAppDelegateProxyEnabled is NO
        MoEngageSDKMessaging.sharedInstance.didFailToRegisterForPush()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print(url)
        return true
    }
    
    //MARK:- UNUserNotificationCenterDelegate Methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        NSLog("SMTL-APP (foreground APN):- \(notification.request.content.userInfo)\n")
        SmartPush.sharedInstance().willPresentForegroundNotification(notification)
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        NSLog("SMTL-APP (didReceive):- \(response)")
        
        
        if SmartPush.sharedInstance().isNotification(fromSmartech: response.notification.request.content.userInfo){
            SmartPush.sharedInstance().didReceive(response)
            NSLog("SMTL-APP (didReceive SMT):- \(response)")
            
        }else{
            //Call only if MoEngageAppDelegateProxyEnabled is NO
            MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
            
            //Custom Handling of notification if Any
            let pushDictionary = response.notification.request.content.userInfo
            print(pushDictionary)
            NSLog("SMTL-APP (didReceive MOE):- \(response)")
        }
        
        //Validate if the notification belongs to MoEngage
        //        let isPushFromMoEngage = MoEngageSDKMessaging.sharedInstance.isPushFromMoEngage(withPayload: notification.request.content.userInfo))
        
        completionHandler()
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
        tabBarController.selectedIndex = withIndex
        
        (rootController: tabBarController, window:UIApplication.shared.keyWindow)
        
    }
    
    //MARK: SMT DEEPLINK CALLBAC
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        if deeplinkURLString.starts(with: "https://netcore.onelink"){
            let url = NSURL(string: deeplinkURLString)
            AppsFlyerLib.shared().handleOpen(url as URL?, options: nil)
            
            return
        }
        
        NSLog("SMTLogger DEEPLINK NEW CALL: \(deeplinkURLString)")
        handleDeepLink(url: deeplinkURLString)
    }
    
    func handleDeepLink(url:String){
        if let webUrl = URL(string: url){
            UIApplication.shared.canOpenURL(webUrl)
        }
    }
    
    //        var newDeeplink = deeplinkURLString.components(separatedBy: "?")
    //        NSLog("SMTLogger DEEPLINK NEW CALL: \(newDeeplink[0])")
    //
    //
    //        handleDeepLink(url: newDeeplink[0])
    //
    //        // Convert OneLink to Deep Link
    //        if let deepLinkURL = convertOneLinkToDeepLink(newDeeplink[0]) {
    //            handleDeepLinkCode(deepLinkURL)
    //        }
    //    }
    
    
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
    
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
    //        NSLog("SMTL-APP NEW METHOD BACKGROUND:: \(userInfo)")
    //
    //        return UIBackgroundFetchResult.newData
    //    }
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    //
    //
    //        NSLog("SMTL-APP BACKGROUND : \(userInfo)")
    //        if SmartPush.sharedInstance().isNotification(fromSmartech: userInfo){
    //
    //            NSLog("SMTL-APP BACKGROUND inside : \(userInfo)")
    //
    //        }
    //        completionHandler(UIBackgroundFetchResult.newData)
    //    }
    
}



