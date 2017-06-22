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
    var houseName = String()
    var houseKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        // TODO add error catch if no input has been given
        let email = userEmailInput.text
        let password = userPasswordInput.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error == nil {
                let ref = Database.database().reference()
                let currentUser = Auth.auth().currentUser
                
                // check if user is in table users
                ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? NSDictionary {
                        self.houseKey = value["houseKey"] as? String ?? ""
                        self.houseName = value["houseName"] as? String ?? ""

                        self.performSegue(withIdentifier: "toHouseVC", sender: nil)
                    }
                        
                    else {
                        self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            else{
                
                let alert = UIAlertController(title: "Login Problems",
                                              message: "This combination of username and password is not recognized",
                                              preferredStyle: .alert)
                
                // Closes alert
                let okAction = UIAlertAction(title: "OK!",
                                             style: .default) { action in
                    self.userEmailInput.text = ""
                    self.userPasswordInput.text = ""
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register with email and password",
                                      preferredStyle: .alert)
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]

            let email = emailField.text
            let password = passwordField.text
            
            // if email and or password is nil
//            let alert = UIAlertController(title: "Register Problems",
//                                          message: "Please enter an email adress and password ",
//                                          preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK!",
//                                         style: .default)
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
            
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if error == nil {
                    Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                        if error == nil {
                            // preform segue if house is present or not present
                            self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
                        }
                    }
                } else{
                    let alert = UIAlertController(title: "Register Problems",
                                                message: "Please enter a valid email adress ",
                                                preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK!",
                                                style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
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

