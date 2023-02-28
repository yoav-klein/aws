#!/bin/bash



json=$(./run_tf.sh output -json)
list=($(echo $json | jq -r '.public_dns.value[]'))


start() {
    for ip in ${list[@]}; do
        echo "starting on $ip"
        scp -o StrictHostKeyChecking=false -i aws load.sh ubuntu@$ip:~
        ssh -o StrictHostKeyChecking=false -i aws ubuntu@$ip  'nohup </dev/null >load.out 2>load.err bash load.sh & echo $! > pid'
    done
}

stop() {
    for ip in ${list[@]}; do
        echo "stopping on $ip"
        ssh -o StrictHostKeyChecking=false -i aws ubuntu@$ip  'kill -9 $(cat pid)' < load.sh
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
 

