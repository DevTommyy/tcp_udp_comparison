#!/bin/bash

# this takes approximately 40 seconds at least

for ((i = 0; i < 100; i++)); do
    echo "Iteration: $i"

    # Run sender and receiver
    cd receiver || exit
    ./target/release/second_peer > /dev/null &
    cd ..

    cd sender || exit
    ./target/release/first_peer &
    cd ..

    sleep 0.4
done
