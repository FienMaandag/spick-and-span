//
//  HouseViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class HouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var houseName = String()
    var houseKey = String()
    
    var rooms: [Rooms] = []

    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseName = value?["houseName"] as? String ?? ""
            self.houseKey = value?["houseKey"] as? String ?? ""
            
            self.navigationItem.title = self.houseName
            
            self.loadRooms()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadRooms(){
        
        let searchRef = ref.child("houses/\(self.houseKey)/rooms)")
        
        // View plants from current user
        searchRef.observe(.value, with: { snapshot in
            print("1")
            var newRooms: [Rooms] = []
            
            for item in snapshot.children {
                print("2")
                let room = Rooms(snapshot: item as! DataSnapshot)
                print(room)
                newRooms.append(room)
                print(newRooms)
            }
            self.rooms = newRooms
            self.tableView.reloadData()
        }) { (error) in
            print("Failed to get snapshot", error.localizedDescription)
        }
    }
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    // Fill cells of tableview with rooms
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RoomsCell", for: indexPath as IndexPath) as! RoomTableViewCell
        
        cell.roomNameLabel.text = rooms[indexPath.row].addedByUser.uppercased()
        return cell
    }
    
    @IBAction func addRoomButtonClicked(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(title: "New Room",
                                      message: "Choose a name for your room",
                                      preferredStyle: .alert)
        
        // Save room for house
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let roomNameField = alert.textFields![0]
            let text = roomNameField.text
            
            // add room to firebase
            
            let houseRef = self.ref.child("houses/\(self.houseKey)/rooms/\(text!)")
            
            houseRef.setValue([
                "addedByUser": self.currentUser?.uid,
                "priority": "0"
                ])
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { roomName in
            roomName.placeholder = "Room Name"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

}
