//
//  HistoryViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var history: [History] = []
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    var houseKey = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref.child("users/\((currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            
            self.loadHistory()
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath as IndexPath) as! HistoryTableViewCell
        
        let doneBy = history[indexPath.row].doneBy
        var doneByUser = doneBy.components(separatedBy: "@")
        
        cell.activityLabel.text = history[indexPath.row].task
        cell.userLabel.text = doneByUser[0]
        return cell
    }
    
    func loadHistory(){
        
        let searchRef = ref.child("houses/\(self.houseKey)/history")
        
        searchRef.observe(.value, with: { snapshot in
            var newHistory: [History] = []
            
            for item in snapshot.children {
                let activity = History(snapshot: item as! DataSnapshot)
                newHistory.append(activity)
            }
            
            self.history = newHistory
            self.tableView.reloadData()
        })
        
    }



}
