# Local Git File Tracker# Local Git File Tracker



Automatic file change detection and Git commit system for local development environments.



[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)Automatic file change detection and Git commit system for local development environments.#  Local_Git

[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)



## Overview

## Overview本项目用于**自动检测本地文件更改并执行 Git 提交操作**，适用于想在 **VSCode / CLion / PyCharm / 终端** 中实时追踪文件改动的开发者。  

This project provides **automatic file change detection and Git commit operations** for developers working in **VSCode / CLion / PyCharm / Terminal** environments. It enables real-time tracking of file modifications without manual Git operations.

该系统基于 Python `watchdog` 实现文件监听，并自动执行：

**Current Use Case:**  

Tracking file changes in the miniPC workspace on robot vehicles during ROS development.This project provides **automatic file change detection and Git commit operations** for developers working in **VSCode / CLion / PyCharm / Terminal** environments. It enables real-time tracking of file modifications without manual Git operations.



## Features当前使用场景：



| Feature | Description |**Current Use Case:**  在ROS开发过程中记录机器人车上miniPC的工作目录的文件变化情况

|---------|-------------|

| Automatic Change Detection | Detects file modifications, creations, deletions |Tracking file changes in the miniPC workspace on robot vehicles during ROS development.

| Auto Git Commit | Executes `git add` and `git commit` automatically |

| Logging | Records all operations to log file |Todolist：

| Scheduled Cleanup | Prevents log/cache bloat with automatic cleanup |

| IDE Compatible | Works with VSCode/CLion and other IDEs |## Features可以实现直接在车上推送至仓库并不会出现本地的git记录

| Local Standalone | Runs as background daemon or manual process |

如果有什么需要可以在issue上提出

## Installation

| Feature | Description |

### 1. Clone Repository

|---------|-------------|

```bash

git clone https://github.com/yourusername/Local_Git.git| Automatic Change Detection | Detects file modifications, creations, deletions |- 文件更改检测（增删改）

cd Local_Git

```| Auto Git Commit | Executes `git add` and `git commit` automatically |    



### 2. Install Dependencies| Logging | Records all operations to log file |- 自动 `git add` 与 `git commit`



```bash| Scheduled Cleanup | Prevents log/cache bloat with automatic cleanup |    

# Option 1: Install globally

pip install watchdog| IDE Compatible | Works with VSCode/CLion and other IDEs |- 自动日志记录



# Option 2: Install for current user| Local Standalone | Runs as background daemon or manual process |    

python3 -m pip install --user watchdog

```- 可选的定时清理功能（防止日志/缓存膨胀）



### 3. Run Installation Script## Installation    



```bash

chmod +x install_tracker.sh

./install_tracker.sh### 1. Clone Repository---

```



This will:

- Install watchdog Python package```bash##  功能概览

- Create log file

- Setup systemd servicegit clone https://github.com/yourusername/Local_Git.git

- Configure scheduled cleanup (hourly)

- Copy example config filecd Local_Git| 功能              | 描述                                   |



### 4. Configure Watch Directory```| --------------- | ------------------------------------ |



```bash| 自动检测改动          | 自动检测文件修改、创建、删除事件                     |

# Copy example config if not already done

cp clean_config.env.example clean_config.env### 2. Install Dependencies| 自动执行 Git 提交     | 对检测到的文件自动执行 `git add` 与 `git commit` |



# Edit configuration| 记录日志            | 将所有动作写入 `/var/log/file_tracker.log`  |

nano clean_config.env

``````bash| 定时清理            | 可设置每天/每周自动清理日志与 `.git` 暂存文件          |



Set your workspace path:# Option 1: Install globally| VSCode/CLion 兼容 | 可直接在 IDE 中查看提交记录与版本历史                |



```bashpip install watchdog| 本地独立运行          | 支持后台守护进程或用户手动启动模式                    |

export WATCH_DIR="/home/your_user/your_workspace"

export LOG_FILE="/home/your_user/file_tracker.log"

```

# Option 2: Install for current user---

### 5. Start Monitoring

python3 -m pip install --user watchdog

```bash

# Manual start```##  安装与配置

python3 file_tracker.py --watch /path/to/your/workspace



# Or use systemd service (recommended)

sudo systemctl start file_tracker@$(whoami).service### 3. Run Installation Script### 1. 克隆项目

```



## Configuration

```bash```bash

### Environment Variables

chmod +x install_tracker.shgit clone https://github.com/yourusername/Local_Git.git

Edit `clean_config.env`:

./install_tracker.shcd Local_Git

| Variable | Default | Description |

|----------|---------|-------------|``````

| `WATCH_DIR` | (required) | Directory to monitor |

| `LOG_FILE` | (required) | Log file path |

| `MAX_SIZE` | 50MB | Threshold for cleanup trigger |

| `BACKUP_DIR` | /tmp/file_tracker_backups | Backup storage location |This will:### 2. 安装依赖（推荐使用虚拟环境）

| `LOG_KEEP_LINES` | 1000 | Lines to keep after log truncation |

| `BACKUP_RETENTION_DAYS` | 7 | Days to keep backup files |- Install watchdog Python package



### Example Configurations- Create log file```bash



#### ROS Workspace- Setup systemd servicepython3 -m venv venv

```bash

export WATCH_DIR="/home/$(whoami)/ros_ws/src"- Configure scheduled cleanup (hourly)source venv/bin/activate

export LOG_FILE="/home/$(whoami)/.ros/file_tracker.log"

```pip install watchdog



#### Sentry Robot Development### 4. Configure Watch Directory```

```bash

export WATCH_DIR="/home/$(whoami)/sentry2/src"

export LOG_FILE="/home/$(whoami)/sentry2/file_tracker.log"

```Edit the configuration file:### 3. 授权日志目录



#### General Development Project

```bash

export WATCH_DIR="/home/$(whoami)/projects/my_project"```bash```bash

export LOG_FILE="/var/log/file_tracker_my_project.log"

```nano clean_config.envsudo mkdir -p /var/log



## Usage```sudo chmod 777 /var/log



### Manual Monitoring```



```bashSet your workspace path:

python3 file_tracker.py --watch /your/workspace

```### 4. 启动监控服务



### Check Service Status```bash



```bashexport WATCH_DIR="/home/your_user/your_workspace"```bash

sudo systemctl status file_tracker@$(whoami).service

```export LOG_FILE="/home/your_user/file_tracker.log"python3 file_tracker.py --path /Your_workspace



### View Logs``````



```bash

# Monitor log

tail -f ~/file_tracker.log### 5. Start Monitoring你可以修改 `--path` 参数来指定你想监控的项目路径。



# View cleanup log

tail -f /var/log/file_tracker_clean.log

``````bash---



### Manual Cleanup# Manual start



```bashpython3 file_tracker.py --watch /path/to/your/workspace##  可选参数

source clean_config.env

./clean_file_tracker.sh

```

# Or use systemd service (recommended)|参数|默认值|说明|

## How It Works

sudo systemctl start file_tracker@$(whoami).service|---|---|---|

### 1. File Monitoring

Uses `watchdog.observers.Observer` to continuously monitor the specified directory.```|`--path`|当前目录|监控目标文件夹路径|



### 2. Event Handling|`--interval`|30|检测频率（秒）|

Triggers on file modifications, creations, deletions through event handlers:

- `on_modified`## Configuration|`--auto-clean`|False|是否启用自动清理日志|

- `on_created`

- `on_deleted`|`--clean-interval`|7|清理周期（天）|

- `on_moved`

### Environment Variables|`--max-log-size`|50MB|日志文件上限大小|

### 3. Automatic Git Commit

- Checks for `.git/index.lock` (waits if locked)

- Executes:

  ```bashEdit `clean_config.env`:---

  git add -A

  git commit -m "Auto commit: [timestamp]"

  ```

| Variable | Default | Description |## 示例：启动自动清理模式

### 4. Logging

All operations are written to the specified log file.|----------|---------|-------------|



### 5. Cleanup Mechanism| `WATCH_DIR` | (required) | Directory to monitor |```bash



The cleanup script runs periodically (default: hourly) and:| `LOG_FILE` | (required) | Log file path |python3 file_tracker.py --path ~/you_workspace --auto-clean True --clean-interval 3

- Checks log file size

- Backs up before truncation| `MAX_SIZE` | 50MB | Threshold for cleanup trigger |```

- Truncates to last N lines if oversized

- Runs Git garbage collection| `BACKUP_DIR` | /tmp/file_tracker_backups | Backup storage location |

- Removes old backups

| `LOG_KEEP_LINES` | 1000 | Lines to keep after log truncation |表示：

**Safety Features:**

- Pre-cleanup backups| `BACKUP_RETENTION_DAYS` | 7 | Days to keep backup files |

- Lock mechanism prevents concurrent execution

- Checks for uncommitted changes- 每 3 天自动清理一次 `/var/log/file_tracker.log`

- Verifies Git repository state

### Example Configurations    

## File Structure

- 每次提交前自动检查 `.git/index.lock` 等锁文件

```

Local_Git/#### ROS Workspace    

├── file_tracker.py              # Main monitoring program

├── clean_file_tracker.sh        # Cleanup script (safe version)```bash- 日志超过 50MB 时会自动归档并清空

├── clean_config.env.example     # Configuration template

├── install_tracker.sh           # Installation scriptexport WATCH_DIR="/home/$(whoami)/ros_ws/src"    

├── file_tracker@.service        # Systemd service template

├── README.md                    # Documentationexport LOG_FILE="/home/$(whoami)/.ros/file_tracker.log"

├── QUICKSTART.md                # Quick start guide

├── CHANGELOG.md                 # Version history```---

├── LICENSE                      # MIT License

└── .gitignore                   # Git ignore patterns

```

#### Sentry Robot Development## 文件结构

## Cleanup Script Details

```bash

### What Gets Cleaned

export WATCH_DIR="/home/$(whoami)/sentry2/src"```

1. **Log Files**

   - Truncated to last 1000 lines (configurable)export LOG_FILE="/home/$(whoami)/sentry2/file_tracker.log"Local_git/

   - Original backed up before truncation

```├── file_tracker.py       # 主程序（监控与提交逻辑）

2. **Git Repository**

   - Reflog expiration├── utils.py              # 日志、清理等辅助模块

   - Garbage collection (`git gc --aggressive`)

   - Prunes unreachable objects#### General Development Project├── README.md             # 使用说明文档



3. **Old Backups**```bash└── requirements.txt      # 依赖列表

   - Files older than retention period deleted

   - Default: 7 daysexport WATCH_DIR="/home/$(whoami)/projects/my_project"```



### Safety Featuresexport LOG_FILE="/var/log/file_tracker_my_project.log"



- **Pre-cleanup backup**: All data backed up before modification```---

- **Lock mechanism**: Prevents concurrent cleanup tasks

- **Error handling**: Rolls back on failure

- **Uncommitted change check**: Aborts if uncommitted changes exist

- **Stale lock detection**: Removes abandoned locks## Usage## 运行机制说明



### Backup Locations



```### Manual Monitoring1. **文件监控：**  

/tmp/file_tracker_backups/

├── file_tracker_20251019_103045.log.bak    使用 `watchdog.observers.Observer` 持续监听指定目录。

├── git_backup_20251019_103050.tar.gz

└── ...```bash    

```

python3 file_tracker.py --watch /your/workspace2. **事件处理：**  

## Troubleshooting

```    每当文件被修改、创建、删除时，触发 `on_modified/on_created/on_deleted`。

### Issue: "WATCH_DIR is not set"

    

**Solution:**

```bash### Check Service Status3. **Git 自动提交：**

export WATCH_DIR="/your/workspace/path"

# Or    

source clean_config.env

``````bash    - 检查 `.git/index.lock`，若存在则等待；



### Issue: "Not a Git repository"sudo systemctl status file_tracker@$(whoami).service        



This is a warning, not an error. The script will skip Git cleanup and only clean logs.```    - 自动执行：



### Issue: "Uncommitted changes detected"        



**Solution:**### View Logs        ```bash

```bash

cd $WATCH_DIR        git add -A

git status

git add -A```bash        git commit -m "Auto commit: [timestamp]"

git commit -m "Save work in progress"

# Then rerun cleanup# Monitor log        ```

```

tail -f ~/file_tracker.log        

### Issue: "Cleanup task is already running"

4. **日志记录：**  

Check if actually running:

```bash# View cleanup log    所有操作写入 `/var/log/file_tracker.log`。

ps aux | grep clean_file_tracker

tail -f /var/log/file_tracker_clean.log    

# If not running, remove stale lock

rm -f /tmp/file_tracker_clean.lock```

```

---

### Issue: Service won't start

### Manual Cleanup

**Check logs:**

```bash## 自动清理机制

sudo journalctl -u file_tracker@$(whoami).service -n 50

``````bash



**Common causes:**source clean_config.env- 每次启动时检查日志大小；

- Python not in PATH

- Watchdog not installed./clean_file_tracker.sh    

- Invalid workspace path

```- 当日志文件超过 `max-log-size` 或达到清理周期时：

## Advanced Usage

    

### Custom Cleanup Frequency

## How It Works    - 归档旧日志为 `/var/log/file_tracker_<date>.bak`

Edit crontab:

```bash        

crontab -e

### 1. File Monitoring    - 重新创建新的日志文件；

# Examples:

# Every 30 minutesUses `watchdog.observers.Observer` to continuously monitor the specified directory.        

*/30 * * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh

- 清理 `.git` 内部临时锁文件（防止冲突）。

# Daily at 2 AM

0 2 * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh### 2. Event Handling    

```

Triggers on file modifications, creations, deletions through event handlers:

### Deep Git Cleanup (Manual)

- `on_modified`---

If repository is still too large after automatic cleanup:

- `on_created`

```bash

# Method 1: Shallow clone (keeps last 100 commits)- `on_deleted`## 调试与维护

git clone --depth 100 file://$WATCH_DIR /tmp/shallow_repo

rm -rf $WATCH_DIR/.git- `on_moved`

mv /tmp/shallow_repo/.git $WATCH_DIR/

### 查看运行日志：

# Method 2: Filter history

pip install git-filter-repo### 3. Automatic Git Commit

git filter-repo --refs HEAD~100..HEAD

```- Checks for `.git/index.lock` (waits if locked)```bash



### Monitor Cleanup Execution- Executes:tail -f /var/log/file_tracker.log



```bash  ```bash```

# Real-time monitoring

tail -f /var/log/file_tracker_clean.log  git add -A



# Check cron execution  git commit -m "Auto commit: [timestamp]"### 查看 Git 日志：

tail -f /var/log/file_tracker_cron.log

```  ```



## Uninstallation```bash



```bash### 4. Logginggit log --oneline --graph --decorate

# Stop service

sudo systemctl stop file_tracker@$(whoami).serviceAll operations are written to the specified log file.```

sudo systemctl disable file_tracker@$(whoami).service



# Remove service file

sudo rm /etc/systemd/system/file_tracker@.service### 5. Cleanup Mechanism### 手动测试自动提交：

sudo systemctl daemon-reload



# Remove cron job

crontab -eThe cleanup script runs periodically (default: hourly) and:```bash

# Delete line containing clean_file_tracker.sh

- Checks log file sizetouch test.txt

# Remove files

rm -rf ~/Local_Git- Backs up before truncation# 稍等几秒，系统应自动提交

rm -f ~/file_tracker.log

rm -rf /tmp/file_tracker_backups- Truncates to last N lines if oversizedgit log -1

```

- Runs Git garbage collection```

## Best Practices

- Removes old backups

1. **Regular Backup Monitoring**

   ```bash---

   ls -lh /tmp/file_tracker_backups/

   ```**Safety Features:**



2. **Rotate Old Backups**- Pre-cleanup backups## 注意事项

   ```bash

   # Delete backups older than 7 days (automatic)- Lock mechanism prevents concurrent execution

   # Or manually:

   find /tmp/file_tracker_backups/ -mtime +7 -delete- Checks for uncommitted changes- 若使用 **root 用户 / Docker 环境**，需确保 `.git` 目录权限正常；

   ```

- Verifies Git repository state    

3. **Monitor Disk Usage**

   ```bash- 若在 **VSCode/CLion** 中运行，请确保 IDE 使用的解释器已安装 `watchdog`；

   du -sh $WATCH_DIR/.git

   du -sh /tmp/file_tracker_backups## File Structure    

   ```

- 若出现 “Permission denied” 日志，请确认 `/var/log/file_tracker.log` 的写权限。

4. **Adjust Cleanup Frequency**

   - Small projects: daily```    

   - Large projects: hourly

   - High-frequency writes: every 30 minutesLocal_Git/



5. **Use Persistent Backup Location**├── file_tracker.py              # Main monitoring program---

   ```bash

   # Don't use /tmp (cleared on reboot)├── clean_file_tracker.sh        # Cleanup script (safe version)

   export BACKUP_DIR="/home/$(whoami)/file_tracker_backups"

   ```├── clean_config.env             # Configuration file##  卸载与清理



## Security Considerations├── install_tracker.sh           # Installation script



- Script runs with user permissions├── file_tracker@.service        # Systemd service template```bash

- Backups contain full Git history (store securely)

- Log files may contain file paths (consider permissions)├── README.md                    # Documentationdeactivate

- Cleanup script uses strict error handling

├── MIGRATION_GUIDE.md          # Migration and troubleshooting guiderm -rf venv

## Contributing

└── SCRIPT_ISSUES_ANALYSIS.md   # Technical analysis of fixessudo rm /var/log/file_tracker.log

Contributions are welcome! Please:

1. Fork the repository``````

2. Create a feature branch

3. Make your changes

4. Submit a pull request

## Cleanup Script Details---

For major changes, please open an issue first to discuss what you would like to change.



## License

### What Gets Cleaned## 作者

MIT License - See [LICENSE](LICENSE) file for details.



## Author

1. **Log Files**- **Project:** Local_Git

- **Project:** Local_Git File Tracker

- **Author:** WhatHelp233   - Truncated to last 1000 lines (configurable)    

- **Version:** v2.0

- **Last Updated:** 2025-10-19   - Original backed up before truncation- **Author:** WhatHelp233



## Changelog    



See [CHANGELOG.md](CHANGELOG.md) for detailed version history.2. **Git Repository**- **Version:** v 0.1.0



## TODO   - Reflog expiration    



- [ ] Remote repository push support (avoid local Git record conflicts)   - Garbage collection (`git gc --aggressive`)

- [ ] Multi-workspace monitoring

- [ ] Web interface for log viewing   - Prunes unreachable objects    

- [ ] Real-time notification system

- [ ] Git LFS integration for large files

- [ ] Configuration validation tool3. **Old Backups**

- [ ] Performance metrics dashboard   - Files older than retention period deleted

   - Default: 7 days

## Support

### Safety Features

For issues and feature requests:

- Open an issue on GitHub- **Pre-cleanup backup**: All data backed up before modification

- Check [QUICKSTART.md](QUICKSTART.md) for quick solutions- **Lock mechanism**: Prevents concurrent cleanup tasks

- Review [CHANGELOG.md](CHANGELOG.md) for version-specific information- **Error handling**: Rolls back on failure

- **Uncommitted change check**: Aborts if uncommitted changes exist

---- **Stale lock detection**: Removes abandoned locks



**Star this repository if you find it helpful!**### Backup Locations


```
/tmp/file_tracker_backups/
├── file_tracker_20251019_103045.log.bak
├── git_backup_20251019_103050.tar.gz
└── ...
```

## Troubleshooting

### Issue: "WATCH_DIR is not set"

**Solution:**
```bash
export WATCH_DIR="/your/workspace/path"
# Or
source clean_config.env
```

### Issue: "Not a Git repository"

This is a warning, not an error. The script will skip Git cleanup and only clean logs.

### Issue: "Uncommitted changes detected"

**Solution:**
```bash
cd $WATCH_DIR
git status
git add -A
git commit -m "Save work in progress"
# Then rerun cleanup
```

### Issue: "Cleanup task is already running"

Check if actually running:
```bash
ps aux | grep clean_file_tracker

# If not running, remove stale lock
rm -f /tmp/file_tracker_clean.lock
```

### Issue: Service won't start

**Check logs:**
```bash
sudo journalctl -u file_tracker@$(whoami).service -n 50
```

**Common causes:**
- Python not in PATH
- Watchdog not installed
- Invalid workspace path

## Advanced Usage

### Custom Cleanup Frequency

Edit crontab:
```bash
crontab -e

# Examples:
# Every 30 minutes
*/30 * * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh

# Daily at 2 AM
0 2 * * * source /path/to/clean_config.env && /path/to/clean_file_tracker.sh
```

### Deep Git Cleanup (Manual)

If repository is still too large after automatic cleanup:

```bash
# Method 1: Shallow clone (keeps last 100 commits)
git clone --depth 100 file://$WATCH_DIR /tmp/shallow_repo
rm -rf $WATCH_DIR/.git
mv /tmp/shallow_repo/.git $WATCH_DIR/

# Method 2: Filter history
pip install git-filter-repo
git filter-repo --refs HEAD~100..HEAD
```

### Monitor Cleanup Execution

```bash
# Real-time monitoring
tail -f /var/log/file_tracker_clean.log

# Check cron execution
tail -f /var/log/file_tracker_cron.log
```

## Uninstallation

```bash
# Stop service
sudo systemctl stop file_tracker@$(whoami).service
sudo systemctl disable file_tracker@$(whoami).service

# Remove service file
sudo rm /etc/systemd/system/file_tracker@.service
sudo systemctl daemon-reload

# Remove cron job
crontab -e
# Delete line containing clean_file_tracker.sh

# Remove files
rm -rf ~/Local_Git
rm -f ~/file_tracker.log
rm -rf /tmp/file_tracker_backups
```

## Best Practices

1. **Regular Backup Monitoring**
   ```bash
   ls -lh /tmp/file_tracker_backups/
   ```

2. **Rotate Old Backups**
   ```bash
   # Delete backups older than 7 days (automatic)
   # Or manually:
   find /tmp/file_tracker_backups/ -mtime +7 -delete
   ```

3. **Monitor Disk Usage**
   ```bash
   du -sh $WATCH_DIR/.git
   du -sh /tmp/file_tracker_backups
   ```

4. **Adjust Cleanup Frequency**
   - Small projects: daily
   - Large projects: hourly
   - High-frequency writes: every 30 minutes

5. **Use Persistent Backup Location**
   ```bash
   # Don't use /tmp (cleared on reboot)
   export BACKUP_DIR="/home/$(whoami)/file_tracker_backups"
   ```

## Security Considerations

- Script runs with user permissions
- Backups contain full Git history (store securely)
- Log files may contain file paths (consider permissions)
- Cleanup script uses strict error handling

## Version History

- **v2.0** (2025-10-19)
  - Completely rewritten cleanup script
  - Added safety features and backups
  - Improved error handling
  - Added backup rotation
  - English comments and documentation

- **v1.0** (Initial release)
  - Basic file monitoring
  - Automatic Git commits
  - Simple cleanup

## Contributing

Contributions are welcome! Please open an issue or pull request on GitHub.

## License

MIT License

## Author

- **Project:** Local_Git
- **Author:** WhatHelp233
- **Version:** v2.0
- **Last Updated:** 2025-10-19

## TODO

- [ ] Remote repository push support (avoid local Git record conflicts)
- [ ] Multi-workspace monitoring
- [ ] Web interface for log viewing
- [ ] Real-time notification system
- [ ] Git LFS integration for large files

For issues and feature requests, please visit the GitHub Issues page.
