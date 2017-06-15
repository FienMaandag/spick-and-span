//
//  Rooms.swift
//  spick_and_span
//
//  Created by Fien Maandag on 15-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct Rooms {
    
    let key: String
    let ref: DatabaseReference?
    let addedByUser: String
    let priority: String
    
    init(addedByUser: String, key: String = "", priority: String = "") {
        self.key = key
        self.ref = nil
        self.addedByUser = addedByUser
        self.priority = priority
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        addedByUser = snapshotValue["addedByUser"] as! String
        priority = snapshotValue["priority"] as? String ?? ""
    }
    
    func toAnyObject() -> Any {
        return [
            "addedByUser": addedByUser,
            "priority": priority,
        ]
    }
    
}

