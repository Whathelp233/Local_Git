#!/bin/bash
# Install file_tracker service and setup scheduled cleanup
# Author: WhatHelp233
# Version: v2.0

USER_NAME=$(whoami)
SERVICE_NAME=file_tracker@$USER_NAME.service
SCRIPT_DIR="/home/$USER_NAME/Local_Git"  # Modify to your script location
CLEAN_SCRIPT="$SCRIPT_DIR/clean_file_tracker.sh"
CONFIG_FILE="$SCRIPT_DIR/clean_config.env"
CONFIG_EXAMPLE="$SCRIPT_DIR/clean_config.env.example"
LOG_FILE="$SCRIPT_DIR/file_tracker.log"

echo "=========================================="
echo "File Tracker Installation Script"
echo "=========================================="

# Install watchdog
echo "[1/7] Installing watchdog..."
python3 -m pip install --user watchdog

# Create log file
echo "[2/7] Creating log file..."
touch "$LOG_FILE"
chmod 644 "$LOG_FILE"

# Setup cleanup script
echo "[3/7] Setting up cleanup script..."
chmod +x "$CLEAN_SCRIPT"

# Check if config file exists, if not copy from example
if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "$CONFIG_EXAMPLE" ]; then
        echo "[INFO] Creating config file from example..."
        cp "$CONFIG_EXAMPLE" "$CONFIG_FILE"
        echo "[WARN] Please edit $CONFIG_FILE and set WATCH_DIR and LOG_FILE"
    else
        echo "[WARN] Config file not found: $CONFIG_FILE"
        echo "       Please create it before running cleanup tasks"
    fi
fi

# Copy systemd service file
echo "[4/7] Installing systemd service..."
sudo cp "$SCRIPT_DIR/file_tracker@.service" /etc/systemd/system/

# Reload systemd
echo "[5/7] Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable and start service
echo "[6/7] Enabling and starting service..."
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo ""
echo "File tracker started successfully!"
echo "  Log file: $LOG_FILE"
echo "  Check status: sudo systemctl status $SERVICE_NAME"
echo ""

# Setup scheduled cleanup (every hour)
echo "[7/7] Setting up scheduled cleanup..."
CRON_ENTRY="0 * * * * source $CONFIG_FILE && $CLEAN_SCRIPT >> /var/log/file_tracker_cron.log 2>&1"

# Check if cron entry already exists
if crontab -l 2>/dev/null | grep -q "$CLEAN_SCRIPT"; then
    echo "[INFO] Cron job already exists, skipping..."
else
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
    echo "Scheduled cleanup configured: checks every hour if log/Git exceeds 50MB"
fi

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo ""
echo "Next steps:"
echo "  1. Edit config file: nano $CONFIG_FILE"
echo "  2. Set WATCH_DIR and LOG_FILE variables"
echo "  3. Test cleanup: source $CONFIG_FILE && $CLEAN_SCRIPT"
echo ""

