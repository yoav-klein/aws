#!/bin/bash


if ! command -v stress; then
    sudo apt-get update
    sudo apt-get install stress
fi
while true; do
    echo "Loading.."
    stress -c 1 -t 20
    echo "Sleeping.."
    sleep 20
done


