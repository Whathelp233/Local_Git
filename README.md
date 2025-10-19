

#  Local_Git

本项目用于**自动检测本地文件更改并执行 Git 提交操作**，适用于想在 **VSCode / CLion / PyCharm / 终端** 中实时追踪文件改动的开发者。  
该系统基于 Python `watchdog` 实现文件监听，并自动执行：

当前使用场景：
在ROS开发过程中记录机器人车上miniPC的工作目录的文件变化情况

Todolist：
可以实现直接在车上推送至仓库并不会出现本地的git记录
如果有什么需要可以在issue上提出


- 文件更改检测（增删改）
    
- 自动 `git add` 与 `git commit`
    
- 自动日志记录
    
- 可选的定时清理功能（防止日志/缓存膨胀）
    

---

##  功能概览

| 功能              | 描述                                   |
| --------------- | ------------------------------------ |
| 自动检测改动          | 自动检测文件修改、创建、删除事件                     |
| 自动执行 Git 提交     | 对检测到的文件自动执行 `git add` 与 `git commit` |
| 记录日志            | 将所有动作写入 `/var/log/file_tracker.log`  |
| 定时清理            | 可设置每天/每周自动清理日志与 `.git` 暂存文件          |
| VSCode/CLion 兼容 | 可直接在 IDE 中查看提交记录与版本历史                |
| 本地独立运行          | 支持后台守护进程或用户手动启动模式                    |

---

##  安装与配置

### 1. 克隆项目

```bash
git clone https://github.com/yourusername/file_tracker.git
cd file_tracker
```

### 2. 安装依赖（推荐使用虚拟环境）

```bash
python3 -m venv venv
source venv/bin/activate
pip install watchdog
```

### 3. 授权日志目录

```bash
sudo mkdir -p /var/log
sudo chmod 777 /var/log
```

### 4. 启动监控服务

```bash
python3 file_tracker.py --path /home/what/rm_description
```

你可以修改 `--path` 参数来指定你想监控的项目路径。

---

##  可选参数

|参数|默认值|说明|
|---|---|---|
|`--path`|当前目录|监控目标文件夹路径|
|`--interval`|30|检测频率（秒）|
|`--auto-clean`|False|是否启用自动清理日志|
|`--clean-interval`|7|清理周期（天）|
|`--max-log-size`|50MB|日志文件上限大小|

---

## 示例：启动自动清理模式

```bash
python3 file_tracker.py --path ~/rm_description --auto-clean True --clean-interval 3
```

表示：

- 每 3 天自动清理一次 `/var/log/file_tracker.log`
    
- 每次提交前自动检查 `.git/index.lock` 等锁文件
    
- 日志超过 50MB 时会自动归档并清空
    

---

## 文件结构

```
file_tracker/
├── file_tracker.py       # 主程序（监控与提交逻辑）
├── utils.py              # 日志、清理等辅助模块
├── README.md             # 使用说明文档
└── requirements.txt      # 依赖列表
```

---

## 运行机制说明

1. **文件监控：**  
    使用 `watchdog.observers.Observer` 持续监听指定目录。
    
2. **事件处理：**  
    每当文件被修改、创建、删除时，触发 `on_modified/on_created/on_deleted`。
    
3. **Git 自动提交：**
    
    - 检查 `.git/index.lock`，若存在则等待；
        
    - 自动执行：
        
        ```bash
        git add -A
        git commit -m "Auto commit: [timestamp]"
        ```
        
4. **日志记录：**  
    所有操作写入 `/var/log/file_tracker.log`。
    

---

## 自动清理机制

- 每次启动时检查日志大小；
    
- 当日志文件超过 `max-log-size` 或达到清理周期时：
    
    - 归档旧日志为 `/var/log/file_tracker_<date>.bak`
        
    - 重新创建新的日志文件；
        
- 清理 `.git` 内部临时锁文件（防止冲突）。
    

---

## 调试与维护

### 查看运行日志：

```bash
tail -f /var/log/file_tracker.log
```

### 查看 Git 日志：

```bash
git log --oneline --graph --decorate
```

### 手动测试自动提交：

```bash
touch test.txt
# 稍等几秒，系统应自动提交
git log -1
```

---

## 注意事项

- 若使用 **root 用户 / Docker 环境**，需确保 `.git` 目录权限正常；
    
- 若在 **VSCode/CLion** 中运行，请确保 IDE 使用的解释器已安装 `watchdog`；
    
- 若出现 “Permission denied” 日志，请确认 `/var/log/file_tracker.log` 的写权限。
    

---

##  卸载与清理

```bash
deactivate
rm -rf venv
sudo rm /var/log/file_tracker.log
```

---

## 作者

- **Project:** Local_Git
    
- **Author:** WhatHelp233
    
- **Version:** v 0.1.0
    

    
