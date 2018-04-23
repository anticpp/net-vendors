#!/bin/bash

if [ $# -ne 1 ]
then
    cat << END
usage: $0 <address>

END
    exit 1
fi
addr=$1

echo "Testing Upload ${addr}"
curl -u xlftp:xlftp1212 -T "random.dat" ftp://${addr}

echo "Testing Download ${addr}"
wget --user=xlftp --password=xlftp1212 -P ./ ftp://${addr}/random.dat -O /dev/null
