#!/bin/bash

random_line_return=0
function get_random_line {
	FILE='question.txt'
	linecount=$(wc -l < $FILE)
	questioncount=$(expr $linecount '/' 6)
	
	random_line_return=$(expr $RANDOM '%' $questioncount + 1)
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
	if [[ choice != answer ]]
	then
		echo 'Game over.'
	else
		echo 'Ban da tra loi dung!'
	fi
}

function play {
	## Ten
	#player=$(zenity --entry --text="Chao mung ban den voi Ai La Trieu Phu.\n Xin hay nhap ten cua ban:")
	echo $player
	
	##
	#$show_question 2
	get_random_line
}
play
