#!/bin/zsh

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

# Change directory to the directory of the script
cd "$(dirname "$0")" || exit

# Compile sender and receiver
cd sender || exit
cargo build --release &
cd ..

cd receiver || exit
cargo build --release &
cd ..

# Wait for sender and receiver programs to finish compiling
wait

# Run sender and receiver
cd receiver || exit
./target/release/second_peer > output.txt &
cd ..

cd sender || exit
./target/release/first_peer &
cd ..

# Wait for sender and receiver programs to finish running
wait

# Compare files
compare_files ./receiver/output.txt ./sender/input.txt > ./comparison.txt

echo "Comparison completed and saved to comparison.txt"
