import java.io.*;
import java.net.*;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Queue;

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
    private HashMap<String, Integer> userList = new HashMap<String, Integer>();
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
            if (userToDIS.get(username).available() > 0) {
                String msg = userToDIS.get(username).readUTF();
                new_msg.add(msg);
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
                    System.err.println("----------------------------------------------------------\n");
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
                    System.err.println("----------------------------------------------------------\n");
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
        for (String username : userToServer.keySet()) {
            if (userToServer.get(username).isClosed()) {
                System.err.println(">> Found user <"+username+">'s connection has been closed. Removing..");
                toBeRemoved.add(username);
            }
        }

        LinkedList<String> annoucements = new LinkedList<String>();
        while (! toBeRemoved.isEmpty()) {
            String username = toBeRemoved.pop();
            try {
                userToDIS.get(username).close();
                userToDOS.get(username).close();
                userToDIS.remove(username);
                userToDOS.remove(username);
                userToServer.remove(username);
                
                String original_name = username.substring(0,
                    username.lastIndexOf(" ")
                );

                userList.put(original_name, userList.get(original_name)-1);

                String annc = "[-] User <"+username+"> has disconnected.";
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
     * @bug If 3 Johns joined the server, they will received "John", "John (1)", "John (2)" respectively. This works because the server is keeping a counter on each username string. But if "John (1)" disconnected, that counter will be decreased to 2 (formally 3), and if a new John connects, he will be given "John (2)" again, duplicate with another existing user.
     * @TODO For the bug above, Use the `mex` (minimum exclusive) operation to find the next numbering for the user with the same desired name. 
     */
    synchronized public void registerNewClient(Socket server_socket) throws IOException {
        DataInputStream dis = null;
        DataOutputStream dos = null;

        dis = new DataInputStream(server_socket.getInputStream());

        System.err.println("> Waiting for client to send username.");
        while (dis.available() <= 0) ; // wait
        System.err.println("> User name received.");
        String client_name = dis.readUTF();
        System.err.println("> username=" + client_name);

        if (userList.get(client_name) == null) {
            userList.put(client_name, 0);
        }
        int cnt = userList.get(client_name);
        userList.put(client_name, cnt+1);

        String registered_name;
        if (cnt == 0) registered_name = client_name;
        else registered_name = client_name + " (" + cnt + ")";

        dos = new DataOutputStream(server_socket.getOutputStream());
        dos.writeUTF(registered_name);
        
        userToServer.put(registered_name, server_socket);
        userToDOS.put(registered_name, dos);
        userToDIS.put(registered_name, dis);

        System.out.println("[*] Connected to " + server_socket.getRemoteSocketAddress() + " as user <"+ registered_name +">");

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
            // System.out.println(">> Refreshing chat..");
            this.refresh_chat();
            // System.out.println(">> Refreshing active list..");
            this.refresh_active_list();
            Thread.sleep(1000);
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
