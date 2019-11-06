# Homework4-F19
Viviana Rosas Romero
913305326

For this assignment, I worked on implementing the functionality of transfer, deposit, withdraw, and delete. The difficulty of this assignment was in learning how to implement custom popovers and finding which protocols to implement for the account picker. 

I implemented my custom popover by creating a new view controller that contains this popover and presenting it when a user selected either add new account or on the account in the table. 

I made all the API calls in each respective view controller, however, dismissing the view controllers would trigger didAppear in the parent view and would reset the UI table. This is how I was able to sync the edits the user inputs with the table and the database. 

Another difficulty in implementing was determining which method to use so the view controllers can communicate with each other. I did a simple technique for this. However, had I more time I would attempt to implement a model for lots of teh functionality that ended up in my view controller. 

For the delete implementation, I implemented both slide to delete and delete in detail view. I did the former first because I was having difficulty updating my table at first with the custom functionality. However, I decided to keep it since it is an intuitive way for the user to delete and it works as expected. Both work the same. 

