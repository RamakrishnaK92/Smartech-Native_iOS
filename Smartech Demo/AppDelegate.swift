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
import SmartechAppInbox


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SmartechDelegate, CLLocationManagerDelegate,  UNUserNotificationCenterDelegate, UINavigationBarDelegate, HanselDeepLinkListener, DeepLinkDelegate, MoEngageMessagingDelegate, HanselActionListener, HanselEventsListener{
    
    
    func fireHanselEventwithName(eventName: String, properties: [AnyHashable : Any]?) {
        
        // hansel_nudge_show_event, hansel_nudge_event, hansel_branch_tracker
        Smartech.sharedInstance().trackEvent(eventName, andPayload: properties)
    }
    
    
    let defaults = UserDefaults(suiteName: "group.com.netcore.SmartechApp") // Use your App Group here
    
    
    // MARK: PX - ActionListener
    func onActionPerformed(action: String!) {
        if action == "Test"{
            
        }
    }
    
    // MARK: PX - Deeplink Listener
    func onLaunchURL(URLString: String!) {
        
        
        NSLog("URL Nudge: \(URLString)")
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
    
    
    
    // MARK: Onelink deeplink case
    func didResolveDeepLink(_ result: DeepLinkResult) {
        
        print("SMTLogg: \(String(describing: result.deepLink?.deeplinkValue))") // Step 3
        
    }
    
    // MARK: DIDFINISH LAUNCH
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        
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
        
        //MARK: SMARTECH SDK INIT
        Smartech.sharedInstance().initSDK(with: self, withLaunchOptions: launchOptions)
        
        Smartech.sharedInstance().setDebugLevel(.verbose)
        SmartPush.sharedInstance().registerForPushNotificationWithDefaultAuthorizationOptions()
        Smartech.sharedInstance().trackAppInstallUpdateBySmartech()
        Hansel.enableDebugLogs()
        
        //        Hansel.setAppFont("Trueno")
        Hansel.setAppFont("")
        
        
        IQKeyboardManager.shared.isEnabled = true
        LocationManager.shared.requestLocationAuthorization()
        
        HanselTracker.registerListener(self)
        Hansel.registerHanselDeeplinkListener(listener: self)
        
        Hansel.getUser()?.putAttribute("Value", forKey: "Key")
        //        if let url = launchOptions?[.url] as? URL {
        //
        //        }
        //        UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: "Trueno"))
        
        //        MARK: APPSFLYER SDK INIT
        //                AppsFlyerLib.shared().appsFlyerDevKey = "gSN6uycoztm9E4dH6EbdZK"
        //                AppsFlyerLib.shared().appleAppID = "Y344Y7796A.com.netcore.SmartechApp"
        AppsFlyerLib.shared().deepLinkDelegate = self // Onelink step 1 in didfinishLaunching
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
        
        defaults?.set(0, forKey: "badgeCount")
        
        
        NSLog("SMTL-APP (foreground APN):- \(notification.request.content.userInfo)\n")
        SmartPush.sharedInstance().willPresentForegroundNotification(notification)
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        if SmartPush.sharedInstance().isNotification(fromSmartech: response.notification.request.content.userInfo){
            
            SmartPush.sharedInstance().didReceive(response)
            defaults?.set(0, forKey: "badgeCount")
            NSLog("SMTL-APP (didReceive SMT):- \(response)")
            
        }else{
            //Call only if MoEngageAppDelegateProxyEnabled is NO
            MoEngageSDKMessaging.sharedInstance.userNotificationCenter(center, didReceive: response)
            
            //Custom Handling of notification if Any
            let pushDictionary = response.notification.request.content.userInfo
            print(pushDictionary)
            NSLog("SMTL-APP (didReceive MOE):- \(response)")
        }
        
        
        completionHandler()
    }
    
    
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
    //
    func moveToTabbar(_ withIndex : Int){
        let tabBarController = UITabBarController()
        tabBarController.selectedIndex = withIndex
        
        (rootController: tabBarController, window:UIApplication.shared.keyWindow)
        
    }
    
    //Universal link handling
    fileprivate func emailAPITracking(emailURL: String ) {
        //https://cedocs.netcorecloud.com/docs/universal-links-for-email-engagement#implementing-link-resolution
        
        let netcoreURL = URL(string: emailURL)
        
        //        if let referralURL = userActivity.webpageURL, let netcoreURL = URL(string: String(describing: referralURL)){
        print("URL: \(netcoreURL!)")
        
        let task = URLSession.shared.dataTask(with: netcoreURL!) { data, response, error in
            guard error == nil else {
                print("Universal Error resolving link: \(error!)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let originalURL = httpResponse.url {
                    let responseValue = originalURL.absoluteString // Convert the URL to a string
                    print("Response URL: \(responseValue)")
                    self.VC?.showAlert(withValue: responseValue)
                    
                } else {
                    print("HTTP response was not successful: \(httpResponse.statusCode)")
                    
                }
            } else if response == nil {
                print("Response is nil")
            } else {
                print("Invalid or unsuccessful HTTP response")
                
            }
            
            
            
            
            //        else {
            //            print("Invalid referral URL")
            //
            //        }
            
            
        }
        task.resume()
        
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        
        //        emailAPITracking(emailURL: "https://google.com")
        emailAPITracking(emailURL: String(describing: userActivity.webpageURL!))
        
        return true
    }
    
    
    //MARK: SMT DEEPLINK CALLBACK
    func handleDeeplinkAction(withURLString deeplinkURLString: String, andNotificationPayload notificationPayload: [AnyHashable : Any]?) {
        
        NSLog("SMTLogger DEEPLINK NEW CALL: \(deeplinkURLString)")
        NSLog("SMTLogger NOTIF PAYLOAD CALL: \(notificationPayload!)")
        
        
        
        //OneLink step 2
        if deeplinkURLString.starts(with: "https://netcore.onelink"){
            // receive actual link from panel
            let url = NSURL(string: deeplinkURLString)
            AppsFlyerLib.shared().handleOpen(url as URL?, options: nil)
            
            return
        }
        
        //        let deeplinkURLString = "arguments={\"route\":\"live Test\",\"key\":\"value\"}"
        
        //             MARK: Extract the JSON substring
        //        if let range = deeplinkURLString.range(of: "arguments=") {
        //            let jsonSubstring = deeplinkURLString[range.upperBound...].trimmingCharacters(in: .whitespaces)
        //
        //            if let jsonData = jsonSubstring.data(using: .utf8),
        //               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
        //               let jsonDataFormatted = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
        //               let jsonString = String(data: jsonDataFormatted, encoding: .utf8) {
        //                print(jsonString) // Output: {"route":"live Test","key":"value"}
        //                NSLog("SMTLogger JSON CALL: \(jsonString)")
        //
        //            }
        //        }
        
        
        
        if let custDict = notificationPayload!["smtCustomPayload"] {
            print("Name: \(custDict)") // Output: Name: John
        } else {
            print("Key not found")
        }
        
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
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        NSLog("SMTL-APP BACKGROUND : \(userInfo)")
        if SmartPush.sharedInstance().isNotification(fromSmartech: userInfo){
            
            NSLog("SMTL-APP BACKGROUND inside : \(userInfo)")
            
            
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
           
    func applicationDidBecomeActive(_ application: UIApplication) {
        var badgeCount = defaults?.integer(forKey: "badgeCount") ?? 0
        defaults?.setValue(0, forKey: "badgeCount")
        application.applicationIconBadgeNumber = 0
    }

    
    
}


