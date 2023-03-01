#!/bin/bash


if ! command -v stress; then
    sudo apt-get update
    sudo apt-get install stress
fi
while true; do
    echo "Loading CPU.."
    stress -c 1 -t $(( $RANDOM % 60 ))
    echo "Sleeping.."
    sleep $(( $RANDOM % 60 ))
done


