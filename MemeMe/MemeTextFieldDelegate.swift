//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Troutslayer33 on 5/10/15.
//  Copyright (c) 2015 Troutslayer33. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // function converts all text input to uppercase
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        textField.text = newText.uppercaseString
        return false
    }
    
    // if text fields set to default value clear input
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField.text == "BOTTOM" || textField.text == "TOP") {
            textField.text = nil
        }
        return true
    }
    
    // resign first responder when return
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

