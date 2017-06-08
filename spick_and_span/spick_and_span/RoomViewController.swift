//
//  RoomViewController.swift
//  spick_and_span
//
//  Created by Fien Maandag on 07-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var tasks = ["Vacuum", "Dust"]
    
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
        return self.tasks.count
    }
    
    // Fill cells of tableview with tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 	{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath as IndexPath) as! TaskTableViewCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].uppercased()
        return cell
    }
    
    @IBAction func addTaskButtonClicked(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Task",
                                      message: "Choose a name for this task",
                                      preferredStyle: .alert)
        
        // Save room for house
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            let taskNameField = alert.textFields![0]
            let text = taskNameField.text
            
            // update firebase
            // let plant = self.plants[indexPath.row]
            // self.ref.updateChildValues([
            //    "\(plant.key)/nickname" : text
            //    ])
        }
        
        // Closes alert
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { taskName in
            taskName.placeholder = "Task Name"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    

    
}
