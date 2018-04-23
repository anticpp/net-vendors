#!/bin/bash

TRACE_TMP=".trace.tmp"

###
if [ $# -ne 1 ] 
then
    cat << END
usage: $0 <target>

    target: 
        1. Address to trace, or
        2. Traceroute output. (traceroute xxx 2>/dev/null)

END
    exit 1
fi

target=$1

## If 'target' is an Address
if ! test -f ${target}
then
    echo "Tracing ${target} ..."
    traceroute ${target} 2>/dev/null > ${TRACE_TMP}
    target="${TRACE_TMP}"
fi

echo "Sorting out ..."
cat ${target} |grep '[0-9]\+ .*(.*)'| awk '{print $1"\t"substr($3, 2, length($3)-2)}' |
while read index ip
do 
    echo  "[${index}]\t${ip}"
    curl http://ip.taobao.com/service/getIpInfo.php?ip=${ip} 2>/dev/null| json_pp|jq '. | { country: .data.country, isp: .data.isp}'; 
done

echo "Cleaning rubbish ..."
rm -fv ${TRACE_TMP}
