//
//  RegisterViewController.swift
//  Smartech Demo
//
//  Created by Ramakrishna Kasuba on 25/09/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Smartech

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let truenoRg = UIFont(name: "Truenorg", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        errorLabel.font = UIFontMetrics.default.scaledFont(for: truenoRg)
        errorLabel.adjustsFontForContentSizeCategory = true
//        Smartech.sharedInstance().trackEvent("screen_viewed", andPayload: ["current page":"Personal details Screen","next page": "main screen"])
//        
//        let fullName = fullNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let mobile = mobileTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        
//        let profilePushDictionary = ["NAME": fullName,"MOBILE":mobile, "DOB":"1990-05-25"]
//        
//        //MARK:Smartech User Profile and Identity
//        
//        Smartech.sharedInstance().updateUserProfile(profilePushDictionary as [AnyHashable : Any])
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func profilePush(_ sender: UIButton) {
        
        // Validate the fields
        let error = validateFields()
        if error != nil {
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            // Create cleaned versions of the data
          
            
            // Create the user
            
//            Smartech.sharedInstance().login(email)
           
            
            
            let alert = UIAlertController(title: "Done!", message: "User Profile pushed successfully", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true)
            
        }
        
    }
    
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if fullNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            mobileTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedMail = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cleanedMail.isValidEmail == false {
            // Password isn't secure enough
            
            let alert = UIAlertController(title: "Invalid Mail/Password", message: "Please make sure your mailID and password is valid", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return "mailID is invalid"
        }
        
        return nil
    }
    
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}
