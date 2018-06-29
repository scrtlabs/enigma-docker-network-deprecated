#!/bin/bash

docker-compose up -d
xterm -geometry 90x24+20+20 -e "docker attach enigma_contract_1" &
xterm -geometry 100x24+600+20 -e "docker attach enigma_core_1" &
echo 'Waiting for terminals to spawn...'
sleep 10
echo "Deploying contracts on testnet..."
docker-compose exec contract bash -c "rm -rf ~/build/contracts/*"
docker-compose exec contract bash -c "~/darq-truffle migrate --reset --network ganache"
echo "Starting Surface..."
xterm -geometry 100x24+600+380 -e  "docker-compose exec surface bash -c ./wait_launch.bash"  &
