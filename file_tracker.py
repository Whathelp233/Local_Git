#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# File Tracker - Automatic Git commit on file changes
# Author: WhatHelp233
# Version: v2.0
# Purpose: Monitor file changes in workspace and auto-commit to local Git repository

import os
import sys
import time
import pwd
import subprocess
from pathlib import Path

try:
    from watchdog.observers import Observer
    from watchdog.events import FileSystemEventHandler
except ImportError:
    print("Please install watchdog first: python3 -m pip install --user watchdog")
    sys.exit(1)

DELAY_SECONDS = 0  # 0 means immediate commit
LOG_FILE = os.path.expanduser("~/file_tracker.log")  # Log file in user home directory

class FileTrackerHandler(FileSystemEventHandler):
    def __init__(self, changed_files, watch_path):
        super().__init__()
        self.changed_files = changed_files
        self.watch_path = watch_path

    def is_ignored(self, path):
        try:
            rel = os.path.relpath(path, self.watch_path)
            return rel.startswith(".git")
        except Exception:
            return False

    def on_modified(self, event):
        if not event.is_directory and not self.is_ignored(event.src_path):
            self.changed_files.add(event.src_path)
            print(f"[DEBUG] Modified: {event.src_path}")

    def on_created(self, event):
        if not event.is_directory and not self.is_ignored(event.src_path):
            self.changed_files.add(event.src_path)
            print(f"[DEBUG] Created: {event.src_path}")

    def on_moved(self, event):
        if not event.is_directory and not self.is_ignored(event.dest_path):
            self.changed_files.add(event.dest_path)
            print(f"[DEBUG] Moved: {event.dest_path}")

    def on_deleted(self, event):
        if not event.is_directory and not self.is_ignored(event.src_path):
            self.changed_files.add(event.src_path)
            print(f"[DEBUG] Deleted: {event.src_path}")

def get_last_modifier(file_path):
    try:
        st = os.stat(file_path)
        return pwd.getpwuid(st.st_uid).pw_name
    except Exception:
        return "unknown"

def read_file_lines(file_path):
    try:
        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
            return f.readlines()
    except Exception:
        return []

def generate_diff(file_path, old_content, new_content):
    import difflib
    diff = difflib.unified_diff(old_content, new_content,
                                fromfile="old", tofile="new", lineterm="")
    return "\n".join(diff)

def log_commit(changed_files):
    timestamp = time.strftime("[%Y-%m-%d %H:%M:%S]")
    summary_lines = []
    for f in changed_files:
        modifier = get_last_modifier(f)
        summary_lines.append(f"{f} -> {modifier}")
    summary_text = "\n".join(summary_lines)
    log_text = f"{timestamp} commit: {len(changed_files)} file(s) changed\n{summary_text}\n"
    print(log_text)
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as log_f:
            log_f.write(log_text)
    except Exception as e:
        print(f"[WARN] 写日志失败: {e}")

def git_commit(commit_files, timestamp, watch_path):
    try:
        rel_paths = [os.path.relpath(f, watch_path) for f in commit_files if os.path.exists(f)]
        if not rel_paths:
            return
        print(f"[DEBUG] Git add: {rel_paths}")
        subprocess.run(["git", "add"] + rel_paths, cwd=watch_path, check=True)
        subprocess.run(["git", "commit", "-m", f"[file_tracker] {timestamp}"], cwd=watch_path, check=True)
        print("[DEBUG] Git commit succeeded")
    except subprocess.CalledProcessError as e:
        print(f"[DEBUG] Git commit failed: {e}")

def tracker_loop(watch_path):
    changed_files = set()
    event_handler = FileTrackerHandler(changed_files, watch_path)
    observer = Observer()
    observer.schedule(event_handler, watch_path, recursive=True)
    observer.start()

    file_snapshots = {}

    # 初始化 Git 仓库
    git_dir = Path(watch_path) / ".git"
    if not git_dir.exists():
        subprocess.run(["git", "init"], cwd=watch_path)
        subprocess.run(["git", "config", "user.name", "file_tracker"], cwd=watch_path)
        subprocess.run(["git", "config", "user.email", "file_tracker@example.com"], cwd=watch_path)
        subprocess.run(["git", "add", "."], cwd=watch_path)
        subprocess.run(["git", "commit", "-m", "[file_tracker] Initial commit"], cwd=watch_path)

    try:
        while True:
            time.sleep(max(1, DELAY_SECONDS))
            if changed_files:
                commit_files = set(changed_files)
                changed_files.clear()
                for f in commit_files:
                    old_content = file_snapshots.get(f, [])
                    new_content = read_file_lines(f)
                    diff_text = generate_diff(f, old_content, new_content)
                    if diff_text:
                        print(f"--- Diff for {f} ---\n{diff_text}\n")
                    file_snapshots[f] = new_content
                timestamp = time.strftime("[%Y-%m-%d %H:%M:%S]")
                log_commit(commit_files)
                git_commit(commit_files, timestamp, watch_path)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

def main():
    if len(sys.argv) != 3 or sys.argv[1] != "--watch":
        print(f"用法: {sys.argv[0]} --watch <目录>")
        sys.exit(1)
    watch_path = sys.argv[2]
    if not os.path.isdir(watch_path):
        print(f"目录不存在: {watch_path}")
        sys.exit(1)
    print(f"正在监控: {watch_path}")
    tracker_loop(watch_path)

if __name__ == "__main__":
    main()

