# Java Socket Programming - Chatting CLI application
This use Socket Programming from the Java Language to implement a chat application using the command line interface (no GUI framework).

This application shall have one server, and serve multiple clients. Message sent by one client will be broadcasted to all clients that is on the server at the moment.

## Server.java
The server is running on two threads (instead of dynamically created and destroyed threads) because `ServerSocket.accept()` is a blocking function. So there shall be a "Registering Thread", with its purpose is to registering new connection and giving them new username. The other thread is the "Refresh Thread", which will periodically check for new sent data and broadcasting them, as well as removing disconnected users.

## Client.java
Default username is "User", however, you can pass your desired username via the first command line argument when running the program. After that, you can start connecting to the server and start chatting.

## Server's bug
There is a bug that has been described in the Server.java source code. It is related to registering new user, unintentionally register duplicated username, although it is not something very serious.


