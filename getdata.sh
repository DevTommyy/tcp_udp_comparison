#!/bin/bash

# NOTE this takes approximately 40 seconds at least

# Compile sender and receiver
cd sender || exit
cargo build --release &
cd ..

cd receiver || exit
cargo build --release &
cd ..

# Wait for sender and receiver programs to finish compiling
wait

# Set the number of iterations based on the first argument or default to 100
iterations=${1:-100}


for ((i = 0; i < iterations; i++)); do
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
