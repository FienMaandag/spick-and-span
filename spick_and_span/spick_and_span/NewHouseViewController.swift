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
    
    var houseName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hallo")
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.white.cgColor
        
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.white.cgColor

        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addButtonClicked(_ sender: UIButton) {
        print("1")
        let secretCode = userCodeInput.text!
        print(secretCode)
        // TO DO add error if there is no input
        
        let ref = Database.database().reference()
        print("2")
        // HIERNA EEN UITPAK FOUT
        ref.child("houses").child(userCodeInput.text!).observeSingleEvent(of: .value, with: { (snapshot) in
            print("3")
            let value = snapshot.value as? NSDictionary
            print("4")
            self.houseName = value?["name"] as? String ?? ""
            print("5")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        let alert = UIAlertController(title: "Add house",
                                      message: "Are you sure you want to add this house with the name: \(houseName!)",
                                      preferredStyle: .alert)
        
        // Save room for house
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            // add house to user and user to house?
            
            let ref = Database.database().reference()
            let user = Auth.auth().currentUser
            
            let houseRef = ref.child("houses").child(secretCode).child("users")
            let userRef = ref.child("users").child((user?.uid)!)
            
            houseRef.updateChildValues([
                "users": ([
                    "userID": user?.uid,
                    "userEmail": user?.email,
                    "totalPoints": "0"
                    ])
                ])
            
            userRef.setValue([
                "houseKey": houseRef.key,
                "houseName": self.houseName])
            
            self.performSegue(withIdentifier: "toSecretCodeVC", sender: nil)
            
            self.performSegue(withIdentifier: "fromNewToHouseVC", sender: nil)
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func createButtonClicked(_ sender: UIButton) {
        let houseName = userHouseInput.text
        
        // add error message if no input is found
        
        let alert = UIAlertController(title: "Create house",
                                      message: "Are you sure you want to creat a house with the name: \(String(describing: houseName))",
                                      preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            let ref = Database.database().reference()
            let user = Auth.auth().currentUser
            
            let houseRef = ref.child("houses").childByAutoId()
            let userRef = ref.child("users").child((user?.uid)!)
            
            // TODO hoe kan ik de user op de id sorteren :(
            houseRef.setValue([
                "name": houseName!,
                "secret code": houseRef.key,
                "users": ([
                    "userID": user?.uid,
                    "userEmail": user?.email,
                    "totalPoints": "0"
                ])
            ])
            
            userRef.setValue([
                "houseKey": houseRef.key,
                "houseName": houseName])
            
            self.performSegue(withIdentifier: "toSecretCodeVC", sender: nil)

        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)


    }
    
}
