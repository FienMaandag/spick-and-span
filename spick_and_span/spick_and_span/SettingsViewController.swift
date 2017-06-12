//
//  SettingsViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        
        // log out and pop to loginviewcontoller
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //self.navigationController?.popToViewController(LoginViewController, animated: true)
    }

}
