#!/bin/bash

LOG_DIR="/tmp/setup_exploitation_system"
LOG_FILE="$LOG_DIR/applications.log"
TEMP_DIR="/tmp"

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') : $1" | tee -a $LOG_FILE
}

# Create log directory if it doesn't exist
mkdir -p $LOG_DIR

log_message "Starting application installation..."

# Install JetBrains Toolbox
log_message "Installing JetBrains Toolbox..."
JETBRAINS_TOOLBOX_URL="https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.24.12080.tar.gz"
if curl -L $JETBRAINS_TOOLBOX_URL -o $TEMP_DIR/jetbrains-toolbox.tar.gz; then
    tar -xzf $TEMP_DIR/jetbrains-toolbox.tar.gz -C $TEMP_DIR
    sudo mv $TEMP_DIR/jetbrains-toolbox-*/jetbrains-toolbox /usr/local/bin/
    rm -rf $TEMP_DIR/jetbrains-toolbox-*
    jetbrains-toolbox &
    log_message "JetBrains Toolbox installed successfully."
else
    log_message "Error downloading JetBrains Toolbox."
    exit 1
fi

# Install Visual Studio Code
log_message "Installing Visual Studio Code..."
if curl -L https://go.microsoft.com/fwlink/?LinkID=760868 -o $TEMP_DIR/vscode.deb; then
    if sudo apt install -y $TEMP_DIR/vscode.deb; then
        rm $TEMP_DIR/vscode.deb
        log_message "Visual Studio Code installed successfully."
    else
        log_message "Error installing Visual Studio Code."
        exit 1
    fi
else
    log_message "Error downloading Visual Studio Code."
    exit 1
fi

# Install Discord
log_message "Installing Discord..."
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
if curl -L $DISCORD_URL -o $TEMP_DIR/discord.deb; then
    if sudo apt install -y $TEMP_DIR/discord.deb; then
        rm $TEMP_DIR/discord.deb
        log_message "Discord installed successfully."
    else
        log_message "Error installing Discord."
        exit 1
    fi
else
    log_message "Error downloading Discord."
    exit 1
fi

log_message "Application installation completed."