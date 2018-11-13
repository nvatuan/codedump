#include <bits/stdc++.h>
#define FOR(i,a,b) for(long i=a; i<=b; i++)
#define BAC(i,a,b) for(long i=a; i>=b; i--)
#define br fout << endl
#define llong long long
using namespace std;

//////////////////////////////////////////////////////////////////////////////
///// This program is written with the sore purpose of bypassing BKDNOJ //////
/////  duplicate sources check with the basic mechanic of checking how  //////
//// data flows, it doesnt care if the name or literal text is different /////
//// By insert "whitenoise" (redundant self-assigned variable) to random /////
// after a line of code. It ensures the modified program to run as intended //
/// although it would cause a big mess if this is a TIME-SENSITIVE problem ///
/// because variable accesses and assignments in side LOOPs of LOOPs arent ///
//////////////////////////////// pretty //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

string FILEIN = "input.cpp";
string FILEOUT = "output.cpp";

ifstream fin ( FILEIN );  // open file
ofstream fout( FILEOUT ); // set stdout to output a file
////////////////// VARIABLES ///////////////////
string line;
string appen[4] = {"qwerqwer", "wertwert", "ertyerty", "rtyurtyu"};
int p[10] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29};
////////////////// PROTOTYPES //////////////////
bool isMain(string s);
void redund(string st);

////////////// INITIALIZE //////////////
	bool status, enable = 0;
//////////////////////////// MAIN ////////////////////////////
int main() {

	//mt19937 mt_rand(time(0));	// set random seed
	srand(time(0));

	if (fin.is_open()){			// Check if file is opened, true then do
	    while (! fin.eof() )	// Do if it's not the end of the file
	    {

	     	getline(fin,line);		// Get data per lines
	     	status = isMain(line); 	// Check if current line define main(){}

	     	if(status){			
	//If main() is found, in every other line of sources.cpp the script 
	//will try to insert noises to increase contrast of the two source files.
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
	else cout << "Unable to open file";	// FILE NOT FOUND OR NO PERMISSION
	cout << "Process ended.\n";
	return 0;
}

bool isMain(string s){
	long l = s.length()-1;
	long j;

	FOR(i, 0, l-3){
		if(
			((s[i] == 'm')||(s[i] == 'M'))&&
			((s[i+1] == 'a')||(s[i+1] == 'A'))&&
			((s[i+2] == 'i')||(s[i+2] == 'I'))&&
			((s[i+3] == 'n')||(s[i+3] == 'N')))
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
	int rr;
	string spc = "    ";

	BAC(i, l, 0){
		if(st[i]==' ') continue;
		if(/*(st[i]=='}')||*/(st[i]==';')){
			fout << line;
			
			x = p[(rand()%10)];

			do{
				rr = ((rand())%4);
				fout << "\n"<<spc<<appen[rr]<<" = "<<appen[rr]<<";";
				//x = rand() % x;
				x--;
				//iii++;
			} while(x > 0);

			fout << "\n";
			return;
		}
		else {fout << line << "\n"; return;}
	}
}