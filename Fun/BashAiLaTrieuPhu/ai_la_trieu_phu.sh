#!/bin/bash

random_line_val=0
function random_line_generate {
	FILE='question.txt'
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
	FILE='question.txt'

	firstline=$( expr $1 '*' 6 - 5)
	lastline=$( expr $firstline + 5)

	question=$(head -n $(expr $firstline) $FILE | tail -n 1);
	optionA=$(head -n $(expr $firstline + 1) $FILE | tail -n 1);
	optionB=$(head -n $(expr $firstline + 2) $FILE | tail -n 1);
	optionC=$(head -n $(expr $firstline + 3) $FILE | tail -n 1);
	optionD=$(head -n $(expr $firstline + 4) $FILE | tail -n 1);
	answer=$(head -n $(expr $firstline + 5) $FILE | tail -n 1);
	
	choice=$(zenity --text="$question" --list --radiolist --column "" --column "Lua chon" FALSE $optionA FALSE $optionB FALSE $optionC FALSE $optionD)
	if [[ "$choice" != "$answer" ]]
	then
		zenity --warning --no-wrap --title "Gameover" \
			--text="<span weight='bold' foreground='red'>\nBan da khong tro thanh trieu phu!</span>"
		# them con diem
		exit 0
	else
		correct=$(expr $correct + 1)
		score=$(expr $correct '*' 10)
		zenity --notification --text="Ban da tra loi dung! Ban dang co $score."
	fi
}

player="Player"
correct=0
function play {
	## Ten
	#player=$(zenity --entry --text="Chao mung ban den voi Ai La Trieu Phu.\n Xin hay nhap ten cua ban:")
	echo $player
	
	##
	#show_question 2
	#get_random_line
	question_array_generate 5
	for q_value in "${question_array[@]}"
	do
		show_question $q_value
	done
}

play
