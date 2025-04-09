//
//  ExtraViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 11/12/22.
//

import UIKit
import Smartech
import SmartechNudges
import Alamofire


class CEViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postALamofireTest()
        //        Smartech.sharedInstance().setUserIdentity("test@gmail.com")
        
        
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
//                            Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current_page":"PushNotification", "next_page":"abc"])
            Smartech.sharedInstance().trackEvent("product_view", andPayload: ["amount": 100.00])

    
        }
    

    func postALamofireTest() {
        // Parameters for the POST request
        let parameters: [String: Any] = [
            "title": "Test Product",
            "price": 29.99,
            "description": "This is a test product.",
            "image": "https://example.com/image.png",
            "category": "electronics"
        ]

        // Make the API request
        AF.request(
            "https://fakestoreapi.com/products",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).response { response in
            switch response.result {
            case .success(let data):
                // Ensure data is not nil
                guard let data = data else {
                    print("No data received")
                    return
                }

                // Parse the response JSON
                do {
                    // Convert JSON data to a dictionary
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonDict = json as? [String: Any] {
                        print("Response JSON: \(jsonDict)")
                    } else {
                        print("Response format unexpected")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }

            case .failure(let error):
                // Handle request failure
                print("Request failed with error: \(error)")
            }
        }
    }

}



