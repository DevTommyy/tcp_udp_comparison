#!/bin/zsh

# -- Utility
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
        echo "Here are the differences:";./xvjm
        diff "$1" "$2";
    fi
}

# Check if no arguments are provided
if [[ $# -eq 0 ]]; then
    echo "error: no action provided"
    echo ""
    echo "run \`./runner.sh help\` to see all the aviable actions"
    exit 1
fi

action=$1

# Perform actions based on the flag
case $action in
    "run")
        ;;
    "getdata")
        ;;
    "getloss")
        ;;
    "clean")
        ;;
    "help")
        ;;
    *) 
        echo "error: invalid action"
        echo ""
        echo "run \`./runner.sh help\` to see all the aviable actions"
        exit 1.
esac