#!/bin/bash

## GLOBAL VAR
FILE='question.txt'

random_line_val=0
function random_line_generate {
	linecount=$(wc -l < $FILE)
	questioncount=$(expr $linecount '/' 6)
	
	random_line_val=$(expr $RANDOM '%' $questioncount + 1)
}

question_array=()
function question_array_generate {
	if [[ $# -gt 0 ]]
	then
		amount=$1
		while [ $amount -ne 0 ]
		do
			#echo "Turn no.:" $amount
			is_unique=true

			random_line_generate
			# check if the randomed value already exists
			for q_value in "${question_array[@]}"
			do
				#echo "$q_value|$random_line_val"
				if [[ $q_value == $random_line_val ]]
				then
					#echo "Duplicated"
					is_unique=false
				       	break
				fi
			done

			if $is_unique 
			then
				question_array+=($random_line_val)
				amount=$(expr $amount '-' 1)
			fi
		done
	fi
}

function show_question {
	firstline=$( expr $1 '*' 6 - 5)
	lastline=$( expr $firstline + 5)

	question=$(head -n $(expr $firstline) $FILE | tail -n 1);
	optionA=$(head -n $(expr $firstline + 1) $FILE | tail -n 1);
	optionB=$(head -n $(expr $firstline + 2) $FILE | tail -n 1);
	optionC=$(head -n $(expr $firstline + 3) $FILE | tail -n 1);
	optionD=$(head -n $(expr $firstline + 4) $FILE | tail -n 1);
	answer=$(head -n $(expr $firstline + 5) $FILE | tail -n 1);
	
	choice=$(zenity --text="$question" --list --radiolist --column "" --column "Lua chon" FALSE "$optionA" FALSE "$optionB" FALSE "$optionC" FALSE "$optionD")
	if [[ "$choice" !=  "$answer" ]]
	then
		zenity --notification --text="wrong"

		#zenity --warning --no-wrap --title "Gameover" \
			#--text="<span weight='bold' foreground='red'>\nBan da khong tro thanh trieu phu!</span>"
		# them con diem
		#exit 0
	else
		correct=$(expr $correct + 1)
		score=$(expr $correct '*' 10)
		zenity --notification --text="Ban da tra loi dung! Ban dang co $score diem."
	fi
}

player="Player"
correct=0
function play {
	## Ten
	player=$(zenity --entry --text="Xin hay nhap ten cua ban:")
	echo "Ban la $player"
	
	#show_question 5
	#get_random_line
	question_array_generate 15
	for q_value in "${question_array[@]}"
	do
		show_question $q_value
	done
}

function add_question {
	OUTPUT=$(zenity --forms --title "Add Question"\
		--text='Input your Question'\
		--add-entry="Question:"\
		--add-entry="A:"\
		--add-entry="B:"\
		--add-entry="C:"\
		--add-entry="D:"\
		--add-entry="Answer:")
	IFS='|'
	arr=()
	read -ra ADDR <<<"$OUTPUT" 
	for i in 0 1 2 3 4 5; 
	do  
		if [ -z "${ADDR[i]}" ]; then
		zenity --warning --text="Empty Input!" --width=300
			return 0
		fi
		arr[i]=${ADDR[i]}
	done
	if [ ${arr[5]} = 'A' ] || [ ${arr[5]} = 'B' ] || \
	[ ${arr[5]} = 'C' ] || [ ${arr[5]} = 'D' ] || \
	[ ${arr[5]} = 'a' ] || [ ${arr[5]} = 'b' ] || \
	[ ${arr[5]} = 'c' ] || [ ${arr[5]} = 'd' ]; then
	{
		echo ${arr[0]} >> $FILE
		echo ${arr[1]} >> $FILE
		echo ${arr[2]} >> $FILE
		echo ${arr[3]} >> $FILE
		echo ${arr[4]} >> $FILE
		if [ ${arr[5]} = 'A' ] || [ ${arr[5]} = 'a' ];
		then 
			echo ${arr[1]} >> $FILE
		fi
		if [ ${arr[5]} = 'B' ] || [ ${arr[5]} = 'b' ];
		then 
			echo ${arr[2]} >> $FILE
		fi
		if [ ${arr[5]} = 'C' ] || [ ${arr[5]} = 'c' ];
		then 
			echo ${arr[3]} >> $FILE
		fi
		if [ ${arr[5]} = 'D' ] || [ ${arr[5]} = 'd' ];
		then 
			echo ${arr[4]} >> $FILE
		fi	
		zenity --notification --text="Success!"
		
	}
	else
		zenity --warning --text="Invalid! \nNote: Dap an phai nam trong A B C D hoac a b c d!"\
		--width=400
	fi
}

function menu {
	choice=$(zenity --title="Ai la Trieu phu?" --text="<b>Chao ban den voi Ai la Trieu phu?. Hay chon lua chon:</b>" --list --radiolist --column "Pick" --column "Option" FALSE "Play" FALSE "Highscore" FALSE "Credit" FALSE "Add more questions..")
	echo $choice
	add_question
	#play
}

menu

