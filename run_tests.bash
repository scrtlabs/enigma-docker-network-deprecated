#!/bin/bash

docker-compose up -d
echo 'Waiting for Truffle to launch...'
sleep 5
docker-compose exec enigma-contract bash -c "rm -rf build"
docker-compose exec enigma-contract bash -c "~/darq-truffle migrate --reset"
docker-compose exec enigma-contract bash -c "~/darq-truffle test"
docker-compose down
