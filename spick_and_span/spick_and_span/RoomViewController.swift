
//
//  RoomViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit
import Firebase

class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var tasks = ["Vacuum", "Dust"]
    let ref = Database.database().reference()
    var houseKey = String()
    var roomName = String()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.roomName

        ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            
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
        return self.tasks.count
    }
    
    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath as IndexPath) as! TaskTableViewCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            // update firebase history
            let indexPath = editActionsForRowAt
            print(indexPath)
            let historyRef = self.ref.child("houses/\(self.houseKey)/history/\(Date())")
            let selectedTask = self.tasks[indexPath.row]
            print(selectedTask)
            
            historyRef.setValue([
                "doneBy": self.currentUser?.email,
                "task": selectedTask,
                "time": Date()
                ])
            
            // update firebase total points
            // update priority level task
        }
        done.backgroundColor = .white
        
        return [done]
    }
    
    @IBAction func addTaskButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Task",
                                      message: "Configure a new task",
                                      preferredStyle: .alert)
        
        // Save room for house
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let taskNameField = alert.textFields![0]
            let taskFrequencyField = alert.textFields![1]
            let taskPointsField = alert.textFields![2]
            
            let taskName = taskNameField.text
            let taskFrequency = taskFrequencyField.text
            let taskPoints = taskPointsField.text
            
            let roomRef = self.ref.child("houses/\(self.houseKey)/rooms/\(self.roomName)/tasks/\(String(describing: taskName))")
            
            roomRef.setValue([
                "taskName": taskName,
                "taskFrequency": taskFrequency,
                "taskPoints": taskPoints,
                "taskDone": "",
                "taskPriority": ""
                ])
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { taskName in
            taskName.placeholder = "Task Name"
        }
        
        alert.addTextField { taskFrequency in
            taskFrequency.placeholder = "Task Frequency"
        }
        
        alert.addTextField { taskPoints in
            taskPoints.placeholder = "Task Points"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
