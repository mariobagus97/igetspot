//
//  HandlingKeyboard.swift
//  mnc-igetspot-ios
//
//  Created by destanti fatwakhyuni on 10/4/18.
//  Copyright © 2018 InnoCent Bandung. All rights reserved.
//

import Foundation
import UIKit

class HandlingKeyboard {
    
    func handleKeyboard(observer: Any){
        showKeyboard(observer: observer)
        hideKeyboard(observer: observer)
    }
    
    func showKeyboard(observer: Any) {
        NotificationCenter.default.addObserver(observer, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func hideKeyboard(observer: Any) {
        NotificationCenter.default.addObserver(observer, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // move up and down keyboard function
    
    @objc func keyboardWillShow(observer: Any, notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (observer as AnyObject).view.frame.origin.y == 0{
                (observer as AnyObject).view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(observer: Any, notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (observer as AnyObject).view.frame.origin.y != 0{
                (observer as AnyObject).view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
