#!/bin/bash

# Configuration specific to the docker network
sed -i'' -e "s#\(\"IPC_HOST\": \)\(\".*\"\)#\1\"core$DEVELOP\"#g" ~/surface/src/surface/config.json
sed -i'' -e "s#\(\"PROVIDER_URL\": \)\(\".*\"\)#\1\"http://contract$DEVELOP:8545\"#g" ~/surface/src/surface/config.json
sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/surface/config.json 
sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/surface/config.json 

# Tests (TMP)
sed -i'' -e "s/localhost/contract$DEVELOP/g" ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("CONTRACT_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/Enigma.json"#g'  ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("TOKEN_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/EnigmaToken.json"#g'  ~/surface/src/tests/data/config.json
sed -i'' -e 's#\("COIN_MIXER_PATH": \)\(".*"\)#\1"/var/lib/built_contracts/CoinMixer.json"#g'  ~/surface/src/tests/data/config.json