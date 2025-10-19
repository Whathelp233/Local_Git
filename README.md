# Local Git File Tracker

Automatic file change detection and Git commit system for local development environments.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)

## Overview

This project provides **automatic file change detection and Git commit operations** for developers working in VSCode, CLion, PyCharm, or Terminal environments. It enables real-time tracking of file modifications without manual Git operations.

**Current Use Case:** Tracking file changes in miniPC workspace on robot vehicles during ROS development.

## Key Features

- Automatic file change detection (create, modify, delete)
- Auto Git commit with timestamps
- Safe cleanup script with backups
- Scheduled maintenance via cron
- Systemd service integration
- IDE compatible

## Quick Start

See [QUICKSTART.md](QUICKSTART.md) for 5-minute installation guide.

### Basic Installation

```bash
# 1. Clone repository
git clone https://github.com/Whathelp233/Local_Git.git
cd Local_Git

# 2. Install dependencies
pip install watchdog

# 3. Run installer
./install_tracker.sh

# 4. Configure
cp clean_config.env.example clean_config.env
nano clean_config.env  # Set WATCH_DIR and LOG_FILE

# 5. Start service
sudo systemctl start file_tracker@$(whoami).service
```

## Configuration

### Required Settings

Edit `clean_config.env`:

```bash
export WATCH_DIR="/path/to/your/workspace"
export LOG_FILE="/path/to/file_tracker.log"
```

### Optional Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `MAX_SIZE` | 50MB | Cleanup trigger threshold |
| `BACKUP_DIR` | /tmp/file_tracker_backups | Backup location |
| `LOG_KEEP_LINES` | 1000 | Lines to keep after truncation |
| `BACKUP_RETENTION_DAYS` | 7 | Backup retention period |

### Configuration Examples

**ROS Workspace:**
```bash
export WATCH_DIR="/home/$(whoami)/ros_ws/src"
export LOG_FILE="/home/$(whoami)/.ros/file_tracker.log"
```

**General Project:**
```bash
export WATCH_DIR="/home/$(whoami)/projects/my_project"
export LOG_FILE="/var/log/file_tracker.log"
```

## Usage

### Service Management

```bash
# Start service
sudo systemctl start file_tracker@$(whoami).service

# Stop service
sudo systemctl stop file_tracker@$(whoami).service

# Check status
sudo systemctl status file_tracker@$(whoami).service
```

### Manual Mode

```bash
python3 file_tracker.py --watch /your/workspace
```

### View Logs

```bash
# Monitor file changes
tail -f ~/file_tracker.log

# Monitor cleanup operations
tail -f /var/log/file_tracker_clean.log
```

### Manual Cleanup

```bash
source clean_config.env
./clean_file_tracker.sh
```

## How It Works

1. **File Monitoring:** Uses Python `watchdog` to detect file changes
2. **Auto Commit:** Automatically runs `git add` and `git commit` on changes
3. **Logging:** Records all operations to log file
4. **Cleanup:** Scheduled script maintains log size and Git repository
5. **Backup:** Creates backups before cleanup operations

### Safety Features

- Pre-cleanup backups (log files and Git repository)
- Lock mechanism prevents concurrent operations
- Checks for uncommitted changes before cleanup
- Automatic backup rotation (7-day retention)
- Comprehensive error handling

## File Structure

```
Local_Git/
├── file_tracker.py              # Main monitoring script
├── clean_file_tracker.sh        # Safe cleanup script
├── clean_config.env.example     # Configuration template
├── install_tracker.sh           # Installation script
├── file_tracker@.service        # Systemd service
├── README.md                    # This file
├── QUICKSTART.md                # Quick start guide
├── CHANGELOG.md                 # Version history
├── LICENSE                      # MIT License
└── .gitignore                   # Git ignore patterns
```

## Troubleshooting

### Common Issues

**"WATCH_DIR is not set"**
```bash
source clean_config.env
```

**Service won't start**
```bash
# Check logs
sudo journalctl -u file_tracker@$(whoami).service -n 50

# Common fixes:
pip install watchdog
```

**Cleanup task stuck**
```bash
# Check if running
ps aux | grep clean_file_tracker

# Remove stale lock if needed
rm -f /tmp/file_tracker_clean.lock
```

For more troubleshooting, see [QUICKSTART.md](QUICKSTART.md).

## Advanced Usage

### Custom Cleanup Schedule

```bash
crontab -e

# Every 30 minutes
*/30 * * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh
```

### Deep Git Cleanup

```bash
# Shallow clone (last 100 commits only)
git clone --depth 100 file://$WATCH_DIR /tmp/shallow_repo
rm -rf $WATCH_DIR/.git
mv /tmp/shallow_repo/.git $WATCH_DIR/
```

## Best Practices

1. Use persistent backup location (not `/tmp`)
2. Monitor disk usage regularly
3. Adjust cleanup frequency based on project size
4. Review logs periodically
5. Test configuration before deploying

## Version History

- **v2.0** (2025-10-19) - Complete rewrite with safety features
- **v1.0** - Initial release

See [CHANGELOG.md](CHANGELOG.md) for detailed changes.

## Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) file.

## Author

- **Author:** WhatHelp233
- **Version:** v2.0
- **Repository:** [github.com/Whathelp233/Local_Git](https://github.com/Whathelp233/Local_Git)

## Support

- Issues: [GitHub Issues](https://github.com/Whathelp233/Local_Git/issues)
- Documentation: [QUICKSTART.md](QUICKSTART.md) | [CHANGELOG.md](CHANGELOG.md)

---

**Star this repository if you find it helpful!**
