# Design Document
In this document the technical design of the app Spick and Span will be discussed

# Firebase
This app will use the data base Firebase

View Controllers Overview
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
- AddHouseViewController:
  Have access to: House name.
  Be able to send: Secret code or new room name.
- NewHouseViewController:
  Have access to: House name and secret code
