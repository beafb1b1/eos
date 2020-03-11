#!/bin/bash

set -e
# apt update && apt install -y curl

echo "[!] Clean the environment..."
killall -q nodeos || true
killall -q keosd || true
rm -rf .keosd/
rm -rf .nodeos/

echo "[!] Start keosd..."
mkdir .keosd && \
keosd --http-server-address=127.0.0.1:9999 \
    -d .keosd \
    > /dev/null 2>&1 &

echo "[!] Start nodeos..."
nodeos -e -p eosio \
    -d .nodeos/ \
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

read -n1 -r -p "Press any key to continue..." key

cleos_cmd() {
    cleos -u http://localhost:8888 --wallet-url http://localhost:9999 $@
}

sleep 1

echo "[!] Create wallet..."
password=$(cleos_cmd wallet create | tail -n1 | tr -d '"')

echo "[!] Unlock the wallet..."
cleos_cmd wallet open
cleos_cmd wallet unlock << EOF
$password
EOF

pubkey=$(cleos_cmd wallet create_key | grep -Eo 'EOS\w+')
cleos_cmd create account eosio alice ${pubkey}

cleos_cmd set contract alice poc/growmemory/ -p alice@active
# cleos_cmd push action alice setmem '[]' -p alice@active
cleos_cmd push action alice readmem '[]' -p alice@active
cleos_cmd push action alice insert '['alice']' -p alice@active
# bash

# cleos -u http://localhost:8888 --wallet-url http://localhost:9999 $@
# curl http://localhost:8888/v1/chain/get_info
