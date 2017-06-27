# Report about Spick-and-Span by Fien Maandag

## Short Description
Spick-and-Span is an app for people who share a household. It helps the user keep track of what tasks need to be done in the house and who’s turn it is to do some tasks. The user can create a house with rooms, tasks for each room and assigning a frequency and points to each task. It is a positively orientated solution for a paper schedule. It is positively orientated because it does not force anyone to do certain tasks at certain moments but instead positively reinforces people for doing tasks. Spick-and-Span is also an improvement relative to a paper schedule since it gives the opportunity to do the tasks in the house that you prefer, give more exact information about which tasks need to be done and provides a clear overview of the tasks done and by who they are done.

## Technical Design
### Login View
Starting up the app initially leads the user to a login view. Here it is possible to login if you already have an account otherwise you can register as user. If the user is already connected to a house the House View is loaded, if the user is currently not connected to a house the New House View is loaded.

### New House View
This view provides the user with the possibility to add an existing house to his/her account with the use of a secret code or to create a house by inserting a house name. When the user creates a new house this will lead the user to the secret Code View if the user adds an existing house the user is send directly to the House View.

### Secret Code View
This view provides the user with information on who to share access to the created house. It also provides the possibility to share this information with other people. If the user is done it is possible to go to the House View.

### House View
If the user is logged in and is connected to a house this is the first view that is loaded. This solely gives an overview of the rooms in the house. Here it is also possible to add a room. By selecting a room in the list the Room View is shown.

### Room View
This view shows the tasks that needs to be done in the selected room with the corresponding priority level. 

### History View

### Score Board View

### Settings View


## To Do
Clearly describe the technical design: how is the functionality implemented in your code? This should be like your DESIGN.md but updated to reflect the final application. First, give a high level overview, which helps us navigate and understand the total of your code (which components are there?). Second, go into detail, and describe the modules/classes/functions and how they relate.
Clearly describe challenges that your have met during development. Document all important changes that your have made with regard to your design document (from the PROCESS.md). Here, we can see how much you have learned in the past month.
Defend your decisions by writing an argument of a most a single paragraph. Why was it good to do it different than you thought before? Are there trade-offs for your current solution? In an ideal world, given much more time, would you choose another solution?
