#!/bin/bash

compare_files () 
{ 
    if [ $# -ne 2 ]; then
        echo "Usage: compare_files file1 file2";
        return 1;
    fi;
    if diff "$1" "$2" > /dev/null; then
        echo "The files are identical";
    else
        echo "The files are different";
        echo "Here are the differences:";
        diff "$1" "$2";
    fi
}

iterations=${1:-100}

# Change directory to where the script is located
cd "$(dirname "$0")" || exit

for ((i = 0; i < iterations; i++)); do
    # Run sender and receiver
    (cd receiver && cargo run --release > output.txt) &
    RECEIVER_PID=$!
    
    (cd sender && cargo run --release) &
    SENDER_PID=$!

    # Wait for sender and receiver programs to finish running
    wait $RECEIVER_PID
    wait $SENDER_PID

    # Compare files and count lines
    line_count=$(( $(compare_files ./receiver/output.txt ./sender/input.txt | wc -l) - 2 )) # the 2 are the preset lines of text

    # Append the count to packet_lost.txt
    echo "$line_count" >> ./data/packet_lost.txt

    sleep 1
done