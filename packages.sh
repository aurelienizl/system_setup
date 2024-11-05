#!/bin/bash

LOG_DIR="/tmp/setup_exploitation_system"
LOG_FILE="$LOG_DIR/packages.log"

# Function to log messages
log_message() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') : $1" | tee -a $LOG_FILE
}

# Create log directory if it doesn't exist
mkdir -p $LOG_DIR

log_message "Starting package installation..."

PACKAGES=(
  "make"
  "gcc"
  "clang"
  "clang-format"
  "vim"
  "git"
  "htop"
  "curl"
  "wget"
  "libfuse2"
  "clamav" 
  "clamav-daemon"
)

for PACKAGE in "${PACKAGES[@]}"; do
  log_message "Installing $PACKAGE..."
  if sudo apt install -y $PACKAGE; then
    log_message "$PACKAGE installed successfully."
  else
    log_message "Error installing $PACKAGE."
    exit 1
  fi
done

# Setup some packages

git config --global user.name "Aurélien Izoulet"
git config --global user.email "aurelien.izoulet@epita.fr"

log_message "Package installation completed."
