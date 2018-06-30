#!/bin/bash
docker build --build-arg SSH_PRIVATE_KEY="$SSH_PRIVATE_KEY" -t enigmampc/enigma-contract .
