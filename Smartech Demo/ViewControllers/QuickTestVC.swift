//
//  File.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 03/08/24.
//

import Foundation
import UIKit
import SmartechNudges
import Smartech

class QuickTestVC: UIViewController{
    
    @IBOutlet var attribKeyCETF: UITextField!
    @IBOutlet var attribValueCETF: UITextField!
    @IBOutlet var attribKeyPXTF: UITextField!
    @IBOutlet var attribValuePXTF: UITextField!
    @IBOutlet var eventNameTF: UITextField!
    @IBOutlet var eventValueView:UITextView!
    
    
    var attribCEKey: String!
    var attribCEValue: String!
    
    var attribPXKey: String!
    var attribPXValue: String!
    
    var eventName: String!
    var eventPayloadDict: [AnyHashable:Any]!
    
    //Json Array for Feature Mgmt
    var banners_for_city: [Dictionary] = [["image1":""],["image2":""],["image3":""]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribKeyCETF.text = ""
        attribKeyPXTF.text = ""
        eventNameTF.text = ""
        eventValueView.text = ""
        attribValueCETF.text = ""
        attribValuePXTF.text = ""
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let jsonArrayBanner = HanselConfigs.getJSONArray("banners_for_city", withDefaultValue: banners_for_city)
        
        NSLog("jsonArrayBanner Dict: \(jsonArrayBanner!)")
        NSLog("Banner Dict: \(banners_for_city)")
    }
    @IBAction func attribCE(){
        
        attribCEKey = attribKeyCETF.text ?? ""
        attribCEValue = attribValueCETF.text ?? ""
        
        NSLog("attribCEKey:\(attribCEKey!)")
        NSLog("attribCEValue:\(attribCEValue!)")
        
        Smartech.sharedInstance().updateUserProfile([attribCEKey:attribCEValue!] as [AnyHashable:Any])
        
    }
    
    
    @IBAction func attribPX(){
        
        attribPXKey = attribKeyPXTF.text ?? ""
        attribPXValue = attribValuePXTF.text ?? ""
        
        NSLog("attribPXKey:\(attribPXKey!)")
        NSLog("attribPXValue:\(attribPXValue!)")
        
        Hansel.getUser()?.putAttribute(attribPXValue, forKey: attribPXKey)
        
        
    }
    
    @IBAction func events(){
        if eventNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || eventValueView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            NSLog("EMPTY VALUE in TF, Enter Something")
            
        }else{
            
            eventName = eventNameTF.text ?? ""
           
            // Convert JSON string to Dictionary
            if let jsonString = eventValueView.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                if let dictionary = convertJSONStringToDictionary(jsonString) {
                    print(dictionary)
                    eventPayloadDict = dictionary
                    
                    // ["name": "Ramakrishna", "age": 30, "city": "Bangalore"]
                    //["image_url": "https://wallpapercave.com/wp/X0hSfWT.jpg", "prid":"ABC"]
                    NSLog("eventPayload dict:\(dictionary)")
                    
                    Smartech.sharedInstance().trackEvent(eventName, andPayload: eventPayloadDict)
                    
                } else {
                    print("Failed to convert JSON string to Dictionary")
                }
                
                
                NSLog("eventName:\(eventName!)")
                NSLog("eventPayload:\(eventPayloadDict ?? [:])")
            }
        }
        
        func convertJSONStringToDictionary(_ jsonString: String) -> [String: Any]? {
            // Convert the JSON string to Data
            NSLog("JSON String before:\(jsonString)")
            
            guard let data = jsonString.data(using: .utf8) else {
                print("Invalid JSON string")
                return nil
            }
            
            // Deserialize the JSON data to Dictionary
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                NSLog("dictionary after Dict conversion : \(dictionary ?? [:])")
                return dictionary
            } catch {
                print("Error during JSON deserialization: \(error.localizedDescription)")
                return nil
            }
        }
        
    }
    
}
