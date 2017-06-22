//
//  Users.swift
//  spick_and_span
//
//  Created by Fien Maandag on 20-06-17.
//  Copyright © 2017 Fien Maandag. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    
    let totalPoints: Int
    let userEmail: String
    
    init(totalPoints: Int, userEmail: String) {
        self.totalPoints = totalPoints
        self.userEmail = userEmail
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        totalPoints = snapshotValue["totalPoints"] as! Int
        userEmail = snapshotValue["userEmail"] as! String
    }
}
