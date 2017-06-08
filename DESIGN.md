# Design Document
In this document the technical design of the app Spick and Span will be discussed.
It still has to be figured out how to calculate the priority of the rooms.

# Firebase
This app will use the database Firebase which will be structured in the following way:

``` JSON
{
  "houses": {  
    "secretCode1": {  
      "secretCode" : "secretCode1",
      "name": "Baasje G",  
      "rooms": {  
        "roomName": "LivingRoom",  
        "roomPriority" : "?",  
        "tasks": {  
          "taskName" : "Vacuum",  
          "taskFrequency" : "5",  
          "taskPoints" : "2",  
          "taskDone" : "timestamp",  
          "taskPriority" : "?"  
        },
      },
      "history": {
        "doneBy" : "user1",
        "task" : "vacuum",
        "time" : "timestamp"
      }
    }
  },    
  "Users" : {
    "userID" : {  
      "userEmail" : "email",  
      "totalPoints" : "100",
      "secretCode" : "fajsdhfl"
    }
  }
}  
```

# View Controllers Overview

all view controllers are linked to a similarly named view.

- LoginViewController:  
  Be able to send: User email, user password.
- HouseViewController:  
  Have access to: House name, rooms in the house and corresponding priority levels.  
  Be able to send: A new room name.
- RoomViewController:  
  Have access to: Room name, tasks for room and priority levels.  
  Be able to send:  
    For saving a new task: Task name with corresponding frequency level and points.  
    For updating a task done: Priority level. And username, task, time and points earned.  
- NewHouseViewController:  
  Have access to: House name.  
  Be able to send: Secret code or new room name.
- SecretCodeViewController:  
  Have access to: House name and secret code
- HistoryViewController:  
  Have access to: All tasks preformed, by which user, at what time
- ScoresViewController:
  Have access to: All users of the house with corresponding total points
- SettingsViewController:
  Have access to: Secret code, house name and current user

# Struct
Within the Xcode project several structs will be created to represent the data from firebase.
- User
  - userID: String
  - userEmail: String
  - totalPoints: Int
  - houseSecretCode: String

- House
  - houseSecretCode: String
  - name: String

- Rooms
  - roomName: String
  - roomPriority: String

- Tasks
  - taskName: String
  - taskFrequency: Int
  - taskPoints: Int
  - taskDone: Timestamp
  - taskPriority: Int

 - History
   - userEmail: String
   - task: String
   - time: Timestamp
