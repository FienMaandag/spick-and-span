//
//  NewHouseViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class NewHouseViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var userCodeInput: UITextField!
    @IBOutlet weak var userHouseInput: UITextField!
    
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout setup
        whiteBorder(button: addButton)
        whiteBorder(button: createButton)
        hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Keyboard slide up with view
    @IBAction func userHouseInputTouched(_ sender: Any) {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    // Keyboard present default
    @IBAction func userKeyInputTouched(_ sender: Any) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Add house connected to insert housekey
    @IBAction func addButtonClicked(_ sender: Any) {
        // Check for input
        guard let houseKey = userCodeInput.text, !houseKey.isEmpty else {
            simpleAlert(title: "No Input", message: "Please enter a house key", actionTitle: "ok")
            return
        }

        // Look up house in database, check for existence
        ref.child("houses").child(houseKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            guard let houseName = value?["houseName"] as? String, !houseName.isEmpty else {
                self.simpleAlert(title: "Not Founds", message: "There is no house connected to this house key", actionTitle: "ok")
                return
            }
            // Open alert for conformation
            self.addHouseAlert(houseName: houseName, houseKey: houseKey)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Create a new house
    @IBAction func createButtonClicked(_ sender: UIButton) {
        // Check for housename input
        guard let houseName = userHouseInput.text, !houseName.isEmpty else {
            simpleAlert(title: "No Input", message: "Please enter a house name", actionTitle: "ok")
            return
        }
        
        // Open conformation alert
        let alert = UIAlertController(title: "Create house",
                                      message: "Are you sure you want to create a house with the name: \(String(describing: houseName))",
                                      preferredStyle: .alert)
       
        // Create a new house, set up in firebase
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            let houseRef = self.ref.child("houses").childByAutoId()
            let userRef = self.ref.child("users").child((self.currentUser?.uid)!)
            
            let newUser = Users(totalPoints: 0,
                                userEmail: (self.currentUser?.email)!)
            
            houseRef.setValue([
                "houseName": houseName,
                "houseKey": houseRef.key,
                "users": ([
                    "\((self.currentUser?.uid)!)": newUser.toAnyObject()
                ])
            ])
            
            userRef.setValue([
                "houseKey": houseRef.key,
                "houseName": houseName])
            
            self.performSegue(withIdentifier: "toSecretCodeVC", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Conformation alert and add house to firebase
    func addHouseAlert(houseName: String, houseKey: String) {
        let alert = UIAlertController(title: "Add house",
                                      message: "Are you sure you want to add the house with the name: \(String(describing: houseName))",
            preferredStyle: .alert)
        
        // Add new house to firebase
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            let houseRef = self.ref.child("houses/\(houseKey)/users").child((self.currentUser?.uid)!)
            let userRef = self.ref.child("users").child((self.currentUser?.uid)!)
            
            let newUser = Users(totalPoints: 0,
                                userEmail: (self.currentUser?.email)!)
            
            houseRef.setValue(newUser.toAnyObject())
            
            userRef.setValue([
                "houseKey": houseKey,
                "houseName": houseName])
            
            self.performSegue(withIdentifier: "fromNewToHouseVC", sender: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
