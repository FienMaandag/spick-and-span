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
    @IBOutlet weak var secretCodeLabel: UILabel!
    @IBOutlet weak var toHouseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toHouseButton.layer.borderWidth = 1
        toHouseButton.layer.borderColor = UIColor.white.cgColor
        
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let secretCode = value?["houseKey"] as? String ?? ""
            let houseName = value?["houseName"] as? String ?? ""
            
            self.houseNameLabel.text = houseName.uppercased()
            self.secretCodeLabel.text = secretCode

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
