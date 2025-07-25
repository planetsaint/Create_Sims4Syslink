# Sims 4 Mods External Drive Setup

A bash script to move your Sims 4 mods to an external drive and create a symbolic link so the game can still access them normally.

## What This Script Does

- **Automatically detects** your Sims 4 installation and mods folder for any user
- **Lists available external drives** for you to choose from
- **Creates a backup** of your original mods folder (`Mods_backup`)
- **Copies all mods** to your external drive in an organized folder structure
- **Creates a symbolic link** that makes the game think mods are still in the original location
- **Verifies the setup** to ensure everything works correctly

## Benefits

- **Free up disk space** on your main drive
- **Keep large mod collections** without storage concerns
- **Easy backup and organization** of your mods
- **Seamless gameplay** - the game works exactly as before

## Requirements

- macOS (works with any user account)
- The Sims 4 installed and run at least once
- An external drive with sufficient space
- Basic terminal access

## Installation & Usage

1. **Download the script:**
   ```bash
   # Navigate to a writable directory (like Downloads or Desktop)
   cd ~/Downloads
   
   # Download the script
   curl -O https://raw.githubusercontent.com/planetsaint/Create-Sims4Syslink/main/setup_syslink.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x setup_syslink.sh
   ```

3. **Connect your external drive** and make sure it's mounted

4. **Run the script:**
   ```bash
   ./setup_syslink.sh
   ```

5. **Follow the prompts** - the script will guide you through each step

## Example Usage

```bash
$ ./setup_syslink.sh

==================================
Sims 4 Mods External Drive Setup
==================================

Running as user: Wub
Using home directory: /Users/wub

✅ Found Sims 4 directory: /Users/wub/Documents/Electronic Arts/The Sims 4
✅ Found Mods folder: /Users/wub/Documents/Electronic Arts/The Sims 4/Mods

Available external drives:
  - MyExternalDrive
  - BackupDrive

Enter the name of your external drive: MyExternalDrive
✅ Found external drive: /Volumes/MyExternalDrive

Setup Summary:
  Source: /Users/wub/Documents/Electronic Arts/The Sims 4/Mods
  Destination: /Volumes/MyExternalDrive/Sims4/Mods
  Backup: /Users/wub/Documents/Electronic Arts/The Sims 4/Mods_backup

Continue with this setup? (y/n): y
```

## Safety Features

- **Backup creation** - your original mods are safely backed up
- **Path validation** - checks that all directories exist before proceeding
- **Confirmation prompts** - asks before making any changes
- **Error handling** - stops and provides clear messages if something goes wrong
- **Easy restoration** - simple instructions to revert changes if needed

## Troubleshooting

**If the game can't find your mods:**
- Ensure your external drive is connected and mounted
- Check that the symbolic link exists: `ls -la ~/Documents/Electronic\ Arts/The\ Sims\ 4/`
- You should see `Mods -> /Volumes/YourDrive/Sims4/Mods`

**To restore original setup:**
```bash
cd ~/Documents/Electronic\ Arts/The\ Sims\ 4/
rm Mods
mv Mods_backup Mods
```

**If you get permission errors:**
- Make sure you have write access to both the Sims 4 folder and external drive
- Try running with `sudo` if absolutely necessary (not recommended)

## File Structure

After running the script, your setup will look like this:

```
~/Documents/Electronic Arts/The Sims 4/
├── Mods -> /Volumes/YourDrive/Sims4/Mods  (symbolic link)
└── Mods_backup/                           (your original mods)

/Volumes/YourDrive/
└── Sims4/
    └── Mods/                              (your mods on external drive)
```

## Contributing

Feel free to submit issues or pull requests if you encounter problems or have suggestions for improvements.

## License

This script is provided as-is for personal use. Use at your own risk and always backup your save files before making changes to your Sims 4 installation.
