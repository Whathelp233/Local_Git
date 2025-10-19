#!/bin/bash
# 安装 file_tracker 服务并设置定时清理

USER_NAME=$(whoami)
SERVICE_NAME=file_tracker@$USER_NAME.service
SCRIPT_DIR="/home/$USER_NAME/file_track"
CLEAN_SCRIPT="$SCRIPT_DIR/clean_file_tracker.sh"
LOG_FILE="$SCRIPT_DIR/file_tracker.log"

# 安装 watchdog
python3 -m pip install --user watchdog

# 创建日志文件
touch $LOG_FILE
chmod 644 $LOG_FILE

# 拷贝 systemd 文件
sudo cp $SCRIPT_DIR/file_tracker@.service /etc/systemd/system/

# 重新加载 systemd
sudo systemctl daemon-reload

# 启动并设置开机自启
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo "File tracker 已启动，日志文件: $LOG_FILE"
echo "查看状态: sudo systemctl status $SERVICE_NAME"

# 设置定时清理，每小时执行一次
(crontab -l 2>/dev/null; echo "0 * * * * $CLEAN_SCRIPT") | crontab -
echo "定时清理已设置：每小时检查日志和 Git 历史是否超过50MB"

