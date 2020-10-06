#!/bin/bash

function get_question {
	file='question.txt'

	firstline=$( expr $1 '*' 6 - 5)
	lastline=$( expr $firstline + 5)
	for i in $(seq $firstline 1 $lastline)
	do 
		echo "line = $i"
		echo $(head -n $i $file | tail -n 1);
	done
}

function play {
	## Ten
	#player=$(zenity --entry --text="Chao mung ban den voi Ai La Trieu Phu.\n Xin hay nhap ten cua ban:")
	echo $player
	
	##
	get_question 1
	get_question 3
}
play
