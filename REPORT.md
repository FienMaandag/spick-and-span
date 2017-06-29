# Report about Spick-and-Span by Fien Maandag

## Short Description
Spick-and-Span is an app for people who share a household. It helps the user keep track of what tasks need to be done in the house and who’s turn it is to do some tasks. The user can create a house with rooms, tasks for each room and assigning a frequency and points to each task. It is a positively orientated solution for a schedule on paper. It is positively orientated because it does not force anyone to do certain tasks at certain moments but instead positively reinforces people for doing tasks. Spick-and-Span is also an improvement relative to a paper schedule since it gives the opportunity to do the tasks in the house that you prefer, give more exact information about which tasks need to be done and provides a clear overview of the tasks done and by who they are done.

## Technical Design

### General
Module Firebase: This app uses Firebase in all its views. It used for authentication, saving data and retrieving data.
Extension UIViewContorller:
- whiteBorder(button): Sets the border of a button to white.
- hideKeyboardWhenTappedAround(): Hides keyboard when background is tapped.
- simpleAlert(title, message, actionTitle): Shows a simple alert with the inserted text that has one button.

### Login View Controller
This view is shown when currently no user has been logged in.
#### Features
This view provides the user with the possibility to login or register. Within the login functionality it is also possible to reset the password.
#### Functions, Struct’s and Classes
- checkHouse(): Checks if the user is connected to a house and preforms the correct segue.
- loginButtonClicked(): Login user with use of firebase and preforms appropriate segue. If impossible to login calls loginProblemAlert().
- loginProblemAlert(email): Alert user of incorrect combination of email and password provides the user to reset password through sending an email.
- registerButtonClicked(): Register user with email and password. If registration is completed directly signs in the user.  

### New House View Controller
This view is shown if the current user is not connected to a house.
#### Features
This view provides the user with the possibility to add an existing house with the use of a secret code or to create a house by inserting a house name.
#### Functions, Struct’s and Classes
- userHouseInputTouched(): Set the settings for showing the keyboard to sliding up with the view. This function is called when the house input field is selected.
- userKeyInputTouched(): Set the settings for showing the keyboard in the default way, sliding over the view. This function is called when the key input field is selected.
- addButtonClicked(): Finds house connected to house key, if not found the user is alerted to this, if the house exists the addHouseAlert() is called.
- addHouseAlert(houseName, houseKey): Checks if the user wants to add this house, updates the users child and the house child to the newly added user. Also performs a segue to the houseView.  
- createButtonClicked(): Checks if the user is sure about creating this house, creates the house child in firebase and preforms a segue to the secretCodeView.

### Secret Code View Controller
This view is shown if the user created a new house.
#### Features
This view provides the user with information on how to share access to the created house. It also provides the possibility to share this information with other people.
#### Functions, Struct’s and Classes
- shareButtonClicked(): shows an activityViewController with the option to share the house key with an explaining message.

### House View Controller
This view is shown when the user is already connected to a house.
#### Features
This view provides the user with an overview of the rooms in the house and the possibility to add a room.
#### Functions, Struct’s and Classes
- rooms: [Rooms]: A struct that represents the room information in Firebase, this contains the name and by which user it is added.
- loadRooms(): Loads the rooms that are in firebase for this house, appends them to a local list and reloads the table view.
- addRoomButtonClicked(): Opens alert where the user can insert a room name, this is saved to the firebase.

### Room View Controller
This view is shown if the user selects a room in the house view controller.
#### Features
This view shows the tasks that need to be done in the selected room with the corresponding priority level. It is also possible to create new tasks with corresponding information about the frequency and points of the tasks and to set a task to done.
#### Functions, Struct’s and Classes
- tasks: [Tasks]: A struct that represents the task information in Firebase, this contains the name, frequency, points and when lastly done.
- loadTasks(): Loads the tasks that are saved in Firebase for the selected room, appends them to a local list tasks and reloads the table view.
- priority calculation
- donebutton
- addTaskButtonClicked(): Opens an alert where the user can insert the task name, frequency and points. This is saved in Firebase.

### History View Controller
This view is shown if the user selects History in the tab bar.
#### Features
Here the user has an overview of all the tasks that are done in the house, by who and when.
#### Functions, Struct’s and Classes
- history: [History]: A struct that represents the history information in Firebase, this contains by who the task is done, what task is done and when.
- loadHistory(): Loads the history that is saved in firebase, appends them to a local list history, sorts them reversed and reloads the table view.
- select cell function.

### Score Board View Controller
This view is shown if the user selects Scoreboard in the tab bar.
#### Features
Here the user sees who has the most and the least points.
#### Functions, Struct’s and Classes
- users: [Users]: A struct that represent the user information in Firebase. This is the total points and the user email.
- loadUsers(): Loads the users saved in Firebase for this house sorted by the total points, appends them to a local list, sorts them reversed and reloads the table view.  

### Settings View Controller
This view is shown if the user selects Settings in the tab bar.
#### Features
Here the user can share the house key, leave the house and log out.
#### Functions, Struct’s and Classes
- shareButtonClicked(): shows an activityViewController with the option to share the house key with an explaining message.
- leaveHouseButtonClicked(): Removes the user from the house, the current user from the users table and the entire house is the house does not have any users left. Also performs a segue to login view.
- logOutButtonClicked(): Logs user out and preforms segue to login view.

## Development

## To Do
Clearly describe challenges that you have met during development. Document all important changes that you have made with regard to your design document (from the PROCESS.md). Here, we can see how much you have learned in the past month.
Defend your decisions by writing an argument of a most a single paragraph. Why was it good to do it different than you thought before? Are there trade-offs for your current solution? In an ideal world, given much more time, would you choose another solution?
