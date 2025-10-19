#!/bin/bash
# 自动清理 file_tracker 日志和 Git 历史
WATCH_DIR="Enter you work_space"
LOG_FILE="Enther you log_space"
MAX_SIZE=$((50*1024*1024))  # 50MB

# 清理日志
if [ -f "$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_FILE")
    if [ "$LOG_SIZE" -gt "$MAX_SIZE" ]; then
        echo "[`date`] 日志过大，截取最近1000行" >> "$LOG_FILE"
        tail -n 1000 "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
fi

# 清理 Git 历史
if [ -d "$WATCH_DIR/.git" ]; then
    GIT_SIZE=$(du -sb "$WATCH_DIR/.git" | cut -f1)
    if [ "$GIT_SIZE" -gt "$MAX_SIZE" ]; then
        echo "[`date`] Git仓库过大，裁剪历史并回收" >> "$LOG_FILE"
        cd "$WATCH_DIR"
        git checkout master
        git branch temp_clean
        git reset --soft $(git rev-list --max-count=50 HEAD)
        git commit -m "[file_tracker] history trim"
        git reflog expire --expire=now --all
        git gc --prune=now --aggressive
    fi
fi

