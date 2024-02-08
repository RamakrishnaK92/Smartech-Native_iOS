//
//  Utilities.swift
//  Smartech Demo
////

import Foundation
import UIKit

class Utilities {
    
    
    
    static func styleTextField(_ textfield:UITextField) {
        
        var customFont = UIFont(name: "Trueno", size: UIFont.labelFontSize)
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width-4, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        textfield.font = customFont
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button: UIButton) {
        var customFont = UIFont(name: "Trueno", size: UIFont.labelFontSize)
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 22.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        var customFont = UIFont(name: "Trueno", size: UIFont.labelFontSize)
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 22.0
        UIButton.appearance().titleLabel?.font = customFont
        //        button.tintColor = UIColor.white
        
    }
    
    
}
//Extension for string to validate email and phone number
extension String
{
    
    var isValidEmail: Bool
    {
        let nameRegularExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegularExp)
        return nameTest.evaluate(with: self)
    }
    
    var isValidPhone: Bool
    {
        let nameRegularExp = "^[0-9]{10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegularExp)
        return nameTest.evaluate(with: self)
        
    }
    var isValidPassword: Bool{
        //            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        let nameRegularExp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegularExp)
        return nameTest.evaluate(with: self)
    }
    
    
}


extension String{
    func isUserLoggedIn(){
    }
}

enum DeeplinkEnum:String{
    case Product
    case NotifVC
    
}
