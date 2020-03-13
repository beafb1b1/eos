#!/usr/bin/env python3

import subprocess
import sys
import json

cleos_cmd = '../../build/programs/cleos/cleos --wallet-url http://localhost:6666 --url http://localhost:{} '.format(8000)
nodeos_cmd = '../../build/programs/nodeos/nodeos'
contracts_dir = '../../vmie/poc/growmemory'

logFile = open('./output.log', 'a')

def run(args):
    print('deploy contract:', args)
    logFile.write(args + '\n')
    try:
        process = subprocess.run(args, shell=True, stdout=subprocess.PIPE, check=True)
    except subprocess.CalledProcessError as e:        # print('deploy contract: exiting because of error')
        raise e
    return process

def jsonArg(a):
    return " '" + json.dumps(a) + "' "


current_user = 'useraaaaaaaa'
# buy mem
# run(cleos_cmd + f'system buyram {current_user} {current_user} "10 SYS"')

# deploy contract
run(cleos_cmd + f'set contract {current_user} {contracts_dir} -p {current_user}@active')

# set memory but allow failure
try:
    run(cleos_cmd + f'''push action {current_user} setmem {jsonArg(['bob'])} -p {current_user}@active''')
except subprocess.CalledProcessError as e:
    print("预定的失败")
else:
    assert(1==0)

# read memory
run(cleos_cmd + f''' push action {current_user} readmem '[]' -p {current_user}@active ''')

# cleos_cmd set contract alice poc/growmemory/ -p alice@active
# cleos_cmd push action alice setmem '['bob']' -p alice@active || true
# cleos_cmd push action alice readmem '[]' -p alice@active
# cleos_cmd push action alice insert '['alice']' -p alice@active
