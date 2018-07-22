#!/bin/bash

ID=$(echo $HOSTNAME | awk -F"_" '{print $NF}')
CORE=$(getent hosts enigma_core_$ID | awk '{ print $1 }')
CONTRACT=$(getent hosts enigma_contract_1 | awk '{ print $1 }')

while true; do
	curl -s -m 1 enigma_core_$ID:5552
	if [[  $? -eq 28 ]] ; then
		break
	fi
	echo "$HOSTNAME: Waiting for enigma_core_$ID..."
	sleep 5
done
echo "enigma_core_$ID is ready!"

if [ "$SGX_MODE" = "SW" ]; then
	echo 'Running Surface in Simulation Mode'
	SIMUL='--simulation'
else
	SIMUL=''
fi
python -m surface --dev-account=$ID --ipc-connstr=$CORE:5552 --provider-url=http://$CONTRACT:8545 $SIMUL; bash
