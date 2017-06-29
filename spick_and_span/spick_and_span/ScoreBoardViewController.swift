//
//  ScoreBoardViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class ScoreBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var houseKey = String()
    var users: [Users] = []
    
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Look up housekey for current user
        ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            
            self.loadUsers()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath as IndexPath) as! HighScoreTableViewCell
        
        // Set name from email as user label
        let userEmail = users[indexPath.row].userEmail
        var user = userEmail.components(separatedBy: "@")
        cell.userLabel.text = user[0]
        cell.pointsLabel.text = String(users[indexPath.row].totalPoints)
        return cell
    }
    
    // Load users for house from Firebase
    func loadUsers(){
        
        let searchRef = ref.child("houses/\(self.houseKey)/users").queryOrdered(byChild: "totalPoints")
        
        searchRef.observe(.value, with: { snapshot in
            var newUsers: [Users] = []
            
            for item in snapshot.children {
                let user = Users(snapshot: item as! DataSnapshot)
                newUsers.append(user)
            }
            
            self.users = newUsers.reversed()
            self.tableView.reloadData()
        })
    }
}
