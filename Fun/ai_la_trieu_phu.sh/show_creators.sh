#!/bin/bash

show_creators() {
	var=$(cat creators.txt)
	zenity --info --title="Creators" --text="$var" --no-wrap --icon-name="" --width=200
}

show_creators
