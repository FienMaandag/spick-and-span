
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
    var priorityLevel = Int()
    
    var tasks :[Tasks] = []
    var ref = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.roomName
        
        // Lookup housekey for current user
        ref.child("users").child((currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.houseKey = value?["houseKey"] as? String ?? ""
            
            self.ref = Database.database().reference().child("houses/\(self.houseKey)")
            
            self.loadTasks()
            
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
        return tasks.count
    }

    
    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath as IndexPath) as! TaskTableViewCell
        
        // Check if task is already done and set priority level accordingly
        if tasks[indexPath.row].taskDone != ""{
            let lastDone = tasks[indexPath.row].taskDone
            let lastDoneDouble = TimeInterval(lastDone)
            
            let lastDoneDate = Date(timeIntervalSince1970: lastDoneDouble!)
            let currentData = Date()
            
            let sinceDone = DateInterval(start: lastDoneDate, end: currentData).duration
            let frequency = tasks[indexPath.row].taskFrequency
            
            var priority = (Float(sinceDone) / Float(frequency)) * 100
            
            if frequency == 0 {
                priority = 0
            }
            
            self.priorityLevel = Int(priority)

        } else {
            self.priorityLevel = 100
        }
        
        // Set color for priority level that has been caculated
        if 0 ... 25 ~= self.priorityLevel{
            cell.priorityTaskLabel.text = "LOW"
            cell.priorityTaskLabel.textColor = UIColor.green
        }
        else if 25 ... 75 ~= self.priorityLevel{
            cell.priorityTaskLabel.text = "MEDIUM"
            cell.priorityTaskLabel.textColor = UIColor.orange
        }
        else if 75 ... 100 ~= self.priorityLevel{
            cell.priorityTaskLabel.text = "HIGH"
            cell.priorityTaskLabel.textColor = UIColor.red
        }
        else {
            cell.priorityTaskLabel.text = "NOW"
            cell.priorityTaskLabel.textColor = UIColor.red
        }
        
        cell.taskNameLabel.text = tasks[indexPath.row].taskName.uppercased()

        return cell
    }
    
    // Load tasks from Firebase
    func loadTasks(){
        
        let searchRef = ref.child("rooms/\(roomName)/tasks")
        
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
    
    // done button
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in

            // Save variables
            let indexPath = editActionsForRowAt
            let selectedTask = self.tasks[indexPath.row].taskName
            let taskPoints = self.tasks[indexPath.row].taskPoints
            let userID = self.currentUser?.uid
            let userEmail = self.currentUser?.email

            // Save current data as string
            let date = Date()
            let today = date.timeIntervalSince1970
            let stringToday = String(today)
        
            // Name for child
            var todayChild = stringToday.components(separatedBy: ".")
            
            // Update history
            let historyRef = self.ref.child("history/\(todayChild[0])")
            let newHistory = History(
                                doneBy: userEmail!,
                                task: selectedTask,
                                time: stringToday)
            historyRef.setValue(newHistory.toAnyObject())
            
            // Update priority task done
            let taskRef = self.ref.child("rooms/\(self.roomName)/tasks/\(selectedTask)/taskDone")
            taskRef.setValue(stringToday)
            
            // Update total points
            let usersRef = self.ref.child("users")
            
            usersRef.child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                
                let points = value?["totalPoints"] as? Int ?? 0
                
                let newTotal = taskPoints + points
                usersRef.child("\(userID!)/totalPoints").setValue(newTotal)
                

            }) { (error) in
                print(error.localizedDescription)
            }
            
            // Congratulate user with points
            self.simpleAlert(title: "Points", message: "You've earned \(taskPoints) points!", actionTitle: "Jeeh!")
        }
        done.backgroundColor = .green
        
        return [done]
    }
    
    // Add a new task
    @IBAction func addTaskButtonClicked(_ sender: UIBarButtonItem) {
        
        // Open alert to create new task
        let alert = UIAlertController(title: "New Task",
                                      message: "Configure a new task",
                                      preferredStyle: .alert)
        
        // Save room for house
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            guard let taskNameField = alert.textFields![0].text, !taskNameField.isEmpty else{
                self.simpleAlert(title: "No Input", message: "Please enter a task Name", actionTitle: "ok")
                return
            }
            
            // Check for user input
            guard let taskFrequencyField = alert.textFields![1].text, !taskFrequencyField.isEmpty else{
                self.simpleAlert(title: "No Input", message: "Please enter a task frequency", actionTitle: "ok")
                return
            }
            guard let taskPointsField = alert.textFields![2].text, !taskPointsField.isEmpty else{
                self.simpleAlert(title: "No Input", message: "Please enter the task points", actionTitle: "ok")
                return
            }

            // Save name, frequency and points
            let taskName = taskNameField.capitalized
            let taskFrequency = Int(taskFrequencyField)! * 86400
            let taskPoints = Int(taskPointsField)
            
            let roomRef = self.ref.child("rooms/\(self.roomName)/tasks/\(String(describing: taskName))")
                
            // add room to firebase
            let newTask = Tasks(taskDone: "",
                                taskFrequency: taskFrequency,
                                taskName: taskName,
                                taskPoints: taskPoints!)
                
            roomRef.setValue(newTask.toAnyObject())
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { taskName in
            taskName.placeholder = "Task Name"
        }
        
        alert.addTextField { taskFrequency in
            taskFrequency.placeholder = "Once Every .. Days"
            taskFrequency.keyboardType = .numberPad
        }
        
        alert.addTextField { taskPoints in
            taskPoints.placeholder = "Task Points"
            taskPoints.keyboardType = .numberPad
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
