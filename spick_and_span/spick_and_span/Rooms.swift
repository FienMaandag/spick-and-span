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
    let nameRoom: String
    let addedByUser: String
    
    init(addedByUser: String, key: String = "", nameRoom: String) {
        self.key = key
        self.ref = nil
        self.addedByUser = addedByUser
        self.nameRoom = nameRoom
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let snapshotValue = snapshot.value as! [String: AnyObject]
        addedByUser = snapshotValue["addedByUser"] as! String
        nameRoom = snapshotValue["nameRoom"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "nameRoom": nameRoom,
            "addedByUser": addedByUser,
        ]
    }
    
}

