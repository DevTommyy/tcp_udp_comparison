#!/bin/zsh

# -- Utility

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

compare_files() { 
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

# -- Actions
run() {
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

    echo "Run finished, comparison saved to comparison.txt"
}

getdata() {
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
        echo "Iteration: $((i + 1))"

        # Run sender and receiver
        cd receiver || exit
        ./target/release/second_peer > /dev/null &
        cd ..

        cd sender || exit
        ./target/release/first_peer &
        cd ..

        sleep 0.4
    done
}

getloss() {
    # Set the number of iterations based on the first argument or default to 100
    iterations=${1:-100}

    # Change directory to where the script is located
    cd "$(dirname "$0")" || exit

    for ((i = 0; i < iterations; i++)); do
        echo "Iteration: $((i + 1))"
        # Run sender and receiver
        (cd receiver && cargo run --release -q > output.txt) &
        RECEIVER_PID=$!
        
        (cd sender && cargo run --release -q) &
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
}


clean() {
    # Path to the receiver and sender directories
    RECEIVER_DIR="receiver"
    SENDER_DIR="sender"

    # Run cargo clean in the receiver directory
    echo "Cleaning receiver directory..."
    (cd "$RECEIVER_DIR" && cargo clean)

    # Run cargo clean in the sender directory
    echo "Cleaning sender directory..."
    (cd "$SENDER_DIR" && cargo clean)

    echo "Cleaning completed."
}

help() {
    echo "Usage: ${GREEN}./runner.sh [action]${NC}"
    echo ""
    echo "Available actions:"
    echo "  ${GREEN}run${NC}                : Run sender and receiver, then compare files."
    echo "  ${GREEN}getdata ${BLUE}[option]${NC}   : Run sender and receiver multiple times for data collection."
    echo "  ${GREEN}getloss ${BLUE}[option]${NC}   : Run sender and receiver multiple times for packet loss data collection."
    echo "  ${GREEN}clean${NC}              : Clean sender and receiver directories."
    echo ""
    echo "For furthermore information run ${GREEN}./runner.sh [action] ${BLUE}help${NC}." 
}

help_run() {
    echo "Usage: ${GREEN}./runner.sh run${NC}"
    echo ""
    echo "Description:"
    echo "  Run sender and receiver, then compare files."
}

help_getdata() {
    echo "Usage: ${GREEN}./runner.sh getdata [option]${NC}"
    echo ""
    echo "Description:"
    echo "  Run sender and receiver multiple times for data collection."
    echo "  ${BLUE}[option]${NC} specifies the number of iterations. Default is 100."
}

help_getloss() {
    echo "Usage: ${GREEN}./runner.sh getloss [option]${NC}"
    echo ""
    echo "Description:"
    echo "  Run sender and receiver multiple times for packet loss data collection."
    echo "  ${BLUE}[option]${NC} specifies the number of iterations. Default is 100."
}

help_clean() {
    echo "Usage: ${GREEN}./runner.sh clean${NC}"
    echo ""
    echo "Description:"
    echo "  Clean sender and receiver directories."
}


# Check if no arguments are provided
if [[ $# -eq 0 ]]; then
    echo "${RED}error${NC}: no action provided"
    echo ""
    echo "run \`./runner.sh help\` to see all the available actions"
    exit 1
fi

action=$1

# Perform actions based on the flag
case $action in
    "run")
        if [[ "$2" == "help" ]]; then
            help_run
            exit 0
        else
            run
            exit 0
        fi
        ;;
    "getdata")
        if [[ "$2" == "help" ]]; then
            help_getdata
            exit 0
        else
            getdata $2
            exit 0
        fi
        ;;
    "getloss")
        if [[ "$2" == "help" ]]; then
            help_getloss
            exit 0
        else
            getloss $2
            exit 0
        fi
        ;;
    "clean")
        if [[ "$2" == "help" ]]; then
            help_clean
            exit 0
        else
            clean
            exit 0
        fi
        ;;
    "help")
        help
        exit 0
        ;;
    *) 
        echo "${RED}error${NC}: invalid action"
        echo ""
        echo "run './runner.sh help' to see all the available actions"
        exit 1
        ;;
esac
