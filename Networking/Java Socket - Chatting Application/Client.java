import java.io.*;
import java.net.*;

/**
 * Client for the chat server "Server.java"
 */
public class Client {
    /**
     * The server ip address.
     */
    final private String SERVER_IP = "192.168.137.1";

    /**
     * @param socket is the socket that is used to talk with the server.
     * @param username is the name that is agreed by the server
     * @param DataOutputStream stream to send data to server
     * @param DataInputStream stream to receive data from server
     */
    private Socket socket = null;
    private String username = null;
    private DataOutputStream dos = null; 
    private DataInputStream dis = null;

    /**
     * Constructor of a client.
     * @param port The port number that the chat application is running on
     * @param chosen The username chosen by the user.
     * @throws IOException
     */
    public Client(int port, String chosen) throws IOException {
        try {
            socket = new Socket(SERVER_IP, port);
            dos = new DataOutputStream(socket.getOutputStream());
            dos.writeUTF(chosen);

            dis = new DataInputStream(socket.getInputStream());

            while (dis.available() <= 0); // wait
            this.username = dis.readUTF();
        } finally {
        }
    }

    /**
     * This begins the chatting process with the server.
     * @param br This is the command line input stream, enables the user to type in their messages.
     * @throws IOException
     */
    public void beginChat(BufferedReader br) throws IOException {
        String rmsg, smsg;
        while (true) {
            smsg = null; rmsg = null;
            if (br.ready()) smsg = br.readLine();
            if (dis.available() > 0) rmsg = dis.readUTF();
            if (rmsg != null) {
                System.out.println(rmsg);
                if (rmsg.equals("\\exit")) {
                    System.out.println("Connection closed by SERVER.");
                    System.exit(0);
                    break;
                }
            }
            if (smsg != null) {
                smsg = this.username + "> " + smsg;
                dos.writeUTF(smsg);
                if (smsg.equals("\\exit")) {
                    System.out.println("Connection closed by YOU.");
                    System.exit(0);
                    break;
                }
            }
        }
    }

    /**
     * Run the client. Firstly try to connect to the server, then try to register the username. After received the name from the server, chatting is began.
     * @throws IOException
     */
    public void run() throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

        System.out.println("Connected to chat server. Your name is <" + this.username + ">");
        System.out.println("------------------------------------------------");
        this.beginChat(br);
        System.out.println("------------------------------------------------");
    }

    /**
     * main function
     * @param args The first args is the desired name for that client. If left empty, the name will be "User".
     */
    public static void main(String[] args) {
        String name = "User";
        if (args.length >= 1) {
            name = args[0];
        }
        System.out.println("Tring to connect to server as <" + name + ">");
        try {
            new Client(7788, name).run();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
