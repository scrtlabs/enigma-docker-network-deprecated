#!/bin/bash

docker-compose up &
echo 'Waiting for containers to start...'
echo 'Starting core...'
echo 'Starting enigma-contract...'
sleep 5
echo "Deploying contracts on testnet..."
docker-compose exec contract bash -c "rm -rf ~/enigma-contract/build/contracts/*"
docker-compose exec contract bash -c "cd enigma-contract && ~/darq-truffle migrate --reset --network ganache"
echo "Starting Surface..."
docker-compose exec surface bash -c "./wait_launch.bash" 

# When everything is ready, trigger a computation by running from another terminal:
# docker-compose exec contract bash -c "node integration/coin-mixer.js --with-register"
