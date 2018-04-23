#!/bin/bash

RAND_FILE=".random.dat"

###
if [ $# -ne 3 ]
then
    cat << END
usage: $0 <address> <user> <password>

END
    exit 1
fi
addr=$1
user=$2
password=$3

echo "Generating a random test file ..."
dd if=/dev/random of=${RAND_FILE} count=50000

echo "Testing Upload ${addr} ..."
curl -u ${user}:${password} -T "${RAND_FILE}" ftp://${addr}

echo "Testing Download ${addr} ..."
wget --user=${user} --password=${password} -P ./ ftp://${addr}/${RAND_FILE} -O /dev/null

echo "Cleaning rubbish ..."
rm -vf ${RAND_FILE}
