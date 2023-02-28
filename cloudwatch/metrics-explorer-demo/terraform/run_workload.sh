#!/bin/bash



json=$(./run_tf.sh output -json)
list=($(echo $json | jq -r '.public_dns.value[]'))

start() {
    for ip in ${list[@]}; do
        echo "starting on $ip"
        ssh -o StrictHostKeyChecking=false -i aws ubuntu@$ip  'bash -s' < load.sh &
    done
}

stop() {
    for ip in ${list[@]}; do
        echo "stopping on $ip"
        ssh -o StrictHostKeyChecking=false -i aws ubuntu@$ip  'nohup bash -s &' < load.sh
    done
}

cmd=$1

usage() {
    echo "$0 start/stop"
}

if [ "$cmd" = "start" ]; then
    start
elif [ "$cmd" = "stop" ]; then
   stop
else
    usage
    exit 1
fi
 

