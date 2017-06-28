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
        
        // Lookup housekey and name for current user
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
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    // Fill cells of tableview with rooms
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RoomsCell", for: indexPath as IndexPath) as! RoomTableViewCell
        
        cell.roomNameLabel.text = rooms[indexPath.row].nameRoom.uppercased()
        return cell
    }
    
    // Load rooms for current house
    func loadRooms(){
        let searchRef = ref.child("houses/\(self.houseKey)/rooms")
        
        searchRef.observe(.value, with: { snapshot in
            var newRooms: [Rooms] = []
            
            for item in snapshot.children {
                let room = Rooms(snapshot: item as! DataSnapshot)
                newRooms.append(room)
            }
            
            self.rooms = newRooms
            self.tableView.reloadData()
        })
    }
    
    // Add a new room
    @IBAction func addRoomButtonClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Room",
                                      message: "Choose a name for your room",
                                      preferredStyle: .alert)
        
        // Save room for house
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let roomNameField = alert.textFields![0].text, !roomNameField.isEmpty else{
                self.simpleAlert(title: "No Input", message: "Please enter a room name", actionTitle: "ok")
                return
            }
            let text = roomNameField.capitalized
            
            // add room to firebase
            let newRoom = Rooms(addedByUser: (self.currentUser?.uid)!,
                                nameRoom: text)
            let houseRef = self.ref.child("houses/\(self.houseKey)/rooms/\(text)")

            houseRef.setValue(newRoom.toAnyObject())
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let roomVC = segue.destination as? RoomViewController{
            if let path = tableView.indexPathForSelectedRow{
                roomVC.roomName = self.rooms[path.row].nameRoom
            }
        }
    }
}
