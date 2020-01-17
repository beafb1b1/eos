# Development Environment

## Start dockers and set the alias

```shell
docker volume create nodeos-data-volume; docker volume create keosd-data-volume;
# docker volume rm nodeos-data-volume; docker volume rm keosd-data-volume;

docker-compose up -d
alias cleos='docker-compose exec keosd cleos -u http://nodeosd:8888 --wallet-url http://localhost:8888'
alias eosio-cpp='docker run -i -t --rm -v ${PWD}:/mnt -w /mnt eos-cdt eosio-cpp'
```

## Create a wallet
```shell
cleos wallet create
```
Creating wallet: default
Save password to use in the future to unlock this wallet.
Without password imported keys will not be retrievable.
"PW5JocVLAwAeBhqqgghuXRbTLj2hrqqgQZoK36YqA9jtGqLmHW8wh"

## Open and Unlock the wallet
```shell 
cleos wallet open
cleos wallet unlock
```
Unlocked: default

## Import keys into wallet

### create wallet key
```shell
cleos wallet create_key
```
Created new private key with a public key of: "EOS8bNsXebEosXA5gLgGbPdn121c1QmZHJT8d4BYJvM76wW48p93M"

### Import the Dev key
It should already in wallet.


## Create test accounts
```shell
cleos create account eosio bob ${PREV_PUBKEY}
cleos create account eosio alice ${PREV_PUBKEY}
```

## Using Different Keys for Active/Owner on a PRODUCTION Network

```shell
cleos get account alice
```



# Smart contract development

Refer to: https://developers.eos.io/eosio-home/docs/your-first-contract

## hello-world example

调用说明：
    
`cleos set contract [account] [contract-dir] [wast-file] [abi-file] -p account@permission`

`cleos push contract action [account] [action] [data] -p account@permission`

```shell
eosio-cpp hello.cpp -o hello.wasm

# 创建名为hello的账户
cleos create account eosio hello ${PREV_PUBKEY} -p eosio@active

# 以hello的身份部署hello合约
cleos set contract hello hello/ -p hello@active

# 以bob身份调用hello合约
cleos push action hello hi '["bob"]' -p bob@active
```


