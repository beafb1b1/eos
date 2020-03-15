#!/usr/bin/env python3

import subprocess
import sys
import json

cleos_cmd = '../../build/programs/cleos/cleos --wallet-url http://localhost:6666 --url http://localhost:{} '.format(8001)
nodeos_cmd = '../../build/programs/nodeos/nodeos'
contracts_dir = '../../vmie/poc/growmemory'

logFile = open('./output.log', 'a')

def run(args):
    print('deploy contract:', args)
    logFile.write(args + '\n')
    try:
        process = subprocess.run(args, shell=True, stdout=subprocess.PIPE, check=True)
    except subprocess.CalledProcessError as e:
        raise e
    return process

def jsonArg(a):
    return " '" + json.dumps(a) + "' "


current_user = 'useraaaaaaaa'
# deploy contract
run(cleos_cmd + f'set contract {current_user} {contracts_dir} -p {current_user}@active')

# set memory but allow failure
try:
    run(cleos_cmd + f'''push action {current_user} setmem {jsonArg(['bob'])} -p {current_user}@active''')
except subprocess.CalledProcessError as e:
    print('deploy contract:', '预定的失败, yeah!')
else:
    assert(1==0)

# read memory
run(cleos_cmd + f''' push action {current_user} readmem '[]' -p {current_user}@active ''')
# change database
run(cleos_cmd + f''' push action {current_user} insert {jsonArg([current_user])} -p {current_user}@active''')
# get balance
run(cleos_cmd + f'get table eosio.token {current_user} accounts')
# transfer based on database
auth = {
    "threshold": 1,
    "keys": [
        {
            "key": "EOS69X3383RzBZj41k73CSjUNXM5MYGpnDxyPnWUKPEtYQmTBWz4D",
            "weight": 1
        }
    ],
    "accounts": [
        {
            "permission": {
                "actor": "useraaaaaaaa",
                "permission": "eosio.code"
            },
            "weight": 1
        }
    ]
}
run(cleos_cmd + f' set account permission {current_user} active {jsonArg(auth)} owner -p {current_user}@active')
run(cleos_cmd + f''' push action {current_user} dotransfer {jsonArg([current_user, 'useraaaaaaab'])} -p {current_user}@active''')