//
//  ViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 25/09/21.
//

import UIKit
import FirebaseAuth
import Smartech
import FirebaseAnalytics
import SmartechNudges


//import CoreLocation
import LocalAuthentication

class ViewController: UITableViewController{

    
    var dashVC:DashboardViewController!
    
    @IBOutlet weak var loginTF: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.styleTextField(loginTF)
        Utilities.styleFilledButton(signInBtn)
      

               
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func signInUser(_ sender: UIButton) {
        // TODO: Validate Text Fields
        
        // Create cleaned \versions of the text field
        let email = loginTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        //MARK: SMARTECH USER LOGIN
        if email.isValidEmail == false{
            let alert = UIAlertController(title: "Error!", message: "Please make sure your login is valid", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }else{
            UserDefaults.standard.setValue(email, forKey: "userLogged")
//            Smartech.sharedInstance().login(email)
//            Smartech.sharedInstance().trackEvent("Login_success", andPayload: ["source":"app"])
            goToTabBar()
            UserDefaults.standard.synchronize()
            
        }
    }
    


    @IBAction func googleSignIn(_ sender: UIButton) {
        //        GIDSignIn.sharedInstance.signIn(with: GIDConfiguration(clientID: "531748173665-t9939r7v38cq2d660duo06dt5o3be3lk.apps.googleusercontent.com"), withPresenting: self){user,errorLabel
        
        
//        GIDSignIn.sharedInstance.signIn(with: GIDConfiguration(clientID:"531748173665-t9939r7v38cq2d660duo06dt5o3be3lk.apps.googleusercontent.com"), presenting: self)
            
//        GIDSignIn.sharedInstance.signIn(withPresenting: self){user, error in
//            guard error == nil else { return }
//            guard let user = user else { return }
//            
////            user.authentication.do { authentication, error in
//                guard error == nil else { return }
//                guard let authentication = authentication else { return }
//                
//                let idToken = authentication.idToken
//                
//                print("GID USER: \(String(describing: user.profile?.email))!")
//                // Send ID token to backend (example below).
////                print((user.profile?.email)!)
//                
//                let googleIdentity = (user.profile?.email)!
//                UserDefaults.standard.setValue(googleIdentity, forKey: "userLogged")
//                print("\(UserDefaults.standard.value(forKey: "userLogged")!)")
//                Smartech.sharedInstance().login(googleIdentity)
//                Smartech.sharedInstance().trackEvent("Login_success", andPayload: ["source":"Google"])
//                //                self.transitionToDashboardPage()
//                self.goToTabBar()
//            }
//        }
//
        
    }
    
    
    func transitionToDashboardPage() {
        
        let dashVC = self.storyboard?.instantiateViewController(identifier: "DashboardViewController") as? DashboardViewController
        dashVC?.modalPresentationStyle = .fullScreen
        present(dashVC!, animated: true, completion: nil)
        
    }
    func goToTabBar(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabBarSegue") as! UITabBarController
        nextViewController.modalPresentationStyle = .fullScreen
        
        
        self.present(nextViewController, animated: true)
        self.tabBarController?.selectedIndex = 2
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTF.text = ""
        errorLabel.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        let todayDate = Date().today(format: "yyyy-MM-dd hh:mm:ss")
        print("todayDate:", todayDate)
        
        let params = ["screen_name":"VC screen","trigger_time": todayDate] as [String : Any]
        Analytics.logEvent("screen_view_GTM", parameters:  params)
        Smartech.sharedInstance().trackEvent("screen_view_GTM", andPayload: params)
        
        H

//        Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current_page":"Authentication Screen", "subscriptionDate": "2"])
    }
    
    
}

