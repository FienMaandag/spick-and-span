
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
    
    var houseKey = String()
    var roomName = String()
    var newTotalPoints = Int()
    
    var tasks :[Tasks] = []
    let ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.roomName

        ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            
            self.loadTasks()
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadTasks(){
        
        let searchRef = ref.child("houses/\(self.houseKey)/rooms/\(roomName)/tasks")
        
        searchRef.observe(.value, with: { snapshot in
            var newTasks: [Tasks] = []
            
            for item in snapshot.children {
                let task = Tasks(snapshot: item as! DataSnapshot)
                newTasks.append(task)
            }
            
            self.tasks = newTasks
            self.tableView.reloadData()
        })

    }
    
    // Set amount rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath as IndexPath) as! TaskTableViewCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].taskName.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in

            let indexPath = editActionsForRowAt
            let selectedTask = self.tasks[indexPath.row].taskName

            let date = NSDate();
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
            let today = formatter.string(from: date as Date);

            // update history
            let historyRef = self.ref.child("houses/\(self.houseKey)/history/\(today)")

            let newHistory = History(
                                doneBy: (self.currentUser?.email)!!,
                                task: selectedTask,
                                time: today)
            
            historyRef.setValue(newHistory.toAnyObject())
            
            // update firebase total points
            let userRef = self.ref.child("houses/\(self.houseKey)/users/\(self.currentUser?.uid)")
            let pointsRef = self.ref.child("houses/\(self.houseKey)/rooms/\(self.roomName)/tasks/\(selectedTask)")
            
            pointsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let taskPoints = value?["taskPoints"] as? Int
                
                self.newTotalPoints = taskPoints!
            }) { (error) in
                print(error.localizedDescription)
            }
            
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let totalPoints = value?["totalPoints"] as? Int ??
                
                let points = self.newTotalPoints as! Int
                self.newTotalPoints = points + totalPoints
            }) { (error) in
                print(error.localizedDescription)
            }

            print(self.newTotalPoints)
            
            // update priority level task
            let taskRef = self.ref.child("houses/\(self.houseKey)/rooms/\(self.roomName)/tasks/\(selectedTask)/taskDone")
            
            taskRef.setValue(today)
        }
        done.backgroundColor = .lightGray
        
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
            
            let taskName = taskNameField.text! 
            let taskFrequency = taskFrequencyField.text
            let taskPoints = taskPointsField.text
            
            let roomRef = self.ref.child("houses/\(self.houseKey)/rooms/\(self.roomName)/tasks/\(String(describing: taskName))")
            
            // add room to firebase
            let newTask = Tasks(taskDone: "",
                                taskFrequency: taskFrequency!,
                                taskName: taskName,
                                taskPoints: taskPoints!,
                                taskPriority: "")
                
            roomRef.setValue(newTask.toAnyObject())
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
