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

import CoreLocation


struct GPXLocation {
    let latitude: Double
    let longitude: Double
}

class QuickTestVC: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet var attribKeyCETF: UITextField!
    @IBOutlet var attribValueCETF: UITextField!
    @IBOutlet var eventNameTF: UITextField!
    @IBOutlet var eventValueView:UITextView!
    
    
    var locationManager = CLLocationManager()
    var gpxLocations: [GPXLocation] = []
    var currentLocationIndex = 0
    
    
    var attribCEKey: String!
    var attribCEValue: String!
    
    var eventName: String!
    var eventPayloadDict: [AnyHashable:Any]!
    
    //Json Array for Feature Mgmt
    var banners_for_city: [Dictionary] = [["image1":""],["image2":""],["image3":""]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        
        attribKeyCETF.text = ""
        eventNameTF.text = ""
        eventValueView.text = ""
        attribValueCETF.text = ""
        
        
        //        // Setup the UITextView
        //
        //               NSLayoutConstraint.activate([
        //                   textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        //                   textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        //                   textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        //                   textView.heightAnchor.constraint(equalToConstant: 300)
        //               ])
        
        // Add a button to trigger validation and formatting
        let formatButton = UIButton(type: .system)
        formatButton.setTitle("Validate & Format JSON", for: .normal)
        formatButton.addTarget(self, action: #selector(validateAndFormatJSON), for: .touchUpInside)
        formatButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(formatButton)
        
        NSLayoutConstraint.activate([
//            formatButton.topAnchor.constraint(equalTo: eventValueView.bottomAnchor, constant:  ),
            formatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            formatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 20.0)
        ])
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        let jsonArrayBanner = HanselConfigs.getJSONArray("banners_for_city", withDefaultValue: banners_for_city)
        //
        //        NSLog("jsonArrayBanner Dict: \(jsonArrayBanner!)")
        //        NSLog("Banner Dict: \(banners_for_city)")
        
        
        //        datapack_info
        var datapack_json: [Dictionary] = [[
            "category": "DataPacks",
            "planName": "",
            "packageName": "Data Pack local",
            "product_url": "",
            "image_url": "",
            "packageID": "",
            "tenure": "",
            "price": 0.0
        ]]
        
        var recharge_json: [Dictionary] = [[
            "category": "Recharge",
            "packageName": "Voice Pack local",
            "product_url": "",
            "image_url": "",
            "packageID": "",
            "tenure": "",
            "price": 0.0
        ]]
        
        let rechargeJsonGP = HanselConfigs.getJSONArray("recharge_info", withDefaultValue: recharge_json)
        let dataJsonGP = HanselConfigs.getJSONArray("datapack_info", withDefaultValue: datapack_json)
        
        NSLog("jsonArrayBanner Dict: \(dataJsonGP!)")
        NSLog("jsonArrayBanner Dict: \(rechargeJsonGP!)")
        
        
        
        showAlert("Recharge Info", (rechargeJsonGP?.description ?? "No info available")) {
            // Show second alert after first one is dismissed
            self.showAlert("Datapack_info", (dataJsonGP?.description ?? "No info available"))
        }
        
    
        
    }
    
    @IBAction func attribCE(){
        
        attribCEKey = attribKeyCETF.text ?? ""
        attribCEValue = attribValueCETF.text ?? ""
        
        NSLog("attribCEKey:\(attribCEKey!)")
        NSLog("attribCEValue:\(attribCEValue!)")
        
        //        var payload : [String:Any] =
        
        Smartech.sharedInstance().updateUserProfile([attribCEKey!:attribCEValue!])
        
    }
    
    
    
    @IBAction func events(){
        if eventNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || eventValueView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            NSLog("EMPTY VALUE in TF, Enter Something")
            
        }else{
            
            eventName = eventNameTF.text?.localizedLowercase ?? ""
            
            //            // Convert JSON string to Dictionary
            //            if let jsonString = eventValueView.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            ////                if let dictionary = convertJSONStringToDictionary(jsonString) {
            //                if let dictionary = j(jsonString) {
            //
            //                    print(dictionary)
            //                    eventPayloadDict = dictionary
            ////
            ////                    // ["name": "Ramakrishna", "age": 30, "city": "Bangalore"]
            ////                    //["image_url": "https://wallpapercave.com/wp/X0hSfWT.jpg", "prid":"ABC"]
            ////                    NSLog("eventPayload dict:\(dictionary)")
            //
            //                    Smartech.sharedInstance().trackEvent(eventName, andPayload: eventPayloadDict)
            
            //                } else {
            //                    print("Failed to convert JSON string to Dictionary")
            //                }
            
            
            NSLog("eventName:\(eventName!)")
            NSLog("eventPayload:\(eventPayloadDict ?? [:])")
        }
    }
    
    //        func convertJSONStringToDictionary(_ jsonString: String) -> [String: Any]? {
    //            // Convert the JSON string to Data
    //            NSLog("JSON String before:\(jsonString)")
    //
    //            guard let data = jsonString.data(using: .utf8) else {
    //                print("Invalid JSON string")
    //                return nil
    //            }
    //
    //            // Deserialize the JSON data to Dictionary
    //            do {
    //                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    //                NSLog("dictionary after Dict conversion : \(dictionary ?? [:])")
    //                return dictionary
    //            } catch {
    //                print("Error during JSON deserialization: \(error.localizedDescription)")
    //                return nil
    //            }
    //        }
    
    // Method to validate and format JSON
    @objc func validateAndFormatJSON() {
        guard let text = eventValueView.text, !text.isEmpty else {
            showAlert("Error", "Please enter JSON text.")
            return
        }
        
        // Try to parse the text as JSON
        if let jsonData = text.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                
                // Re-serialize the JSON with pretty printing
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyPrintedString = String(data: prettyData, encoding: .utf8) {
                    eventValueView.text = prettyPrintedString
                    showAlert("Success", "JSON is valid and formatted")
                }
                
            } catch {
                // Show error if JSON is invalid
                showAlert("Invalid JSON", "The text you entered is not valid JSON.")
            }
        } else {
            showAlert("Encoding Error", "Failed to encode text as UTF-8.")
        }
    }
    
    
    
    func showAlert(_ title: String, _ message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()  // Call the completion handler after dismiss
        }
        
        alert.addAction(okAction)
        if let topVC = UIApplication.shared.keyWindow?.rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    @IBAction func simulateLocation(_ sender: UIButton) {
        
        
        
        // Load GPX data
        if let filePath = Bundle.main.path(forResource: "My PG", ofType: ".gpx"),
           let url = URL(string: filePath) {
            let gpxParser = GPXParser()
            gpxLocations = gpxParser.parseGPX(fileURL: url) ?? []
        }
        
        // Check if there are locations to simulate
        guard gpxLocations.count > 0 else { return }
        
        let location = gpxLocations[currentLocationIndex]
        
        // Create a CLLocation object with the mock data
        let simulatedLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        print("Simulated Location: \(simulatedLocation.coordinate.latitude), \(simulatedLocation.coordinate.longitude)")
        // Call delegate method with simulated location
        locationManager.delegate?.locationManager?(locationManager, didUpdateLocations: [simulatedLocation])
        
        // Update the index to point to the next location
        currentLocationIndex = (currentLocationIndex + 1) % gpxLocations.count
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Simulated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
}





class GPXParser: NSObject, XMLParserDelegate {
    var locations: [GPXLocation] = []
    var currentElement = ""
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    func parseGPX(fileURL: URL) -> [GPXLocation]? {
        guard let parser = XMLParser(contentsOf: fileURL) else { return nil }
        parser.delegate = self
        parser.parse()
        return locations
    }
    
    // XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        // When a <trkpt> element is encountered, extract the lat and lon attributes
        if elementName == "trkpt" {
            if let lat = attributeDict["lat"], let lon = attributeDict["lon"] {
                currentLatitude = Double(lat)
                currentLongitude = Double(lon)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // This method handles inner text inside elements. We don't need to handle lat/lon here.
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // Once a <trkpt> element is fully parsed, save the location
        if elementName == "trkpt", let lat = currentLatitude, let lon = currentLongitude {
            locations.append(GPXLocation(latitude: lat, longitude: lon))
        }
    }
}
