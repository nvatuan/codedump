# Java Socket Programming - Chatting CLI application
This use Socket Programming from the Java Language to implement a chat application using the command line interface (no GUI framework).

This application shall have one server, and serve multiple clients. Message sent by one client will be broadcasted to all clients that is on the server at the moment.

## Server.java
The server is running on two threads (instead of dynamically created and destroyed threads) because `ServerSocket.accept()` is a blocking function. So there shall be a "Registering Thread", with its purpose is to registering new connection and giving them new username. The other thread is the "Refresh Thread", which will periodically check for new sent data and broadcasting them, as well as removing disconnected users.

I realized there is no reliable way to check if the client connection has been closed (other than periodically sending data to confirm it is still alive - aka. client heartbeat), so that is why the Server always only remove clients when there are new messages sent. Because that is when "heartbeat" is being sent to client and we can know if it is beating or flatline.

Server is running on port 7788.

## Client.java
Default username is "User", however, you can pass your desired username via the first command line argument when running the program. After that, you can start connecting to the server and start chatting.

For demonstration purpose, the server IP is "localhost". Have tested on a Local Network and it works on Windows. Just enable Inbound Rules and Outbound Rules on port 7788, change the server IP to the machine that is running the `Server` program.


