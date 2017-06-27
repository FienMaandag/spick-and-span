# Process Book

In this document the process of building the Spick and Span app will be documented.

# Day 2: 7 june
The idea of the app was defined today. An important decision was to make a point based app instead of a schedule based app. This decision was made because it seemed like a more original and unique concept and also more of an addition to the regular pen and paper solution. The decision was also made to let the users join a house via a secret code that is generated when a house is created.

# Day 3: 8 june
Today the layout was created in Xcode. A change in the layout was changing the hamburger menu option to a tab bar on the bottom of the page. This decision was made because it is more IOS like. Because of this the options leave house, logout and secret code have been merged together to a tab settings.

# Day 4: 9 june
Today the design document was setup. The database was structured and the first step for a functioning login was made.

# Day 7: 12 june
Today the login function and register function were created. There are still some problems with adding an existing house to a user. I am not quite sure yet what is going wrong. Also i was doubting about the exact setup for the database. I now created a table with houses which also has users inside and a users table with the house they belong to. I made this decision because i thought it might be easier to select houses and users for certain views like the high score view and the addhouseview.

# Day 8: 13 june
It is now possible to add a house and the login function checks if the user is already connected to a house. Also the logout options is created

# Day 9: 14 june
Adding rooms and tasks is now possible in firebase.

# Day 10: 15 june
Today i was not feeling well. I tried to do some fixing with loading tableviews be can not seem to make them work.

# Day 11: 16 june
Today i was not feeling well. I tried to do some fixing with loading tableviews again but not very succesfull.

# Day 14: 19 june
Today I struggels with saving a timestamp since you are not aloud to save an int to firebase. Also Date() gave me an empty value. After a long time i finally managed to save the time stamp. Also saving the points is now possible still working on counting with the points but this is almost finished.

# Day 15: 20 june
Today i found out that the date calculation was not quite right. It seemed that somewhere in the changing from strings to int it went wrong. After all the solution lied in making it a float to calculate with. Also marijn told me about a different way to save the time. So had to redo that part.

# Day 16: 21 june
Loading the data in tableviews seemed to go wrong still. Today this is all fixed. Sometimes the data was loaded to late or simply not shown. I wanted to add a slide over button from left to rigth to sign a task of done, i looked quite easy at first but was hard to implement after all. decided to use the standart button after all.

# Day 17: 22 june
Some of the types were not chosen right. Everything in firebase was saved as an string. Making it hard to sort them in a descending order. After figuring out that they could also be saved as an number I had to reorganize all the variables to ints and this caused a lot of errors so was doing a lot of debugging today.

# Day 18: 23 june
Added an option for emailing the secretcode since it is such a hard code. This works now. Also did some layout fixing. A lot of views were not shown right. 

# Day 21: 26 june
Today I decided to create a function for alerts since this is a lot of double code over several viewControlers. I also reorganised some elements to make the document more readable.

# Day 22: 27 june

# Day 23: 28 june

# Day 24: 29 june
