//
//  LoginViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 06-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register with email and password",
                                      preferredStyle: .alert)
        
        // Save room for house
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            let email = emailField.text
            let password = passwordField.text
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if error == nil {
                    // sign in 
                    // preform segue if house is present or not present
                    self.performSegue(withIdentifier: "toHouseVC", sender: nil)
                }
            }
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { email in
            email.placeholder = "Email"
        }
        
        alert.addTextField { password in
            password.placeholder = "Password"
        }
        
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

