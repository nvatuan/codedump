# BKDN Online Judge's Plagiarism Mechanism Bypass using sourcecode obfuscation

## Description
This program is written with the sore purpose of bypassing BKDNOJ content plagiarism check with the basic mechanism of checking how 
datatypes flows, it doesnt care if the name or literal text is different. Basically, how it works is strip ALL of your variables down
to its data type only. All reserved words remain the same. By insert "whitenoise" (redundant self-assigned variable) to after a random
line of code. It ensures modified program to run as intended although it would cause a big mess if you are solving a TIME-SENSITIVE
problem because redundant variable accesses and assignments in side a big giant nest of loops wouldn't be so pretty.


## Usage
The code takes in your source file with its name hardcoded in the file "input.cpp", then output a modified source to the file named
"output.cpp" with no double quote marks. You can change the files' name in the source code constant fields on the top of the program.