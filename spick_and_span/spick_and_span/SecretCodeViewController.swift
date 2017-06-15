//
//  SecretCodeViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class SecretCodeViewController: UIViewController {
    
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseKeyLabel: UILabel!
    @IBOutlet weak var toHouseButton: UIButton!
    @IBOutlet weak var houseKeyField: UITextField!
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO add funtion for border settings
        toHouseButton.layer.borderWidth = 1
        toHouseButton.layer.borderColor = UIColor.white.cgColor
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let houseKey = value?["houseKey"] as? String ?? ""
            let houseName = value?["houseName"] as? String ?? ""
            
            self.houseNameLabel.text = houseName.uppercased()
            self.houseKeyLabel.text = houseKey
            self.houseKeyField.text = houseKey

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
