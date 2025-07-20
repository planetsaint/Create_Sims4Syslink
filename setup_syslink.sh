#!/bin/bash

# Script to create a symbolic link for Sims 4 Mods folder on macOS
# This allows the game to load mods from an external drive

# Color codes for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
  echo -e "${2}${1}${NC}"
}

# Clear screen and show header
clear
print_message "=== Sims 4 Mods Symbolic Link Setup ===" "$GREEN"
echo ""

# Define paths
# Default Sims 4 Mods location on macOS
SIMS4_DIR="$HOME/Documents/Electronic Arts/The Sims 4"
MODS_DIR="$SIMS4_DIR/Mods"

# External drive path - will be confirmed with user
EXTERNAL_DRIVE="/Volumes/Sims4"
EXTERNAL_MODS_DIR="$EXTERNAL_DRIVE/Mods"

# Step 1: Explain what the script will do
print_message "This script will:" "$YELLOW"
echo "1. Check if your external drive is connected"
echo "2. Backup any existing Mods folder in the Sims 4 directory"
echo "3. Create a symbolic link from the game's Mods folder to your external drive"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."
echo ""

# Step 2: Check if external drive is mounted
print_message "Checking for external drive..." "$YELLOW"
if [ ! -d "$EXTERNAL_DRIVE" ]; then
  print_message "Error: External drive 'Sims4' not found at $EXTERNAL_DRIVE" "$RED"
  print_message "Please make sure your external drive is connected and mounted." "$RED"
  exit 1
fi
print_message "✓ External drive found!" "$GREEN"

# Step 3: Check if external Mods folder exists
if [ ! -d "$EXTERNAL_MODS_DIR" ]; then
  print_message "Error: Mods folder not found at $EXTERNAL_MODS_DIR" "$RED"
  print_message "Please make sure you have a 'Mods' folder on your external drive." "$RED"
  exit 1
fi
print_message "✓ Mods folder found on external drive!" "$GREEN"
echo ""

# Step 4: Check if Sims 4 directory exists
if [ ! -d "$SIMS4_DIR" ]; then
  print_message "Error: Sims 4 directory not found at $SIMS4_DIR" "$RED"
  print_message "Please make sure The Sims 4 is installed." "$RED"
  exit 1
fi

# Step 5: Handle existing Mods folder
if [ -e "$MODS_DIR" ]; then
  # Check if it's already a symlink
  if [ -L "$MODS_DIR" ]; then
    print_message "A symbolic link already exists at $MODS_DIR" "$YELLOW"
    read -p "Do you want to replace it? (y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_message "Operation cancelled." "$YELLOW"
      exit 0
    fi
    # Remove existing symlink
    rm "$MODS_DIR"
    print_message "✓ Removed existing symbolic link" "$GREEN"
  else
    # It's a real folder, back it up
    print_message "Found existing Mods folder at $MODS_DIR" "$YELLOW"
    BACKUP_DIR="$MODS_DIR.backup.$(date +%Y%m%d_%H%M%S)"
    print_message "Creating backup at $BACKUP_DIR" "$YELLOW"
    mv "$MODS_DIR" "$BACKUP_DIR"
    print_message "✓ Backup created successfully" "$GREEN"
  fi
fi
echo ""

# Step 6: Create the symbolic link
print_message "Creating symbolic link..." "$YELLOW"
ln -s "$EXTERNAL_MODS_DIR" "$MODS_DIR"

# Step 7: Verify the symbolic link was created
if [ -L "$MODS_DIR" ] && [ -d "$MODS_DIR" ]; then
  print_message "✓ Success! Symbolic link created!" "$GREEN"
  echo ""
  print_message "The Sims 4 will now load mods from:" "$GREEN"
  echo "  $EXTERNAL_MODS_DIR"
  echo ""
  print_message "Important notes:" "$YELLOW"
  echo "• Make sure your external drive is connected before launching The Sims 4"
  echo "• The game won't be able to load mods if the external drive is disconnected"
  echo "• To undo this, simply delete the symbolic link and restore your backup"
else
  print_message "Error: Failed to create symbolic link" "$RED"
  exit 1
fi

print_message "Setup complete! Enjoy your game!" "$GREEN"
