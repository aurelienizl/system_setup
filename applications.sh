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
JETBRAINS_TOOLBOX_URL="https://download-cdn.jetbrains.com/toolbox/jetbrains-toolbox-2.4.2.32922.tar.gz"
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

# Configure Visual Studio Code

# Create User directory for Visual Studio Code
mkdir -p ~/.config/Code/User

# Create settings.json file with configurations
cat > ~/.config/Code/User/settings.json <<EOL
{
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true,
    "editor.minimap.enabled": false,
    "editor.suggestSelection": "first",
    "workbench.startupEditor": "newUntitledFile",
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "terminal.integrated.defaultProfile.linux": "bash",
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "editor.rulers": [80, 120],
    "editor.wordWrap": "on",
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "telemetry.telemetryLevel": "off"
}
EOL

log_message "Visual Studio Code configured successfully."


# Python extension for Visual Studio Code
code --install-extension ms-python.python
# C/C++ extension for Visual Studio Code
code --install-extension ms-vscode.cpptools
# Java extension for Visual Studio Code
code --install-extension redhat.java
# Docker extension for Visual Studio Code
code --install-extension ms-azuretools.vscode-docker
# Copilot extension for Visual Studio Code
code --install-extension github.copilot

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
