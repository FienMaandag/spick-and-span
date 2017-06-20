//
//  History.swift
//  spick_and_span
//
//  Created by Fien Maandag on 19-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct History {
    
    let doneBy: String
    let task: String
    let time: String
    
    init(doneBy: String, task: String, time: String) {
        self.doneBy = doneBy
        self.task = task
        self.time = time
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        doneBy = snapshotValue["doneBy"] as! String
        task = snapshotValue["task"] as! String
        time = snapshotValue["time"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "doneBy": doneBy,
            "task": task,
            "time": time
        ]
    }
    
}

