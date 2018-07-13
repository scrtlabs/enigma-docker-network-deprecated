#!/bin/bash
cd ~/enigma-contract && rm -rf node_modules && npm install && npm install darq-truffle@next ganache-cli
ln -f -s ~/enigma-contract/node_modules/darq-truffle/build/cli.bundled.js ~/darq-truffle
ln -f -s ~/enigma-contract/node_modules/ganache-cli/build/cli.node.js ~/ganache-cli
