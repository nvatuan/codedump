import java.io.*;
import java.net.*;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;

/**
 * A chat program server - Run on 2 threads (instead of multi-threaded) because `ServerSocket.accept()` is blocking, can serve multiple clients.
 * Works as follow:
 *   - Keep track of a list of clients and their sockets (input/output streams)
 *   - If Any of the client send data, broadcast (implemented by a for-each loop through the list of client) that data to all member
 *   - Check if a client has sent data by using calling `inputStream.available()` function for every period of time.
 */
public class Server {
    private ServerSocket ssocket;
    
    private Socket server;

    /**
     * HashMap<> to convert a username to resources dedicated to that user. Every user shall have distinct username,
     * if not, the server will try to find a distinct name for that user.
     */
    // private HashMap<String, Integer> userList = new HashMap<String, Integer>();
    private HashSet<String> userList = new HashSet<String>();
    private HashMap<String, Socket> userToServer = new HashMap<String, Socket>();

    private HashMap<String, DataOutputStream> userToDOS = new HashMap<String, DataOutputStream>();
    private HashMap<String, DataInputStream> userToDIS = new HashMap<String, DataInputStream>();

    /**
     * Constructor that specifies the server to run on a port number
     * @param port
     * @throws IOException
     */
    public Server(int port) throws IOException {
        ssocket = new ServerSocket(port);
    }

    /**
     * Go through the list of clients to check if they have sent new data.
     * If they did, store the messages to a queue, then broadcast it later.
     */
    synchronized public void refresh_chat() throws IOException {
        LinkedList<String> new_msg = new LinkedList<String>();
        for (String username : userToServer.keySet()) {
            try {
                if (userToDIS.get(username).available() > 0) {
                    String msg = userToDIS.get(username).readUTF();
                    new_msg.add(msg);
                }
            } catch (Exception e) {
            }
        }

        while (new_msg.size() > 0) {
            String msg = new_msg.pop();
            System.out.println("RECEIVED: "+msg);
            for (String username : userToServer.keySet()) {
                try {
                    userToDOS.get(username).writeUTF(msg);
                } catch (Exception e) {
                    System.err.println("----------------------------------------------------------");
                    System.err.println("!! Error occurs when sending msg to user<" + username +">");
                    System.err.println("!! Force closing connection of user<" + username +">");
                    userToServer.get(username).close();
                    // e.printStackTrace();
                    System.err.println("----------------------------------------------------------");
                }
            }
        }
    }

    /**
     * Use to announce a list of messages. This function exists for fancy purposes.
     * @param annoucements is a LinkedList<String> as a queue of messages, they will get printed to every client.
     * @param formal is a boolean, specified if ANNOUCEMENT header should be printed along with the messages
     */
    synchronized public void annouce(LinkedList<String> annoucements, boolean formal) throws IOException {
        if (formal) {
            annoucements.addFirst("||----- ANNOUCEMENT ---------------------");
            annoucements.addLast("||----------------------------------------");
        }
        while (! annoucements.isEmpty()) {
            String annc = annoucements.pop();
            if (formal) annc = "|| " + annc;

            for (String username : userToServer.keySet()) {
                try {
                    userToDOS.get(username).writeUTF(annc);
                } catch (Exception e) {
                    System.err.println("----------------------------------------------------------");
                    System.err.println("!! Error occurs when sending msg to user<" + username +">");
                    System.err.println("!! Force closing connection of user<" + username +">");
                    userToServer.get(username).close();
                    // e.printStackTrace();
                    System.err.println("----------------------------------------------------------");
                }
            }
        }
    }

    /**
     * Check if a user in user list is still active (aka. is still connected) and update the list
     * @throws IOException
     */
    synchronized public void refresh_active_list() throws IOException {
        LinkedList<String> toBeRemoved = new LinkedList<String>();
        for (String username : userList) {
            if (userToServer.get(username).isClosed()) {
                System.err.println(">> Found user <"+username+">'s connection has been closed. Removing..");
                toBeRemoved.add(username);
            }
        }

        LinkedList<String> annoucements = new LinkedList<String>();
        while (! toBeRemoved.isEmpty()) {
            String dc_username = toBeRemoved.pop();
            try {
                userToDIS.get(dc_username).close();
                userToDOS.get(dc_username).close();
                userToDIS.remove(dc_username);
                userToDOS.remove(dc_username);
                userToServer.remove(dc_username);
                
                if (userList.contains(dc_username)) userList.remove(dc_username);

                String annc = "[-] User <"+dc_username+"> has disconnected.";
                System.out.println(annc);
                annoucements.add(annc);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        annouce(annoucements, false);
    }

    /**
     * Register a new client, check if the desired username is good (is distinct), otherwise will try to
     * append a counter (ex. name (1), name (2),...) to make it distinctive. Finally, the server will print back
     * to the client the decided username for the client.
     * 
     * @param server_socket The socket on the server that is dediciated to the new client.
     * @throws IOException
     */
    synchronized public void registerNewClient(Socket server_socket) throws IOException {
        DataInputStream dis = null;
        DataOutputStream dos = null;

        dis = new DataInputStream(server_socket.getInputStream());

        System.err.println("> Waiting for client to send username.");
        while (dis.available() <= 0) ; // wait

        System.err.print("> User name received. ");
        String client_name = dis.readUTF();
        System.err.println("$username=" + client_name);

        // Finding the right postfix for client_name
        int cnt = 0;
        String postfix = "";
        while (userList.contains(client_name + postfix)) {
            cnt += 1;
            postfix = " (" + cnt + ")";
        }
        System.err.println("> Final username is <" + client_name + postfix + ">");

        // Storing them in registered_name and put it to the set
        String registered_name = client_name + postfix;
        userList.add(registered_name);

        // Return it to client
        dos = new DataOutputStream(server_socket.getOutputStream());
        dos.writeUTF(registered_name);
        
        // Registering the new client resources
        userToServer.put(registered_name, server_socket);
        userToDOS.put(registered_name, dos);
        userToDIS.put(registered_name, dis);

        // Output to server screen
        System.out.println("[*] Connected to " + server_socket.getRemoteSocketAddress() + " as user <"+ registered_name +">");

        // Construct the annoucement for the new client's arrival.
        String annc = "[+] User <"+registered_name+"> has just connected.";
        annouce(new LinkedList<String>(Arrays.asList(annc)), false);
    }

    /**
     * Run the server. Start a registering thread which will only wait and accepting new connection. The other thread will refresh chat and active list.
     * @throws InterruptedException
     * @throws IOException
     */
    public void run() throws InterruptedException, IOException {
        System.out.println("Waiting for client on port " + ssocket.getLocalPort() + "...");

        Thread registering_thread = new Thread() {
            public void run() {
                while (true) {
                    try {
                        Socket server = ssocket.accept();
                        System.out.println("[!] New connection incoming..");
                        registerNewClient(server);

                        // BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
                        // this.beginChat(br);
                    } catch (Exception e) {
                        System.err.println("Error!");
                        e.printStackTrace();
                    }
                }
            }
        };

        registering_thread.start();
        while (true) {
            try {
                // System.out.println(">> Refreshing chat..");
                this.refresh_chat();
                // System.out.println(">> Refreshing active list..");
                this.refresh_active_list();
                Thread.sleep(1000);
            } catch (Exception e) {

            }
        }
    }

    /**
     * Main function.
     * @param args
     */
    public static void main(String[] args) {
        try {
            new Server(7788).run();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
