#!/bin/bash

set -e

docker-compose down
if [[ $(docker volume ls|grep keosd-data-volume) ]] 
then
    docker volume rm keosd-data-volume
fi

if [[ $(docker volume ls| grep nodeos-data-volume) ]]
then
    docker volume rm nodeos-data-volume
fi

docker volume create nodeos-data-volume
docker volume create keosd-data-volume
docker-compose up -d

cleos() {
    docker-compose exec -T keosd cleos -u http://nodeosd:8888 --wallet-url http://localhost:8888 $@
}
eosio-cpp() {
    docker run -i -t 
        --user "$(id -u):$(id -g)" \ 
        --rm -v ${PWD}:/mnt -w /mnt eos-cdt eosio-cpp $@
}

password=$(cleos wallet create | tail -n1 | tr -d '"')

cleos wallet open
cleos wallet unlock << EOF
$password
EOF

pubkey=$(cleos wallet create_key | grep -Eo 'EOS\w+')
cleos create account eosio alice ${pubkey}

cleos set contract alice callindirect/ -p alice@active
cleos push action alice hi '["alice"]' -p alice@active