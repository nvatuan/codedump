using System;
using System.IO;
using System.Collections.Generic;

public class FileBrowser {
    public static readonly string DefaultPath = @"D:\";
    //
    string Cmd = "";
    string[] CmdTokens;
    // -- Short-hand methods
    public string GetPwd() { return Directory.GetCurrentDirectory(); }
    public void   SetPwd(string Path) { Directory.SetCurrentDirectory(Path); }
    // -- directory crawling with bfs related:
    Dictionary<string, string[]> DirsAt = new Dictionary<string, string[]>();
    Dictionary<string, string[]> FilesAt = new Dictionary<string, string[]>();
    // 
    // This function uses BFS to crawl for StartingPath's content
    // doesn't allow crawling at depth lower than MaxAllowedDepth
    // MaxAllowedDepth is set to -1 by default, meaning allow infinite depth.
    public void PopulateContentHashTable(string StartingPath, int MaxAllowedDepth = -1) {
        // -- initialize
        Queue< KeyValuePair<string, int> > BFSQueue = new Queue< KeyValuePair<string, int> >();
        BFSQueue.Enqueue( new KeyValuePair<string, int>(StartingPath, 0) );
        // -- bfs
        while (BFSQueue.Count > 0) {
            string BFSPath  = BFSQueue.Peek().Key;
            int    BFSDepth = BFSQueue.Peek().Value;
            BFSQueue.Dequeue();
            // -- not allow too deep crawling
            if (BFSDepth == MaxAllowedDepth) continue;
            try {
                // -- Get content, push to table, enqueue the entries.
                string[] SubDirs  = Directory.GetDirectories(BFSPath);
                DirsAt.Add(BFSPath, SubDirs);
                foreach (string subdir in SubDirs) BFSQueue.Enqueue( new KeyValuePair<string, int> (subdir, BFSDepth + 1) );
                // do the same with files but without enqueuing
                string[] SubFiles = Directory.GetFiles(BFSPath);
                FilesAt.Add(BFSPath, SubFiles);
            } catch (UnauthorizedAccessException) {
                continue;
            } catch (Exception e) {
                Console.WriteLine("$$ Unexpected exception " + e.ToString());
                Console.WriteLine("$$ at " + BFSPath);
                return;
            }
        }
    }
    // -- Constructors
    public FileBrowser() {
        this.SetPwd(FileBrowser.DefaultPath);
    } 
    public FileBrowser(string pwd) { 
        if (Directory.Exists(pwd)) {
            this.SetPwd(pwd);
        } else this.SetPwd(FileBrowser.DefaultPath);
    }
    // -- Run()
    // loops forever until the instance is halt
    public void Run() {
        while (true) {
            // -- parsing
            if (Cmd == "") {
                try {
                    Cmd = Console.ReadLine();
                    Cmd = Cmd.TrimEnd( '\r', '\n' ).Trim();
                    // -- process
                    Cmd += ' ';
                    int WhiteSpaceIndex = Cmd.IndexOf(' ');
                    CmdTokens = new String[2];
                    CmdTokens[0] = Cmd.Substring(0, WhiteSpaceIndex);

                    while (WhiteSpaceIndex < Cmd.Length && Cmd[WhiteSpaceIndex] == ' ') WhiteSpaceIndex++;
                    CmdTokens[1] = Cmd.Substring(WhiteSpaceIndex);
                } catch (IndexOutOfRangeException) {
                    Console.WriteLine("$$ Cmd string is invalid. Actual command or argument is missing.");
                    Cmd = "";
                } catch (ArgumentOutOfRangeException) {
                    Console.WriteLine("$$ No second argument detected, clearing CmdTokens[1].");
                    CmdTokens[1] = "";
                } catch (Exception e) {
                    Console.WriteLine("$$ Unexpected Exception caught " + e.ToString());
                    Cmd = "";
                } finally {
                    // -- dump parsing info
                    Console.WriteLine("Cmd = " + Cmd);
                    Console.WriteLine("CmdTokens = " + string.Join(",", CmdTokens));
                }  
            } else {
                // -- Switch case
                switch (CmdTokens[0]) {
                    case "ls":
                        string[] Files = Directory.GetFiles( this.GetPwd() );
                        string[] Directories = Directory.GetDirectories( this.GetPwd() );
                        //
//                      string[] Contents = new string[Files.Length + Directories.Length];
//                      Array.Copy(Files, 0,        Contents, 0,            Files.Length);
//                      Array.Copy(Directories, 0,  Contents, Files.Length, Directories.Length);
//                      Array.Sort(Contents);
                        //
                        Console.WriteLine("-" + this.GetPwd() );
                        foreach (string currentFile in Files) {
                            Console.WriteLine("|-<f> " + currentFile);
                        }
                        foreach (string currentDir in Directories) {
                            Console.WriteLine("|-<d> " + currentDir);
                        }
                        break;
                    case "ls-recursive":
                        this.PopulateContentHashTable(this.GetPwd(), 2);
                        foreach (string path in DirsAt.Keys ) {
                            Console.WriteLine("-"+ path);
                            foreach (string fileInPath in FilesAt[path])
                                Console.WriteLine("|-<f> " + fileInPath);
                            foreach (string dirInPath in DirsAt[path])
                                Console.WriteLine("|-<d> " + dirInPath);
                        }
                        Console.WriteLine();
                        break;
                    case "cd":
                        if (CmdTokens[1] != "") {
                            if (Directory.Exists(CmdTokens[1])) {
                                this.SetPwd(CmdTokens[1]);
                            } else {
                                Console.WriteLine("$$ {0} is not a valid dir path.", CmdTokens[1]);
                            }
                        }
                        Console.WriteLine("> " + this.GetPwd());
                        break;
                    case "exit":
                        return;
                    case "pwd":
                        Console.WriteLine("> " + this.GetPwd());
                        return;
                    default:
                        Console.WriteLine("Unrecognized command");
                        break;
                }
                // -- reset Cmd string
                Cmd = "";
            }
        }
    }
    // --
    public static void Main(string[] args) {

        FileBrowser fb;
        if (args.Length == 0) fb = new FileBrowser();
        else fb = new FileBrowser(string.Join(" ", args));
        fb.Run();
    }
}