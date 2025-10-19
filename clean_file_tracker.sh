#!/bin/bash#!/bin/bash#!/bin/bash

# File Tracker Cleanup Script (Hardened Version)

# Purpose: Safely clean file_tracker logs and Git history to prevent disk space issues# File Tracker Cleanup Script (Hardened Version)# 自动清理 file_tracker 日志和 Git 历史

# Author: WhatHelp233

# Version: v2.0# Purpose: Safely clean file_tracker logs and Git history to prevent disk space issuesWATCH_DIR="Enter you work_space"

# Last Modified: 2025-10-19

# Author: WhatHelp233LOG_FILE="Enther you log_space/file_tracker.log"

set -euo pipefail

# Version: v2.0MAX_SIZE=$((50*1024*1024))  # 50MB

# Configuration Section

WATCH_DIR="${WATCH_DIR:-}"# Last Modified: 2025-10-19

LOG_FILE="${LOG_FILE:-}"

MAX_SIZE=${MAX_SIZE:-$((50*1024*1024))}# 清理日志

LOCK_FILE="/tmp/file_tracker_clean.lock"

CLEAN_LOG="/var/log/file_tracker_clean.log"set -euo pipefail  # Strict mode: exit on error, undefined variables, pipe failuresif [ -f "$LOG_FILE" ]; then

BACKUP_DIR="${BACKUP_DIR:-/tmp/file_tracker_backups}"

LOG_KEEP_LINES="${LOG_KEEP_LINES:-1000}"    LOG_SIZE=$(stat -c%s "$LOG_FILE")



# Color Output# ==================== Configuration Section ====================    if [ "$LOG_SIZE" -gt "$MAX_SIZE" ]; then

RED='\033[0;31m'

GREEN='\033[0;32m'WATCH_DIR="${WATCH_DIR:-}"  # Read from environment variable or leave empty        echo "[`date`] 日志过大，截取最近1000行" >> "$LOG_FILE"

YELLOW='\033[1;33m'

BLUE='\033[0;34m'LOG_FILE="${LOG_FILE:-}"        tail -n 1000 "$LOG_FILE" > "${LOG_FILE}.tmp"

NC='\033[0m'

MAX_SIZE=${MAX_SIZE:-$((50*1024*1024))}  # Default: 50MB        mv "${LOG_FILE}.tmp" "$LOG_FILE"

# Logging Functions

log() {LOCK_FILE="/tmp/file_tracker_clean.lock"    fi

    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$CLEAN_LOG"

}CLEAN_LOG="/var/log/file_tracker_clean.log"fi



error() {BACKUP_DIR="${BACKUP_DIR:-/tmp/file_tracker_backups}"

    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$CLEAN_LOG" >&2

}LOG_KEEP_LINES="${LOG_KEEP_LINES:-1000}"# 清理 Git 历史



warn() {if [ -d "$WATCH_DIR/.git" ]; then

    echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$CLEAN_LOG"

}# ==================== Color Output ====================    GIT_SIZE=$(du -sb "$WATCH_DIR/.git" | cut -f1)



info() {RED='\033[0;31m'    if [ "$GIT_SIZE" -gt "$MAX_SIZE" ]; then

    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$CLEAN_LOG"

}GREEN='\033[0;32m'        echo "[`date`] Git仓库过大，裁剪历史并回收" >> "$LOG_FILE"



# Preflight ChecksYELLOW='\033[1;33m'        cd "$WATCH_DIR"

preflight_check() {

    if [ -z "$WATCH_DIR" ]; thenBLUE='\033[0;34m'        git checkout master

        error "WATCH_DIR is not set! Please set environment variable: export WATCH_DIR=/your/workspace"

        error "Or source the config file: source clean_config.env"NC='\033[0m' # No Color        git branch temp_clean

        exit 1

    fi        git reset --soft $(git rev-list --max-count=50 HEAD)



    if [ -z "$LOG_FILE" ]; then# ==================== Logging Functions ====================        git commit -m "[file_tracker] history trim"

        error "LOG_FILE is not set! Please set environment variable: export LOG_FILE=/your/log/file_tracker.log"

        error "Or source the config file: source clean_config.env"log() {        git reflog expire --expire=now --all

        exit 1

    fi    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$CLEAN_LOG"        git gc --prune=now --aggressive



    if [ ! -d "$WATCH_DIR" ]; then}    fi

        error "Watch directory does not exist: $WATCH_DIR"

        exit 1fi

    fi

error() {

    if [ ! -d "$WATCH_DIR/.git" ]; then

        warn "Not a Git repository, skipping Git cleanup: $WATCH_DIR"    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$CLEAN_LOG" >&2

        SKIP_GIT=1}

    else

        SKIP_GIT=0warn() {

    fi    echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$CLEAN_LOG"

}

    for cmd in git stat du tail tar; do

        if ! command -v "$cmd" &>/dev/null; theninfo() {

            error "Required command not found: $cmd"    echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$CLEAN_LOG"

            exit 1}

        fi

    done# ==================== Preflight Checks ====================

preflight_check() {

    mkdir -p "$BACKUP_DIR"    # 1. Check required environment variables

    if [ -z "$WATCH_DIR" ]; then

    touch "$CLEAN_LOG" 2>/dev/null || {        error "WATCH_DIR is not set! Please set environment variable: export WATCH_DIR=/your/workspace"

        warn "Cannot write to $CLEAN_LOG, using /tmp/file_tracker_clean.log"        error "Or source the config file: source clean_config.env"

        CLEAN_LOG="/tmp/file_tracker_clean.log"        exit 1

    }    fi



    log "Preflight check passed"    if [ -z "$LOG_FILE" ]; then

}        error "LOG_FILE is not set! Please set environment variable: export LOG_FILE=/your/log/file_tracker.log"

        error "Or source the config file: source clean_config.env"

# Lock Mechanism        exit 1

acquire_lock() {    fi

    if [ -e "$LOCK_FILE" ]; then

        local lock_pid    # 2. Check if directory exists

        lock_pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "unknown")    if [ ! -d "$WATCH_DIR" ]; then

                error "Watch directory does not exist: $WATCH_DIR"

        if kill -0 "$lock_pid" 2>/dev/null; then        exit 1

            error "Cleanup task is already running (PID: $lock_pid), exiting"    fi

            exit 0

        else    # 3. Check if it's a Git repository

            warn "Stale lock file found, removing it"    if [ ! -d "$WATCH_DIR/.git" ]; then

            rm -f "$LOCK_FILE"        warn "Not a Git repository, skipping Git cleanup: $WATCH_DIR"

        fi        SKIP_GIT=1

    fi    else

            SKIP_GIT=0

    echo $$ > "$LOCK_FILE"    fi

    trap "rm -f '$LOCK_FILE'; log 'Cleanup task finished'" EXIT INT TERM

}    # 4. Check required commands

    for cmd in git stat du tail tar; do

# Log File Cleanup        if ! command -v "$cmd" &>/dev/null; then

clean_log_file() {            error "Required command not found: $cmd"

    log "Checking log file: $LOG_FILE"            exit 1

        fi

    if [ ! -f "$LOG_FILE" ]; then    done

        warn "Log file does not exist, skipping cleanup"

        return 0    # 5. Create backup directory

    fi    mkdir -p "$BACKUP_DIR"



    local log_size    # 6. Ensure clean log file exists

    log_size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)    touch "$CLEAN_LOG" 2>/dev/null || {

        warn "Cannot write to $CLEAN_LOG, using /tmp/file_tracker_clean.log"

    if [ "$log_size" -le "$MAX_SIZE" ]; then        CLEAN_LOG="/tmp/file_tracker_clean.log"

        info "Log size is normal ($(numfmt --to=iec-i --suffix=B "$log_size" 2>/dev/null || echo "${log_size}B")), no cleanup needed"    }

        return 0

    fi    log "Preflight check passed"

}

    warn "Log file is too large ($(numfmt --to=iec-i --suffix=B "$log_size" 2>/dev/null || echo "${log_size}B")), starting cleanup..."

# ==================== Lock Mechanism ====================

    local backup_file="$BACKUP_DIR/file_tracker_$(date +%Y%m%d_%H%M%S).log.bak"acquire_lock() {

    if cp "$LOG_FILE" "$backup_file"; then    if [ -e "$LOCK_FILE" ]; then

        log "Log file backed up to: $backup_file"        local lock_pid

    else        lock_pid=$(cat "$LOCK_FILE" 2>/dev/null || echo "unknown")

        error "Log backup failed, aborting cleanup"        

        return 1        # Check if process is actually running

    fi        if kill -0 "$lock_pid" 2>/dev/null; then

            error "Cleanup task is already running (PID: $lock_pid), exiting"

    local temp_file="${LOG_FILE}.tmp.$$"            exit 0

    if tail -n "$LOG_KEEP_LINES" "$LOG_FILE" > "$temp_file" 2>/dev/null; then        else

        if mv "$temp_file" "$LOG_FILE"; then            warn "Stale lock file found, removing it"

            log "Log file truncated, kept last $LOG_KEEP_LINES lines"            rm -f "$LOCK_FILE"

            local new_size        fi

            new_size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)    fi

            log "New log size: $(numfmt --to=iec-i --suffix=B "$new_size" 2>/dev/null || echo "${new_size}B")"    

        else    echo $$ > "$LOCK_FILE"

            error "Failed to move temp file, keeping original"    trap "rm -f '$LOCK_FILE'; log 'Cleanup task finished'" EXIT INT TERM

            rm -f "$temp_file"}

            return 1

        fi# ==================== Log File Cleanup ====================

    elseclean_log_file() {

        error "Log truncation failed, keeping original file"    log "Checking log file: $LOG_FILE"

        rm -f "$temp_file"

        return 1    if [ ! -f "$LOG_FILE" ]; then

    fi        warn "Log file does not exist, skipping cleanup"

}        return 0

    fi

# Git History Cleanup (Safe Version)

clean_git_history() {    local log_size

    if [ "$SKIP_GIT" -eq 1 ]; then    log_size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)

        return 0

    fi    if [ "$log_size" -le "$MAX_SIZE" ]; then

        info "Log size is normal ($(numfmt --to=iec-i --suffix=B "$log_size" 2>/dev/null || echo "${log_size}B")), no cleanup needed"

    log "Checking Git repository: $WATCH_DIR"        return 0

    fi

    local git_size

    git_size=$(du -sb "$WATCH_DIR/.git" 2>/dev/null | cut -f1 || echo 0)    warn "Log file is too large ($(numfmt --to=iec-i --suffix=B "$log_size" 2>/dev/null || echo "${log_size}B")), starting cleanup..."



    if [ "$git_size" -le "$MAX_SIZE" ]; then    # Backup original log

        info "Git repository size is normal ($(numfmt --to=iec-i --suffix=B "$git_size" 2>/dev/null || echo "${git_size}B")), no cleanup needed"    local backup_file="$BACKUP_DIR/file_tracker_$(date +%Y%m%d_%H%M%S).log.bak"

        return 0    if cp "$LOG_FILE" "$backup_file"; then

    fi        log "Log file backed up to: $backup_file"

    else

    warn "Git repository is too large ($(numfmt --to=iec-i --suffix=B "$git_size" 2>/dev/null || echo "${git_size}B")), starting cleanup..."        error "Log backup failed, aborting cleanup"

        return 1

    cd "$WATCH_DIR" || {    fi

        error "Cannot enter directory: $WATCH_DIR"

        return 1    # Truncate to keep last N lines

    }    local temp_file="${LOG_FILE}.tmp.$$"

    if tail -n "$LOG_KEEP_LINES" "$LOG_FILE" > "$temp_file" 2>/dev/null; then

    local current_branch        if mv "$temp_file" "$LOG_FILE"; then

    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")            log "Log file truncated, kept last $LOG_KEEP_LINES lines"

    info "Current branch: $current_branch"            local new_size

            new_size=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)

    if ! git diff-index --quiet HEAD -- 2>/dev/null; then            log "New log size: $(numfmt --to=iec-i --suffix=B "$new_size" 2>/dev/null || echo "${new_size}B")"

        error "Uncommitted changes detected, aborting Git cleanup"        else

        error "Please commit or stash changes first: git add -A && git commit -m 'save work'"            error "Failed to move temp file, keeping original"

        return 1            rm -f "$temp_file"

    fi            return 1

        fi

    local git_backup="$BACKUP_DIR/git_backup_$(date +%Y%m%d_%H%M%S).tar.gz"    else

    log "Backing up Git repository..."        error "Log truncation failed, keeping original file"

    if tar -czf "$git_backup" .git 2>/dev/null; then        rm -f "$temp_file"

        log "Git repository backed up to: $git_backup"        return 1

    else    fi

        error "Git backup failed, aborting cleanup"}

        return 1

    fi# ==================== Git History Cleanup (Safe Version) ====================

clean_git_history() {

    log "Running Git garbage collection..."    if [ "$SKIP_GIT" -eq 1 ]; then

            return 0

    if git reflog expire --expire=now --all 2>/dev/null; then    fi

        info "Reflog expired"

    else    log "Checking Git repository: $WATCH_DIR"

        warn "Failed to expire reflog"

    fi    local git_size

        git_size=$(du -sb "$WATCH_DIR/.git" 2>/dev/null | cut -f1 || echo 0)

    if git gc --prune=now --aggressive 2>/dev/null; then

        info "Garbage collection completed"    if [ "$git_size" -le "$MAX_SIZE" ]; then

    else        info "Git repository size is normal ($(numfmt --to=iec-i --suffix=B "$git_size" 2>/dev/null || echo "${git_size}B")), no cleanup needed"

        warn "Garbage collection encountered issues"        return 0

    fi    fi



    local new_size    warn "Git repository is too large ($(numfmt --to=iec-i --suffix=B "$git_size" 2>/dev/null || echo "${git_size}B")), starting cleanup..."

    new_size=$(du -sb "$WATCH_DIR/.git" 2>/dev/null | cut -f1 || echo 0)

    log "Git cleanup completed, new size: $(numfmt --to=iec-i --suffix=B "$new_size" 2>/dev/null || echo "${new_size}B")"    cd "$WATCH_DIR" || {

        error "Cannot enter directory: $WATCH_DIR"

    if [ "$new_size" -gt "$MAX_SIZE" ]; then        return 1

        warn "Git repository is still too large, consider manual deep cleanup:"    }

        warn "  Method 1: git filter-repo --refs HEAD~100..HEAD"

        warn "  Method 2: git clone --depth 100 file://$WATCH_DIR /tmp/shallow && mv /tmp/shallow/.git $WATCH_DIR/"    # Check current branch

        warn "  Method 3: Remove unnecessary large files and reinitialize repository"    local current_branch

    fi    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "detached")

}    info "Current branch: $current_branch"



# Backup Rotation    # Check for uncommitted changes

rotate_backups() {    if ! git diff-index --quiet HEAD -- 2>/dev/null; then

    local backup_retention_days="${BACKUP_RETENTION_DAYS:-7}"        error "Uncommitted changes detected, aborting Git cleanup"

            error "Please commit or stash changes first: git add -A && git commit -m 'save work'"

    if [ ! -d "$BACKUP_DIR" ]; then        return 1

        return 0    fi

    fi

        # Backup current repository

    log "Rotating backups older than $backup_retention_days days..."    local git_backup="$BACKUP_DIR/git_backup_$(date +%Y%m%d_%H%M%S).tar.gz"

        log "Backing up Git repository..."

    local deleted_count=0    if tar -czf "$git_backup" .git 2>/dev/null; then

    while IFS= read -r -d '' backup_file; do        log "Git repository backed up to: $git_backup"

        rm -f "$backup_file"    else

        ((deleted_count++))        error "Git backup failed, aborting cleanup"

    done < <(find "$BACKUP_DIR" -type f -mtime +"$backup_retention_days" -print0 2>/dev/null)        return 1

        fi

    if [ "$deleted_count" -gt 0 ]; then

        log "Deleted $deleted_count old backup file(s)"    # Method: Use git gc to reclaim space (safest approach)

    else    log "Running Git garbage collection..."

        info "No old backups to delete"    

    fi    # Expire all reflog entries

}    if git reflog expire --expire=now --all 2>/dev/null; then

        info "Reflog expired"

# Main Function    else

main() {        warn "Failed to expire reflog"

    log "=========================================="    fi

    log "File Tracker Cleanup Task Started"    

    log "=========================================="    # Run aggressive garbage collection

    log "Configuration:"    if git gc --prune=now --aggressive 2>/dev/null; then

    log "  WATCH_DIR: $WATCH_DIR"        info "Garbage collection completed"

    log "  LOG_FILE: $LOG_FILE"    else

    log "  MAX_SIZE: $(numfmt --to=iec-i --suffix=B "$MAX_SIZE" 2>/dev/null || echo "${MAX_SIZE}B")"        warn "Garbage collection encountered issues"

    log "  BACKUP_DIR: $BACKUP_DIR"    fi

    log "=========================================="

    local new_size

    preflight_check    new_size=$(du -sb "$WATCH_DIR/.git" 2>/dev/null | cut -f1 || echo 0)

    acquire_lock    log "Git cleanup completed, new size: $(numfmt --to=iec-i --suffix=B "$new_size" 2>/dev/null || echo "${new_size}B")"



    clean_log_file    # If still too large, suggest advanced cleanup

    clean_git_history    if [ "$new_size" -gt "$MAX_SIZE" ]; then

    rotate_backups        warn "Git repository is still too large, consider manual deep cleanup:"

        warn "  Method 1: git filter-repo --refs HEAD~100..HEAD"

    log "=========================================="        warn "  Method 2: git clone --depth 100 file://$WATCH_DIR /tmp/shallow && mv /tmp/shallow/.git $WATCH_DIR/"

    log "Cleanup Task Completed Successfully"        warn "  Method 3: Remove unnecessary large files and reinitialize repository"

    log "=========================================="    fi

}}



# Execute# ==================== Backup Rotation ====================

main "$@"rotate_backups() {

    local backup_retention_days="${BACKUP_RETENTION_DAYS:-7}"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        return 0
    fi
    
    log "Rotating backups older than $backup_retention_days days..."
    
    local deleted_count=0
    while IFS= read -r -d '' backup_file; do
        rm -f "$backup_file"
        ((deleted_count++))
    done < <(find "$BACKUP_DIR" -type f -mtime +"$backup_retention_days" -print0 2>/dev/null)
    
    if [ "$deleted_count" -gt 0 ]; then
        log "Deleted $deleted_count old backup file(s)"
    else
        info "No old backups to delete"
    fi
}

# ==================== Main Function ====================
main() {
    log "=========================================="
    log "File Tracker Cleanup Task Started"
    log "=========================================="
    log "Configuration:"
    log "  WATCH_DIR: $WATCH_DIR"
    log "  LOG_FILE: $LOG_FILE"
    log "  MAX_SIZE: $(numfmt --to=iec-i --suffix=B "$MAX_SIZE" 2>/dev/null || echo "${MAX_SIZE}B")"
    log "  BACKUP_DIR: $BACKUP_DIR"
    log "=========================================="

    preflight_check
    acquire_lock

    clean_log_file
    clean_git_history
    rotate_backups

    log "=========================================="
    log "Cleanup Task Completed Successfully"
    log "=========================================="
}

# ==================== Execute ====================
main "$@"
