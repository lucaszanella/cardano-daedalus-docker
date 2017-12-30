#!/usr/bin/env bash

set -e

xhost local:docker

mkdir -p daedalus-config
mkdir -p nssdb

# NOTE: this is in no way foolproof
docker ps -a | grep cardano_cardano-sl_1 > /dev/null || sudo rm -f state-wallet-mainnet/wallet-db/open.lock

docker-compose -p cardano up -d cardano-sl
docker-compose -p cardano up daedalus
