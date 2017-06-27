//
//  SettingsViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var leaveHouseButton: UIButton!
    @IBOutlet weak var secretCodeLabel: UILabel!
    
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser?.uid
    
    var houseKey = String()
    var houseName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteBorder(button: logOutButton)

        // find current houseKey to remove user from it
        ref.child("users").child(currentUser!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            self.houseName = value?["houseName"] as? String ?? ""
            self.secretCodeLabel.text = value?["houseKey"] as? String ?? ""
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        let message = "Join \(String(describing: self.houseName)) with the housekey: \(String(describing: self.houseKey)))"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [message], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func leaveHouseButtonClicked(_ sender: UIButton) {
        
        // remove from firebase
        ref.child("houses/\(houseKey)/users/\(currentUser!)").removeValue()
        ref.child("users/\(currentUser!)").removeValue()
        
        // return to startscreen
        self.performSegue(withIdentifier: "fromSettingsToLoginVC", sender: nil)
    }
    
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        
        // log out and return to startscreen
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "fromSettingsToLoginVC", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}
