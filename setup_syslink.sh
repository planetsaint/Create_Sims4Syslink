#!/bin/bash

# Sims 4 Mods External Drive Setup Script
# This script moves your Sims 4 mods to an external drive and creates a symbolic link

set -e # Exit on any error

echo "=================================="
echo "Sims 4 Mods External Drive Setup"
echo "=================================="
echo

# Get current username and home directory
CURRENT_USER=$(whoami)
echo "Running as user: $CURRENT_USER"
echo "Using home directory: $HOME"

# Define paths
SIMS4_PATH="$HOME/Documents/Electronic Arts/The Sims 4"
MODS_PATH="$SIMS4_PATH/Mods"
BACKUP_PATH="$SIMS4_PATH/Mods_backup"

echo
echo "Checking for existing Sims 4 installation..."

# Check if Sims 4 directory exists
if [ ! -d "$SIMS4_PATH" ]; then
  echo "❌ Error: Sims 4 directory not found at: $SIMS4_PATH"
  echo "Please make sure The Sims 4 is installed and has been run at least once."
  exit 1
fi

echo "✅ Found Sims 4 directory: $SIMS4_PATH"

# Check if Mods folder exists
if [ ! -d "$MODS_PATH" ]; then
  echo "❌ Error: Mods folder not found at: $MODS_PATH"
  echo "Please create a Mods folder or run the game once to generate it."
  exit 1
fi

echo "✅ Found Mods folder: $MODS_PATH"

# List available external drives
echo
echo "Available external drives:"
ls -la /Volumes/ | grep -v "^total" | grep -v "Macintosh HD" | awk '{print "  - " $9}' | grep -v "^  - $"

echo
read -p "Enter the name of your external drive (exactly as shown above): " DRIVE_NAME

# Validate external drive
EXTERNAL_DRIVE="/Volumes/$DRIVE_NAME"
if [ ! -d "$EXTERNAL_DRIVE" ]; then
  echo "❌ Error: External drive not found at: $EXTERNAL_DRIVE"
  echo "Please make sure the drive is connected and mounted."
  exit 1
fi

echo "✅ Found external drive: $EXTERNAL_DRIVE"

# Define external mods path
EXTERNAL_MODS_PATH="$EXTERNAL_DRIVE/Sims4/Mods"

echo
echo "Setup Summary:"
echo "  Source: $MODS_PATH"
echo "  Destination: $EXTERNAL_MODS_PATH"
echo "  Backup: $BACKUP_PATH"
echo

read -p "Continue with this setup? (y/n): " confirm_setup
if [[ $confirm_setup != "y" && $confirm_setup != "Y" ]]; then
  echo "Setup cancelled."
  exit 0
fi

echo
echo "Starting setup process..."

# Create Sims4 directory on external drive if it doesn't exist
echo "📁 Creating directory structure on external drive..."
mkdir -p "$EXTERNAL_DRIVE/Sims4"

# Check if there's already content in the external mods path
if [ -d "$EXTERNAL_MODS_PATH" ]; then
  echo "⚠️  Warning: Mods folder already exists on external drive"
  read -p "Do you want to overwrite it? (y/n): " overwrite
  if [[ $overwrite == "y" || $overwrite == "Y" ]]; then
    echo "🗑️  Removing existing external Mods folder..."
    rm -rf "$EXTERNAL_MODS_PATH"
  else
    echo "Setup cancelled to prevent data loss."
    exit 1
  fi
fi

# Copy mods to external drive
echo "📦 Copying Mods folder to external drive..."
echo "  This may take a while depending on the size of your mods..."
cp -R "$MODS_PATH" "$EXTERNAL_MODS_PATH"

if [ $? -eq 0 ]; then
  echo "✅ Successfully copied mods to external drive"
else
  echo "❌ Error copying mods to external drive"
  exit 1
fi

# Backup original mods folder
echo "💾 Creating backup of original Mods folder..."
if [ -d "$BACKUP_PATH" ]; then
  echo "⚠️  Backup folder already exists, removing old backup..."
  rm -rf "$BACKUP_PATH"
fi

mv "$MODS_PATH" "$BACKUP_PATH"
echo "✅ Original Mods folder backed up to: $BACKUP_PATH"

# Create symbolic link
echo "🔗 Creating symbolic link..."
ln -s "$EXTERNAL_MODS_PATH" "$MODS_PATH"

if [ $? -eq 0 ]; then
  echo "✅ Successfully created symbolic link"
else
  echo "❌ Error creating symbolic link"
  echo "🔄 Restoring original Mods folder..."
  mv "$BACKUP_PATH" "$MODS_PATH"
  exit 1
fi

# Verify the setup
echo
echo "🔍 Verifying setup..."
if [ -L "$MODS_PATH" ]; then
  echo "✅ Symbolic link created successfully"
  echo "  Link points to: $(readlink "$MODS_PATH")"
else
  echo "❌ Symbolic link verification failed"
  exit 1
fi

echo
echo "=================================="
echo "✅ Setup Complete!"
echo "=================================="
echo
echo "Your Sims 4 mods are now stored on your external drive."
echo "The game will access them normally through the symbolic link."
echo
echo "Important reminders:"
echo "  • Always connect your external drive before playing"
echo "  • Your original mods are backed up at: $BACKUP_PATH"
echo "  • If you need to restore, delete the Mods symlink and rename Mods_backup to Mods"
echo
echo "You can now launch The Sims 4 and your mods should work normally!"
echo
