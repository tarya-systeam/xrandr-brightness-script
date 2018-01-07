#!/bin/bash
USAGE() {
echo '#############################################'
echo "Please provide two arguments."
echo "First should be - or +"
echo "Second should be a name of connected display"
echo
echo "Please see the list of connected displays:"
xrandr -q|grep -w connected|awk '{print $1}'
echo '#############################################'
}

if xrandr -q | grep -o $2 &>/dev/null && (($# == 2)) && [[ $1 =~ ^(\+|\-)$ ]]; then
	
CURRBRIGHT=$(xrandr -q --verbose|grep -A 5 $2|awk '/Brightness/ {print $NF}')
if  [ -z $CURRBRIGHT ]; then
	echo "Current brightness for provided display has an empty value. Is this display connected?"
	echo "Please see the list of connected displays:"
	xrandr -q|grep -w connected|awk '{print $1}'
	exit 1
	else
	if [ "$1" = "+" ] && [ $(echo "$CURRBRIGHT < 1" | bc) -eq 1 ] 
	then
	xrandr --output $2 --brightness $(echo "$CURRBRIGHT + 0.1" | bc)
	elif [ "$1" = "-" ] && [ $(echo "$CURRBRIGHT > 0" | bc) -eq 1 ] 
	then
	xrandr --output $2 --brightness $(echo "$CURRBRIGHT - 0.1" | bc)
	fi
fi
else 
USAGE
fi
