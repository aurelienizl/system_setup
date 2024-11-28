#!/bin/bash

LOG_DIR="/tmp/setup_exploitation_system"
LOG_FILE="$LOG_DIR/main.log"

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Function to log messages with color
log_message() {
    local color=$1
    local message=$2
    echo -e "${color}$(date +'%Y-%m-%d %H:%M:%S') : ${message}${NC}" | tee -a $LOG_FILE
}

# Create log directory if it doesn't exist
mkdir -p $LOG_DIR

log_message $BLUE "Starting setup..."

# Update and Upgrade the System
log_message $BLUE "Updating and upgrading the system..."
if sudo apt update && sudo apt upgrade -y; then
    log_message $GREEN "System updated and upgraded successfully."
else
    log_message $RED "Error updating and upgrading the system."
    exit 1
fi

# Prompt for SSH Key Passphrase
read -sp "Enter the passphrase to decrypt the SSH key: " SSH_KEY_PASSPHRASE
echo  # move to a new line after the user input

# Decrypt SSH Key
log_message $BLUE "Decrypting SSH key..."
ENCRYPTED_KEY_PATH="id_rsa.enc"
DECRYPTED_KEY_PATH="$HOME/.ssh/id_rsa"
mkdir -p $HOME/.ssh
if echo $SSH_KEY_PASSPHRASE | openssl aes-256-cbc -d -in $ENCRYPTED_KEY_PATH -out $DECRYPTED_KEY_PATH -pass stdin -iter 1000; then
    chmod 600 $DECRYPTED_KEY_PATH
    eval "$(ssh-agent -s)"
    ssh-add $DECRYPTED_KEY_PATH
    ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub
    log_message $GREEN "SSH key decrypted and added to ssh-agent successfully."
else
    log_message $RED "Error decrypting SSH key."
    exit 1
fi

# Run Package Installation
log_message $BLUE "Running package installation..."
if ./packages.sh; then
    log_message $GREEN "Package installation script completed."
else
    log_message $RED "Package installation script failed."
    exit 1
fi

# Run Application Installation
log_message $BLUE "Running application installation..."
if ./applications.sh; then
    log_message $GREEN "Application installation script completed."
else
    log_message $RED "Application installation script failed."
    exit 1
fi

log_message $GREEN "Setup completed successfully."
