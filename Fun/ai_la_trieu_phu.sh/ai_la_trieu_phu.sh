#!/bin/bash

## GLOBAL VAR
FILE='question.txt'
QUESTION_COUNT=15

random_line_val=0
function random_line_generate {
	linecount=$(wc -l < $FILE)
	questioncount=$(expr $linecount '/' 6)
	
	random_line_val=$(expr $RANDOM '%' $questioncount + 1)
}

question_array=()
function question_array_generate {
	question_array=()
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
		return 5
	else
		correct=$(expr $correct + 1)
		score=$(expr $correct '*' 10)
		zenity --notification --text="Ban da tra loi dung! Ban dang co $score diem."
		return 0
	fi
}

player="Player"
correct=0
score=0
function play {
	correct=0
	score=0
	## Ten
	player=$(zenity --title="Who are you?" \
		--entry --text="Xin hay nhap ten cua ban:" \
		--width=250)
	if [[ $? -eq 1 ]]; then return 0; fi # Cancel is pressed

	if [[ "$player" == "" ]]; then player="Player"; fi

	echo "Ban la $player"

	question_array_generate $QUESTION_COUNT
	for q_value in "${question_array[@]}"
	do
		show_question $q_value
		if [[ $? -eq 5 ]] # wrong answer chosen
		then break; fi
	done
	
	if [[ $correct -eq $QUESTION_COUNT ]]
	then
		zenity --info --icon-name="" --no-wrap --title "Chuc mung" \
		--text="<span weight='bold' foreground='green'>\nBan da chien thang vang doi! ^o^\t\t\nDiem so perfect: $correct/$QUESTION_COUNT</span>"
	else
		zenity --warning --no-wrap --title "Gameover" \
			--text="<span weight='bold' foreground='red'>\nBan da khong tro thanh trieu phu!\nSo cau hoi dung:$correct/$QUESTION_COUNT</span>"
	fi
	
	# them vao bang diem
	echo -e "$player\t$score" >> score.txt
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
			zenity --notification --text="Empty input! Add question is Cancelled."
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

function show_creators() {
	var=$(cat creators.txt)
	zenity --info --title="Creators" --text="$var" --no-wrap --icon-name="" --width=200
}

function show_score () {
	tit='<span foreground="silver" background="red"><big><b>NAME</b></big></span>	<span foreground="aqua" background="green"><big><b>SCORE</b></big></span>\t\t\t\n'
	var=$(sort -nrk 2 score.txt)
	zenity --info --title="Players' score" --text="$tit$var" --icon-name="" --no-wrap --width=200
}

function menu {
	while true
	do
		choice=$(zenity --title="Ai la Trieu phu?" \
		--text="<b>Chao ban den voi Ai la Trieu phu? Hay chon lua chon:</b>" \
		--height=300 \
		--list --radiolist --column "Pick" --column \
			"Option" FALSE \
			"Play" FALSE \
			"Score" FALSE \
			"Credit" FALSE \
			"Add more questions.." FALSE \
			"Exit")
		#echo $choice
		case $choice in
			"Play") play;;
			"Score") show_score;;
			"Credit") show_creators;;
			"Add more questions..") add_question;;
			"Exit") return 0;;
			*) return 0;;
		esac
	done
	#play
}

menu
zenity --notification --text="Goodbye"
