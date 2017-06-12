//
//  Util.swift
//  spick_and_span
//
//  Created by Fien Maandag on 12-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

