#!/bin/bash

# Define log files and paths
LOG_FILE="/var/log/mysql/error.log"
SYSLOG_FILE="/var/log/syslog"
AUTH_LOG_FILE="/var/log/auth.log"


# Define function to check for specific issues
check_logs() {
    local file=$1
    local keyword=$2
    echo "Checking $file for '$keyword'..."
    grep "$keyword" "$file" | tail -n 5
}

# Check system logs for common issues
echo "Starting log check..."

echo "=== Application Log Errors ==="
check_logs $LOG_FILE "SHUTDOWN"
check_logs $LOG_FILE "crash"

echo "=== System Log Errors ==="
check_logs $SYSLOG_FILE "error"

echo "=== Authentication Failures ==="
check_logs $AUTH_LOG_FILE "authentication failure"

echo "Log check completed."


