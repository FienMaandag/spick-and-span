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
    @IBOutlet weak var userEmailInput: UITextField!
    @IBOutlet weak var userPasswordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        // add error catch if no input has been given
        let email = userEmailInput.text
        let password = userPasswordInput.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error == nil {
                // preform segue if house is present or not present
                self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
            }
            // add else error statement not able to sign in
        }
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
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        if error == nil {
                            // preform segue if house is present or not present
                            self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
                        }
                    }
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
            password.isSecureTextEntry = true
        }
        
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}

