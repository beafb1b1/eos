#!/bin/bash

set -e
# apt update && apt install -y curl

keosd --http-server-address=127.0.0.1:9999 &

nodeos -e -p eosio \
    --http-server-address=127.0.0.1:8888 \
    --plugin eosio::producer_plugin \
    --plugin eosio::producer_api_plugin \
    --plugin eosio::chain_api_plugin \
    --plugin eosio::wallet_api_plugin\
    --plugin eosio::http_plugin \
    --plugin eosio::history_plugin \
    --plugin eosio::history_api_plugin \
    --filter-on="*" \
    --access-control-allow-origin='*' \
    --contracts-console >> nodeos.log 2>&1 &

cleos_cmd() {
    cleos -u http://localhost:8888 --wallet-url http://localhost:9999 $@
}

sleep 0.5

password=$(cleos_cmd wallet create | tail -n1 | tr -d '"')

cleos_cmd wallet open
cleos_cmd wallet unlock << EOF
$password
EOF

pubkey=$(cleos_cmd wallet create_key | grep -Eo 'EOS\w+')
cleos_cmd create account eosio alice ${pubkey}

cleos_cmd set contract alice poc/callindirect/ -p alice@active
cleos_cmd push action alice hi '["alice"]' -p alice@active

# cleos -u http://localhost:8888 --wallet-url http://localhost:9999 $@
# curl http://localhost:8888/v1/chain/get_info
