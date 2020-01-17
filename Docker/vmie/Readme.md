# Development Environment

## Start dockers and set the alias

```shell
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
cleos create account eosio bob EOS8bNsXebEosXA5gLgGbPdn121c1QmZHJT8d4BYJvM76wW48p93M 
cleos create account eosio alice EOS8bNsXebEosXA5gLgGbPdn121c1QmZHJT8d4BYJvM76wW48p93M
```

## Using Different Keys for Active/Owner on a PRODUCTION Network

```shell
cleos get account alice
```



# Smart contract development

Refer to: https://developers.eos.io/eosio-home/docs/your-first-contract

```shell
cleos create account eosio hello EOS8bNsXebEosXA5gLgGbPdn121c1QmZHJT8d4BYJvM76wW48p93M -p eosio@active
```
