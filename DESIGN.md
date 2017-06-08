# Design Document
In this document the technical design of the app Spick and Span will be discussed

# Firebase
This app will use the data base Firebase

View Controllers Overview
- LoginViewController:\n
  This view controller needs to be able to send user email and user password.
- HouseViewController:\n
  Have access to: House name, rooms in the house and corresponding priority levels.
  Be able to send: A new room name.
- RoomViewController:\n
  Have access to: Room name, tasks for room and priority levels.\n
  Be able to send:\n
    For saving a new task: Task name with corresponding frequency level and points.\n
    For updating a task done: Priority level. And username, task, time and points earned.
- AddHouseViewController:\n
  Have access to: House name.\n
  Be able to send: Secret code or new room name.
- NewHouseViewController:\n
  Have access to: House name and secret code\n
