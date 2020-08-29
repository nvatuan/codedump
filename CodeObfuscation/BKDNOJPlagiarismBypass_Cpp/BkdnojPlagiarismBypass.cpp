#include <bits/stdc++.h>
#define FOR(i,a,b) for(long i=a; i<=b; i++)
#define BAC(i,a,b) for(long i=a; i>=b; i--)
#define br fout << endl
#define llong long long
using namespace std;

ifstream fin ( "a.cpp" );  // open file
ofstream fout( "codeOut.cpp" ); // set stdout to output a file
int SEED = 255;
///////////////////////////////////// VARIABLES //////////////////////////////////////
string line;
string appen[4] = {"qwerqwer", "wertwert", "ertyerty", "rtyurtyu"};
string preser[9] =  {
    "for(;3<1;);", "for(int xxxx;3<1;);", "for(;999<1;);", "if(0){};", "if(0){}\n    else{};",
    "while(0){};", "while(NULL){};", "while(0){};", "do{}while(0);"
                    };
int p[10] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
///////////////////////////////////// PROTOTYPES /////////////////////////////////////
bool isMain(string s);
void redund(string st);
///////////////////////////////////// INITIALIZE /////////////////////////////////////
bool status, enable = 0;

/////////////////////////////////////    MAIN    /////////////////////////////////////
int main() {

	srand(time(0));

	if (fin.is_open()){			    // Check if file is opened, true then do
	    while (! fin.eof() )	    // Do if it's not the end of the file
	    {
	     	getline(fin, line);		// Get data per lines
	     	status = isMain(line); 	// Check if current line define main(){}

	     	if(status){
	//If main() is found, in every other line of sources.cpp the script, it
	//will try to insert noises to increase contrast between original and modified file.
	     		fout << "\nchar qwerqwer;\nint wertwert;\nlong ertyerty;\nlong long rtyurtyu;\n";
	     		fout << line << "\n";
	     		enable = 1;
	     	}
	     	else{
	     		if(enable) redund(line);
	     		else fout << line << "\n";
		// no more noises to add;
			}

		}
		fin.close();					// FILE.CLOSE
	}
	else cout << "Unable to open file.";	// FILE NOT FOUND OR NO PERMISSION
	cout << "Process ended.\n";
	return 0;
}
/////////////////////////////////////   END MAIN   /////////////////////////////////////

bool isMain(string s){
	long l = s.length()-1;
	long j;

	FOR(i, 0, l-3){
		if(
			((s[i]   == 'm')||(s[i]   == 'M')) &&
			((s[i+1] == 'a')||(s[i+1] == 'A')) &&
			((s[i+2] == 'i')||(s[i+2] == 'I')) &&
			((s[i+3] == 'n')||(s[i+3] == 'N'))
          )
		{
				j = i+4;
				while(s[j] == ' '){ j++; }
				if(s[j] == '(' ) return true;
				else return false;
		}
	}
	return false;
}

void redund(string st){
	long l = st.length()-1;
	long x;
	string spc = "        ";

	BAC(i, l, 0){
		if(st[i]==' ') continue;
		if(st[i]==';'){
			fout << line;
			
            x = (rand() % SEED) + 1;

            int y;
			do{
                y = (rand() % x + 1);
                switch(rand()%4){
                    case 3:
                        while(y > 0) {
                            fout << ";"; 
                            y -= (rand() % y + 1);
                        }
                        break;
                    case 2:
                        while(y > 0) {
                            fout << '\n' << spc << preser[ rand() % 9 ];
                            y -= (rand() % y + 1);
                        }
                        break;
                    case 1:
                        while(y > 0){
                            fout << "\n" << spc
                                 << appen[rand() % 4] << "=" << appen[rand() % 4] << ";";
                            y -= (rand() % y + 1);
                        }
                        break;
                    case 0:
                        while(y > 0){
                            fout << "\n" << spc << appen[y%4] << "=" << rand() << ";";
                            y -= (rand() % y + 1);
                        }
                        break;
                }				
				x -= (rand() % x + 1);
			} while(x > 0);

			fout << "\n";
			return;
		}
		else {fout << line << "\n"; return;}
	}
}
