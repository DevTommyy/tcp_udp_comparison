#!/bin/bash

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