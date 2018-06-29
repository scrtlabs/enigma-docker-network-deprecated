#!/bin/bash

# Configuration specific to the docker network
sed -i'' -e "s/localhost/core$DEVELOP/g" ~/surface/src/surface/communication/core/ipc.py
sed -i'' -e "s/localhost/contract$DEVELOP/g" ~/surface/src/surface/config.json
sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/surface/config.json 
sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/surface/config.json 

# Tests (TMP)
sed -i'' -e "s/localhost/contract$DEVELOP/g" ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("COIN_MIXER_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/CoinMixer.json"#g'  ~/surface/src/tests/data/config.json