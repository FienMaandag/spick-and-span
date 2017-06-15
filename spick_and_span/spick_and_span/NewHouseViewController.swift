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
        
        // TODO make a function for border settings
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.white.cgColor
        
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.white.cgColor

        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        // TODO add an if statement to check for user input
        let houseKey = userCodeInput.text!

        ref.child("houses").child(houseKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let houseName = value?["houseName"] as? String ?? ""
            
            let alert = UIAlertController(title: "Add house",
                                          message: "Are you sure you want to add the house with the name: \(String(describing: houseName))",
                preferredStyle: .alert)
            
            let addAction = UIAlertAction(title: "Add", style: .default) { action in
                
                let houseRef = self.ref.child("houses/\(houseKey)/users").child((self.currentUser?.uid)!)
                let userRef = self.ref.child("users").child((self.currentUser?.uid)!)

                houseRef.setValue([
                    "userEmail": self.currentUser?.email,
                    "totalPoints": "0"
                    ])
                
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

        
        }) { (error) in
            print(error.localizedDescription)
            print("no such house found")
        }
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        // TODO add if statement to check for user input
        let houseName = userHouseInput.text!
        
        let alert = UIAlertController(title: "Create house",
                                      message: "Are you sure you want to creat a house with the name: \(String(describing: houseName))",
                                      preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            let houseRef = self.ref.child("houses").childByAutoId()
            let userRef = self.ref.child("users").child((self.currentUser?.uid)!)
            
            houseRef.setValue([
                "houseName": houseName,
                "houseKey": houseRef.key,
                "users": ([
                    "\((self.currentUser?.uid)!)": ([
                        "userEmail": self.currentUser?.email,
                        "totalPoints": "0"
                    ])
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
    
}
