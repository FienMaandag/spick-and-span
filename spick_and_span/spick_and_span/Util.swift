//
//  Util.swift
//  spick_and_span
//
//  Created by Fien Maandag on 12-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIViewController {
    
    // https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func simpleAlert(title: String, message: String, actionTitle: String) {
        // Congratulate user with points
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        // Closes alert
        let action = UIAlertAction(title: actionTitle,
                                     style: .default)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func whiteBorder(button: UIButton){
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    // https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}
