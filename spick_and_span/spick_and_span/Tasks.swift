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
    let taskFrequency: Int
    let taskName: String
    let taskPoints: Int
    
    init(taskDone: String, taskFrequency: Int, taskName: String, taskPoints: Int) {
        self.taskDone = taskDone
        self.taskFrequency = taskFrequency
        self.taskName = taskName
        self.taskPoints = taskPoints

    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]

        taskDone = snapshotValue["taskDone"] as! String
        taskFrequency = snapshotValue["taskFrequency"] as! Int
        taskName = snapshotValue["taskName"] as! String
        taskPoints = snapshotValue["taskPoints"] as! Int
    }
    
    func toAnyObject() -> Any {
        return [
            "taskDone": taskDone,
            "taskFrequency": taskFrequency,
            "taskName": taskName,
            "taskPoints": taskPoints
        ]
    }
    
}

