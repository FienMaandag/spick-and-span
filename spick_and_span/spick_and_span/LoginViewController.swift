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
    var ref = DatabaseReference()
    var currentUser: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
        
        self.hideKeyboardWhenTappedAround()
        
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

        let email = userEmailInput.text
        let password = userPasswordInput.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
            if error == nil {
                self.ref = Database.database().reference()
                self.currentUser = (Auth.auth().currentUser?.uid)!
                
                self.checkHouse()
            }
            else{
                self.simpleAlert(title: "Login Problems", message: "This combination of username and password is not recognized", actionTitle: "Ok")
                
                self.userEmailInput.text = ""
                self.userPasswordInput.text = ""
            }
        }
    }
    
    func checkHouse(){
        // check if user is in table users
        self.ref.child("users").child(self.currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                self.houseKey = value["houseKey"] as? String ?? ""
                self.houseName = value["houseName"] as? String ?? ""
                
                self.performSegue(withIdentifier: "toHouseVC", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toNewHouseVC", sender: nil)
            }
        }) { (error) in
            self.simpleAlert(title: "No User Found", message: "You are not logged in, please log in", actionTitle: "Ok")
            print(error.localizedDescription)
        }
    }

    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register with email and password",
                                      preferredStyle: .alert)
        
        let registerAction = UIAlertAction(title: "Register", style: .default) { action in
            guard let email = alert.textFields![0].text, !email.isEmpty else {
                self.simpleAlert(title: "No Input", message: "Please insert an email adres", actionTitle: "Ok")
                return
            }
            guard let password = alert.textFields![1].text, !email.isEmpty else {
                self.simpleAlert(title: "No Input", message: "Please insert a password", actionTitle: "Ok")
                return
            }
            
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

