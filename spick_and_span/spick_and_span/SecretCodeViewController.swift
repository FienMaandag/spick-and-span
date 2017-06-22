//
//  SecretCodeViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SecretCodeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var houseKeyLabel: UILabel!
    @IBOutlet weak var toHouseButton: UIButton!
    
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

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMailButtonClicked(_ sender: Any) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody("<p>Heey you, join <b>\(houseNameLabel.text!)</b> by copying this secret code: <b>\(houseKeyLabel.text!)</b> and add it in the SPICK-and-SPAN app</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
