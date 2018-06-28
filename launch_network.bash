#!/bin/bash

docker-compose up -d
echo 'Waiting for Truffle to launch...'
sleep 5
echo "Deploying contracts on testnet..."
docker-compose exec contract bash -c "rm -rf build"
docker-compose exec contract bash -c "~/darq-truffle migrate --reset"
echo "Starting Surface listener..."
docker-compose exec surface bash -c "python -m pytest surface/src/tests/test_listener.py" &
echo "Registering worker and creating task..."
docker-compose exec contract node ./integration/coin-mixer.js --with-register
