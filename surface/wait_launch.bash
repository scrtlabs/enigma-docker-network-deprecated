#!/bin/bash

ID=$(echo $HOSTNAME | awk -F"_" '{print $NF}')

while true; do
	if [[  $(nmap enigma_core_$ID -p 5552 --open -oG - | awk '/ 5552\/open\/tcp/{print $2}') ]] ; then
		break
	fi
	echo "$HOSTNAME: Waiting for enigma_core_$ID..."
	sleep 5
done
echo "enigma_core_$ID is ready!"
python -m surface; bash