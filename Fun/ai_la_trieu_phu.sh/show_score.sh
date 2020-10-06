#!/bin/bash

show_score () {
	tit='<span foreground="silver" background="red"><big><b>NAME</b></big></span>	<span foreground="aqua" background="green"><big><b>SCORE</b></big></span>\t\t\t\n'
	var=$(sort -nrk 2 score.txt)
	zenity --info --title="Players's Score" --text="$tit$var" --icon-name="" --no-wrap --width=200
}
show_score
