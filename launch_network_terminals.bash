#!/bin/bash

# Alternatively: `docker-compose up -d`, but by launching it in the background, 
# we capture the output on the current terminal & we can see the list of 
# accounts that ganache creates (different every time)
docker-compose build
docker-compose up &
xterm -geometry 90x20+20+20 -e "docker attach enigma_contract_1" &
xterm -geometry 120x20+600+20 -e "docker attach enigma_core_1" &
echo 'Waiting for terminals to spawn...'
sleep 10
echo "Deploying contracts on testnet..."
docker-compose exec contract bash -c "rm -rf ~/enigma-contract/build/contracts/*"
docker-compose exec contract bash -c "cd enigma-contract && ~/darq-truffle migrate --reset --network ganache"
echo "Starting coin-mixer app..."
xterm -geometry 152x20+20+330 -e 'docker-compose exec contract bash -c "cd enigma-contract && node integration/coin-mixer.js; bash"' &
echo "Starting Surface..."
xterm -geometry 120x20+900+80 \
	  -e  "docker-compose exec surface bash -c ./wait_launch.bash"  &
