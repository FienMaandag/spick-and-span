//
//  HouseViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit

class HouseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var rooms = ["living room", "bathroom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms.count
    }
    
    // Fill cells of tableview with rooms
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RoomsCell", for: indexPath as IndexPath) as! RoomTableViewCell
        
        cell.roomNameLabel.text = rooms[indexPath.row].uppercased()
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
            
            // update firebase
            // let plant = self.plants[indexPath.row]
            // self.ref.updateChildValues([
            //    "\(plant.key)/nickname" : text
            //    ])
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
