#!/bin/bash

# Force rebuild of images every run
docker-compose $ARGF build
if [[ ! $? -eq 0 ]]; then
	exit
fi

docker-compose up &
echo 'Waiting for containers to start...'
echo 'Starting core...'
echo 'Starting enigma-contract...'
sleep 5

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
docker-compose exec contract bash -c "rm -rf ~/enigma-contract/build/contracts/*"
docker-compose exec contract bash -c "cd enigma-contract && ~/darq-truffle migrate --reset --network ganache"
echo "Starting coin-mixer app..."
docker-compose exec -d contract bash -c "cd enigma-contract && node integration/coin-mixer.js --url=http://enigma_contract_1:8545"
sleep 5
echo "Starting Surface..."
docker-compose exec -d surface bash -c "./wait_launch.bash"
