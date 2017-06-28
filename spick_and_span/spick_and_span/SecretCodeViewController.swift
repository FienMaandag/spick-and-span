//
//  SecretCodeViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase
import Social

class SecretCodeViewController: UIViewController {
    
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseKeyLabel: UILabel!
    @IBOutlet weak var toHouseButton: UIButton!
    
    let userID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout setup
        whiteBorder(button: toHouseButton)
        
        // Get current users housekey and housename
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let houseKey = value?["houseKey"] as? String ?? ""
            let houseName = value?["houseName"] as? String ?? ""
            
            self.houseNameLabel.text = houseName.uppercased()
            self.houseKeyLabel.text = houseKey
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Share the housekey
    @IBAction func shareButtonClicked(_ sender: Any) {
        let message = "Join \(String(describing: self.houseNameLabel.text!)) with the housekey: \(String(describing: self.houseKeyLabel.text!))"
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [message], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
