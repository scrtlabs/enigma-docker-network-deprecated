#!/bin/bash
while true; do
	if [[  $(nmap core -p 5552 --open -oG - | awk '/ 5552\/open\/tcp/{print $2}') ]] ; then
		break
	fi
	echo 'Waiting for core...'
	sleep 5
done
echo 'Core is ready!'
python -m surface; bash