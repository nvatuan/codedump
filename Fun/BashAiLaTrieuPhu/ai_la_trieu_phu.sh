#!/bin/bash

function get_question {
	file='question.txt'

	firstline=$( expr $1 '*' 6 - 5)
	lastline=$( expr $firstline + 5)

	question=$(head -n $(expr $firstline) $file | tail -n 1);
	optionA=$(head -n $(expr $firstline + 1) $file | tail -n 1);
	optionB=$(head -n $(expr $firstline + 2) $file | tail -n 1);
	optionC=$(head -n $(expr $firstline + 3) $file | tail -n 1);
	optionD=$(head -n $(expr $firstline + 4) $file | tail -n 1);
	answer=$(head -n $(expr $firstline + 5) $file | tail -n 1);
	
	zenity --text="$question" --list --radiolist --column "" --column "Lua chon" FALSE $optionA FALSE $optionB FALSE $optionC FALSE $optionD
}

function play {
	## Ten
	#player=$(zenity --entry --text="Chao mung ban den voi Ai La Trieu Phu.\n Xin hay nhap ten cua ban:")
	echo $player
	
	##
	get_question 1
	#get_question 3
}
play
