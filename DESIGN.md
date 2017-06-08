# Design Document
In this document the technical design of the app Spick and Span will be discussed

# Firebase
This app will use the database Firebase  
{
  "houses": {  
    "secretCode1": {  
      "secretCode" : "secretCode1"  
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
    }
  }  
  "History" : {  
    "secretCode1": {  
      "task" : "vacuum",  
      "doneBy" : "user1",  
      "time" : "timestamp"  
    },  
    "secretCode2": {  
      "task" : "dust",  
      "doneBy" : "user2",  
      "time" : "timestamp"  
    }
  }  
  "Users" : {  
    "userEmail" : "email",  
    "totalPoints" : "100"  
  }
}  


# View Controllers Overview
- LoginViewController:  
  This view controller needs to be able to send user email and user password.
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
