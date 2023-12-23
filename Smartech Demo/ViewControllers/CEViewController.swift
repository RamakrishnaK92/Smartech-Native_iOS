//
//  ExtraViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 11/12/22.
//

import UIKit
import Smartech

class CEViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func simplePN(_ sender: UIButton) {
        print("simple_APN")
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"Simple"])
        
        
    }
    @IBAction func multiLingPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"multi_lingual"])
        
    }
    
    @IBAction func audioPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_audio"])
        
    }
    
    
    @IBAction func videoPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_video"])
        
    }
    
    @IBAction func imagePN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_image"])
        
    }
    
    @IBAction func gifPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_gif"])
        
    }
    
    @IBAction func ctaPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"actionbutton"])
        
    }
    @IBAction func carouselLandPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_carousel_landscape"])
        
    }
    @IBAction func carouselPortPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"rich_carousel_portrait"])
        
    }
    @IBAction func deeplinkPN(_ sender: UIButton) {
        Smartech.sharedInstance().trackEvent("apn_test", andPayload: ["type":"deeplink","deeplinkURL":"https://google.com"])
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewDidAppear(_ animated: Bool) {
//                Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current_page":"PushNotification", "next_page":"abc"])
        
    }
}
