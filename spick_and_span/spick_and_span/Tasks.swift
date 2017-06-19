//
//  Tasks.swift
//  spick_and_span
//
//  Created by Fien Maandag on 15-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct Tasks {
    
    let taskDone: String
    let taskFrequency: String
    let taskName: String
    let taskPoints: String
    let taskPriority: String
    
    init(taskDone: String, taskFrequency: String, taskName: String, taskPoints: String, taskPriority: String) {
        self.taskDone = taskDone
        self.taskFrequency = taskFrequency
        self.taskName = taskName
        self.taskPoints = taskPoints
        self.taskPriority = taskPriority

    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        taskDone = snapshotValue["taskDone"] as! String
        taskFrequency = snapshotValue["taskFrequency"] as! String
        taskName = snapshotValue["taskName"] as! String
        taskPoints = snapshotValue["taskPoints"] as! String
        taskPriority = snapshotValue["taskPriority"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "taskDone": taskDone,
            "taskFrequency": taskFrequency,
            "taskName": taskName,
            "taskPoints": taskPoints,
            "taskPriority": taskPriority
        ]
    }
    
}

