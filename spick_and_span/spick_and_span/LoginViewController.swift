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

    var ref = DatabaseReference()
    var currentUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout setup
        whiteBorder(button: loginButton)
        hideKeyboardWhenTappedAround()
        
        // Check if a user is signed in
        if Auth.auth().currentUser != nil {
            ref = Database.database().reference()
            currentUser = (Auth.auth().currentUser?.uid)!
            self.checkHouse()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        // Check for email and password input
        guard let email = userEmailInput.text, !email.isEmpty else {
            self.simpleAlert(title: "No Input", message: "Please enter an email adress", actionTitle: "Ok")
            return
        }
        guard let password = userPasswordInput.text, !password.isEmpty else {
            self.simpleAlert(title: "No Input", message: "Please enter a password", actionTitle: "Ok")
            return
        }
        
        // Sign in user
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.ref = Database.database().reference()
                self.currentUser = (Auth.auth().currentUser?.uid)!
                
                self.checkHouse()
            }
            else{
                self.loginProblemAlert(email: email)
                self.userPasswordInput.text = ""
            }
        }
    }

    // Register user
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register with email and password",
                                      preferredStyle: .alert)
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            // Check for email and password input
            guard let email = alert.textFields![0].text, !email.isEmpty else {
                self.simpleAlert(title: "No Input", message: "Please insert an email adres", actionTitle: "Ok")
                return
            }
            guard let password = alert.textFields![1].text, !email.isEmpty else {
                self.simpleAlert(title: "No Input", message: "Please insert a password", actionTitle: "Ok")
                return
            }
            
            // Create and sign in user
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if error == nil {
                            self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
                        }
                    }
                } else {
                    self.simpleAlert(title: "Register Problems", message: "Please enter a valid email adress and password", actionTitle: "Ok")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { email in
            email.placeholder = "Email"
            email.keyboardType = .emailAddress
        }
    
        alert.addTextField { password in
            password.placeholder = "Password"
            password.isSecureTextEntry = true
        }
        
        alert.addAction(registerAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Check if user is connected to a house and preform corresonding segue
    func checkHouse(){
        self.ref.child("users").child(self.currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? NSDictionary) != nil {
                self.performSegue(withIdentifier: "toHouseVC", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
            }
        }) { (error) in
            self.simpleAlert(title: "No User Found", message: "You are not logged in, please log in", actionTitle: "Ok")
            print(error.localizedDescription)
        }
    }
    
    // Alert when impossible to sign user in, with possibility to reset password
    func loginProblemAlert(email: String) {
        let alert = UIAlertController(title: "Login Problems", message: "This combination of username and password is not recognized", preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default)
        
        let resetAction = UIAlertAction(title: "Reset Password", style: .default) { action in
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            }
        }
        
        alert.addAction(tryAgainAction)
        alert.addAction(resetAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

