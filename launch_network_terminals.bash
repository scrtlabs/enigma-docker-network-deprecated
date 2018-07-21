#!/bin/bash

if [[ "$DEVELOP" -eq 1 ]]; then
	echo "Launching Docker Enigma Network in development mode..."
	ARGF="-f docker-compose.develop.yml"
	SRFD="~/wrapper-develop.bash &&"
else
	ARGF=""
	SRFD=""
fi

# Force rebuild of images every run
docker-compose $ARGF build
if [[ ! $? -eq 0 ]]; then
	exit
fi

# Alternatively: `docker-compose up -d`, but by launching it in the background, 
# we capture the output on the current terminal & we can see the list of 
# accounts that ganache creates (different every time)
docker-compose $ARGF up &
echo 'Waiting for terminals to spawn...'
sleep 5
xterm -T 'Enigma Contract' -geometry 90x20+20+20 -e "docker attach enigma_contract_1" &
xterm -T 'Enigma Core' -geometry 120x20+600+20 -e "docker attach enigma_core_1" &
echo 'Waiting for contract to be available...'

CONTRACT_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' enigma_contract_1)
while :
do
	# nc -z $CONTRACT_IP 8545
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
xterm -T 'Enigma DApp' -geometry 152x20+20+330 -e "docker-compose $ARGF exec contract bash -c \"cd enigma-contract && node integration/coin-mixer.js --url=http://enigma_contract_1:8545; bash\"" &
echo "Starting Surface..."
xterm -T 'Enigma Surface' -geometry 120x20+900+80 \
	  -e  "docker-compose $ARGF exec surface bash -c \"$SRFD ./wait_launch.bash\""  &
