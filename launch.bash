#!/bin/bash

function help() {
	echo "Launches Enigma Docker Network."
	echo
	echo "Usage:"
	echo "	$0 [-t] [-d] [-h] [-s] [-q]"
	echo
	echo "Options:"
	echo "  -d    Run in development mode."
	echo "  -h    Show this help."
	echo "  -t    Spawn a terminal for every container/process."
	echo "  -q    Stops Enigma Docker Network and removes containers."
	echo "  -s    Run in simulation mode."
}

function check_config() {
	if [ ! -f .env ]; then
        echo 'Creating .env file from template'
        cp .env-template .env
	fi
}

function check_contractfolder() {
	source .env
	if [ ! -d "$GIT_FOLDER_CONTRACT" ]; then
		echo "\"$GIT_FOLDER_CONTRACT\" does not exist."
		echo "Please edit the \".env\" file and configure GIT_FOLDER_CONTRACT to point to your local copy of a valid Enigma contract repository."
		exit 1
	fi
}

function build_images() {
	# Force rebuild of images every run
	docker-compose $ARGF build
	if [[ ! $? -eq 0 ]]; then
		echo 'Build of docker images failed. Exiting.'
		exit 1
	fi
}

function boot_images() {
	docker-compose $ARGF up &
	echo 'Waiting for containers to start...'
	sleep 5
	if [ $TERMINALS ]; then
		xterm -T 'Enigma Contract' -geometry 90x20+20+20 -e "docker attach enigma_contract_1" &
		xterm -T 'Enigma Core' -geometry 120x20+600+20 -e "docker attach enigma_core_1" &
	fi
}

function deploy_contract() {
	echo 'Waiting for contract to be available...'
	CONTRACT_IP='localhost'
	while :
	do
	    curl -s $CONTRACT_IP:8545 > /dev/null
		result=$?
		if [[ $result -eq 0 ]]; then
	        break
	    fi
	    sleep 5
	done
	echo "Deploying contracts on testnet..."
	if [ $DEVELOP ]; then
		source .env
		pushd $GIT_FOLDER_CONTRACT
		rm -rf build/contracts/*
		darq-truffle migrate --reset --network development
		popd
	else	
		docker-compose exec contract bash -c "rm -rf ~/enigma-contract/build/contracts/*"
		docker-compose exec contract bash -c "cd enigma-contract && darq-truffle migrate --reset --network ganache"
	fi
}

function start_surface() {
	echo "Starting Surface..."
	if [ $TERMINALS ]; then
		xterm -T 'Enigma Surface' -geometry 120x20+900+80 \
	  		-e  "docker-compose exec surface bash -c ./wait_launch.bash" &
	else
		docker-compose exec -d surface bash -c ./wait_launch.bash
	fi
}

function start_app() {
	if [ $DEVELOP ]; then
		echo 'Ready to launch your app.'
	else
		echo "Starting coin-mixer app..."
		APP_CMD="cd enigma-contract && node integration/coin-mixer.js --url=http://enigma_contract_1:8545"
		if [ $TERMINALS ]; then
			xterm -T 'Enigma DApp' -geometry 152x20+20+330 -e "docker-compose exec contract bash -c \"$APP_CMD; bash\"" &
		else
			docker-compose exec -d contract bash -c "$APP_CMD"
		fi
	fi
}

function launch() {
	build_images
	boot_images
	deploy_contract
	start_surface
	start_app
}

check_config

# By default we run in HW mode, which can be overriden through option below
sed -e 's/SGX_MODE=.*/SGX_MODE=HW/g' .env > .env.tmp && mv .env.tmp .env
SIMUL=''
ARGF="-f docker-compose.yml"

while getopts ":dhqst" opt; do
	case $opt in 
		d) check_contractfolder
		   ARGF="$ARGF -f docker-compose.develop.yml"
		   DEVELOP=True;;
		h) help 
		   exit 0;;
		q) docker-compose down
		   exit 0;;
		s) SIMUL=True
		   sed -e 's/SGX_MODE=.*/SGX_MODE=SW/g' .env > .env.tmp && mv .env.tmp .env;;
		t) TERMINALS=True;;
		\?) echo "Invalid option: -$OPTARG" >&2
			exit 1;;
	esac
done

if [ ! $SIMUL ]; then
	if [ ! -c /dev/isgx ]; then
		echo "Error: SGX driver not found. Run in simulation mode instead with:"
		echo "$0 $@ -s"
		exit 1
	fi
	ARGF="$ARGF -f docker-compose.hw.yml"
fi
if [ ! $DEVELOP ]; then
	ARGF="$ARGF -f docker-compose.override.yml"
fi
launch
