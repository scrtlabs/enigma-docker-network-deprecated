#!/bin/bash

docker-compose up &
xterm -geometry 90x24+20+20 -e "docker attach enigma_contract_1" &
echo 'Waiting for terminal to spawn...'
sleep 10
echo "Deploying contracts on testnet..."
docker-compose exec contract bash -c "rm -rf build"
docker-compose exec contract bash -c "~/darq-truffle migrate --reset"
echo "Starting Surface listener..."
xterm -geometry 80x24+600+20 -e  "docker-compose exec surface python -m pytest surface/src/tests/test_listener.py" &
sleep 10
echo "Registering worker and creating task..."
xterm -geometry 80x24+760+220 -e "docker-compose exec contract node ./integration/coin-mixer.js --with-register" &