#!/bin/bash

# Define log file
LOG_FILE="/home/einfochips/Desktop/learning/day21/system/system_performance.log"

# Create or clear the log file
> $LOG_FILE

# Function to log system date and time
log_date() {
    echo "System Performance Report - $(date)" >> $LOG_FILE
}

# Function to check disk usage
check_disk_usage() {
    echo "Checking Disk Usage..." >> $LOG_FILE
    df -h >> $LOG_FILE
    if [ $? -eq 0 ]; then
        echo "Disk usage check completed successfully." >> $LOG_FILE
    else
        echo "Error occurred during disk usage check." >> $LOG_FILE
    fi
}

# Function to check memory usage
check_memory_usage() {
    echo "Checking Memory Usage..." >> $LOG_FILE
    free -h >> $LOG_FILE
    if [ $? -eq 0 ]; then
        echo "Memory usage check completed successfully." >> $LOG_FILE
    else
        echo "Error occurred during memory usage check." >> $LOG_FILE
    fi
}

# Function to check CPU load
check_cpu_load() {
    echo "Checking CPU Load..." >> $LOG_FILE
    top -bn1 | grep "Cpu(s)" >> $LOG_FILE
    if [ $? -eq 0 ]; then
        echo "CPU load check completed successfully." >> $LOG_FILE
    else
        echo "Error occurred during CPU load check." >> $LOG_FILE
    fi
}

# Execute functions
log_date
check_disk_usage
check_memory_usage
check_cpu_load

# Print result to console
cat $LOG_FILE
