//
//  LoginViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 25/09/21.
//

import UIKit
import FirebaseAuth
import SmartechAppInbox
import Smartech
import SmartPush
import SmartechNudges


class DashboardViewController: UIViewController {
    
    var VC:ViewController!
    var notifVC:AppInboxController!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current page":"Profile page"])
    }
  
    
    
    @IBAction func logoutUser(_ sender: UIButton) {
        removeCurrentUser()
        
        Smartech.sharedInstance().trackEvent("Logout_success", andPayload: [:])
        Smartech.sharedInstance().logoutAndClearUserIdentity(true)
        Hansel.getUser()?.clear()
      
        transitionToLoginPage()
    }
    
    func transitionToLoginPage() {
        
        let VC = self.storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController
        VC?.modalPresentationStyle = .fullScreen
        present(VC!, animated: true, completion: nil)
        
    }
        func removeCurrentUser(){
            if UserDefaults.standard.value(forKey: "userLogged") != nil {
                UserDefaults.standard.removeObject(forKey: "userLogged")
                UserDefaults.standard.synchronize()
            }
        }
    
 
    @IBAction func inboxDefault(_ sender: UIButton) {

        let appInboxVC = SmartechAppInbox.sharedInstance().getViewController()
//                appInboxVC.modalPresentationStyle = .fullScreen
            
        present(appInboxVC, animated: true, completion: nil)

        }
    }
