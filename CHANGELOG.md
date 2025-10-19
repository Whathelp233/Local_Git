# Changelog

All notable changes to Local Git File Tracker project.

## [v2.0] - 2025-10-19

### Major Changes
- **BREAKING**: Completely rewrote `clean_file_tracker.sh` for safety and reliability
- **BREAKING**: Removed all emoji symbols from codebase
- **BREAKING**: Converted all comments to English

### Added
- Comprehensive error handling with strict mode (`set -euo pipefail`)
- Preflight checks for all requirements
- Lock mechanism to prevent concurrent cleanup tasks
- Automatic backup before cleanup operations
- Backup rotation system (default: 7 days retention)
- Stale lock detection and cleanup
- Colorized log output for better readability
- Human-readable size formatting
- Configuration file (`clean_config.env`)
- Quick start guide (`QUICKSTART.md`)
- Detailed English documentation

### Fixed
- **CRITICAL**: Fixed dangerous Git reset operation that would destroy history
- **CRITICAL**: Fixed undefined variable issue (WATCH_DIR, LOG_FILE)
- **CRITICAL**: Fixed log truncation that could cause data loss
- Missing error checks for directory existence
- Missing error checks for Git repository state
- Missing error checks for uncommitted changes
- Missing branch name validation (master vs main)
- Cron job missing config file sourcing
- String concatenation issues in install script

### Improved
- Safer Git cleanup using only `git gc` (no destructive operations)
- Better log rotation with backup
- Improved cron job with config file sourcing
- Enhanced install script with progress indicators
- Better error messages with actionable solutions
- Added verification steps to installation

### Removed
- Dangerous `git reset --soft` operation
- Unused `temp_clean` branch creation
- Emoji symbols from all files
- Chinese comments (replaced with English)

### Security
- Added input validation for all variables
- Added safety checks before destructive operations
- Implemented backup-before-modify pattern
- Added process lock to prevent race conditions

## [v1.0] - Initial Release

### Added
- Basic file monitoring with watchdog
- Automatic Git commit on file changes
- Simple log file cleanup
- Basic Git history cleanup
- Systemd service integration
- Cron-based scheduled cleanup

### Known Issues (Fixed in v2.0)
- Unsafe Git operations could destroy history
- No error handling or recovery
- No backup mechanism
- Variables not properly initialized
- Missing safety checks

---

## Upgrade Guide from v1.0 to v2.0

### Step 1: Backup Your Data
```bash
# Backup log file
cp ~/file_tracker.log ~/file_tracker.log.backup

# Backup Git repository
cd $YOUR_WORKSPACE
tar -czf /tmp/git_backup_$(date +%Y%m%d).tar.gz .git
```

### Step 2: Stop Old Service
```bash
sudo systemctl stop file_tracker@$(whoami).service
crontab -e  # Remove old cleanup cron job
```

### Step 3: Update Files
```bash
cd /home/what/Local_Git
git pull  # Or re-download the project
```

### Step 4: Configure
```bash
nano clean_config.env
# Set WATCH_DIR and LOG_FILE
```

### Step 5: Reinstall
```bash
./install_tracker.sh
```

### Step 6: Verify
```bash
sudo systemctl status file_tracker@$(whoami).service
source clean_config.env && ./clean_file_tracker.sh
```

---

## Migration Notes

### Configuration Changes
- Old: Variables hardcoded in script
- New: Variables in `clean_config.env`

### Cleanup Behavior Changes
- Old: Destructive Git reset operation
- New: Safe Git gc operation only

### Cron Job Changes
- Old: `0 * * * * /path/to/clean_file_tracker.sh`
- New: `0 * * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh`

### Backup Changes
- Old: No backups
- New: Automatic backups before cleanup

---

## Compatibility

### Tested On
- Ubuntu 20.04 LTS
- Ubuntu 22.04 LTS
- Debian 11
- Python 3.8+
- Git 2.25+

### Requirements
- Python 3.6 or higher
- Git 2.0 or higher
- Bash 4.0 or higher
- watchdog Python package
- systemd (for service mode)

---

## Future Plans (v2.1)

- [ ] Remote repository push support
- [ ] Multi-workspace monitoring
- [ ] Web dashboard for log viewing
- [ ] Email notifications on cleanup
- [ ] Configurable commit message templates
- [ ] Git LFS integration
- [ ] Docker container support
- [ ] Real-time statistics

---

## Contributing

See [README.md](README.md) for contribution guidelines.

## License

MIT License - See LICENSE file for details
