# Quick Start Guide

## Installation (5 minutes)

### Step 1: Install Dependencies
```bash
python3 -m pip install --user watchdog
```

### Step 2: Configure
```bash
cd /home/what/Local_Git
nano clean_config.env
```

Edit these two lines:
```bash
export WATCH_DIR="/home/your_user/your_workspace"
export LOG_FILE="/home/your_user/file_tracker.log"
```

### Step 3: Install Service
```bash
./install_tracker.sh
```

### Step 4: Verify Installation
```bash
sudo systemctl status file_tracker@$(whoami).service
```

## Quick Test

### Test File Monitoring
```bash
# In terminal 1: Watch logs
tail -f ~/file_tracker.log

# In terminal 2: Make changes
cd /your/workspace
echo "test" > test_file.txt

# You should see auto-commit in terminal 1
```

### Test Cleanup Script
```bash
source clean_config.env
./clean_file_tracker.sh
```

Check cleanup log:
```bash
cat /var/log/file_tracker_clean.log
```

## Common Commands

```bash
# Start service
sudo systemctl start file_tracker@$(whoami).service

# Stop service
sudo systemctl stop file_tracker@$(whoami).service

# Check status
sudo systemctl status file_tracker@$(whoami).service

# View logs
tail -f ~/file_tracker.log

# Manual cleanup
source clean_config.env && ./clean_file_tracker.sh

# Check Git size
du -sh /your/workspace/.git
```

## Troubleshooting

### Service won't start
```bash
# Check logs
sudo journalctl -u file_tracker@$(whoami).service -n 50

# Common fix: Install watchdog
python3 -m pip install --user watchdog
```

### Cleanup errors
```bash
# Check if config is loaded
echo $WATCH_DIR
echo $LOG_FILE

# If empty, load config
source clean_config.env
```

### Permission denied
```bash
# Fix log file permissions
chmod 644 ~/file_tracker.log

# Fix script permissions
chmod +x clean_file_tracker.sh
```

## Daily Usage

Once installed, the system runs automatically:
- File changes are committed immediately
- Cleanup runs every hour (via cron)
- Backups are created before cleanup
- Old backups deleted after 7 days

No manual intervention needed!

## Next Steps

Read full documentation: [README.md](README.md)

For advanced configuration and troubleshooting, see the README.
