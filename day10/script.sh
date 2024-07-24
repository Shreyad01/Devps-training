#!/bin/bash

# Script Initialization
# ======================

# Define variables and configurations
LOG_FILE="sysmonitor.log"
REPORT_FILE="report.txt"
ALERT_THRESHOLD_CPU=100  
ALERT_THRESHOLD_MEMORY=90 
#EMAIL_RECIPIENT="shreya.daphal@einfochips.com"

# Function to check command availability
check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: $1 is required but not installed. Aborting."; exit 1; }
}

# Validate required commands and utilities
check_command top
check_command free
check_command df
check_command grep
check_command sed
check_command awk
check_command tail
check_command systemctl
check_command ping
#check_command mail

# System Metrics Collection
# =========================

# Function to monitor CPU usage
monitor_cpu() {
    echo "### CPU Usage ###"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage : " 100 - $1"%"}'
}

# Function to monitor memory usage
monitor_memory() {
    echo "### Memory Usage ###"
    free -m | awk 'NR==2{printf "Memory Usage : %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
}

# Function to monitor disk usage
monitor_disk() {
    echo "### Disk Usage ###"
    df -h | awk '$NF=="/"{printf "Disk Usage : %d/%dGB (%s)\n", $3,$2,$5}'
}

# Function to monitor network statistics
monitor_network() {
    echo "### Network Statistics ###"
    echo "Network Connectivity Check:"
    ping -c 4 google.com >/dev/null && echo "Ping successful" || echo "Ping failed"
}

# Function to capture top processes consuming resources
capture_top_processes() {
    echo "### Top Processes ###"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 10
}

# Log Analysis
# =============

# Function to parse system logs
parse_system_logs() {
    echo "### System Logs Analysis ###"
    echo "Recent Critical Events:"
    tail -n 20 /var/log/syslog | grep -iE 'error|warn' || echo "No critical events found."
}

# Health Checks
# ==============

# Function to check status of essential services
check_service_status() {
    echo "### Service Status ###"
    systemctl status apache2 | grep active || echo "Apache service is not running."
    systemctl status mysql | grep active || echo "MySQL service is not running."
}

# Function to verify connectivity to external services
check_external_services() {
    echo "### External Services Connectivity ###"
    echo "External Service (Google) Connectivity Check:"
    ping -c 4 google.com >/dev/null && echo "Ping successful" || echo "Ping failed"
}

# Alerting Mechanism
# ===================

# Function to trigger alerts based on thresholds
trigger_alerts() {
   echo "### Alerting System ###"
   local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
   local memory_usage=$(free | awk 'NR==2{printf "%.2f", $3*100/$2}')
    
   if (( $(echo "$cpu_usage > $ALERT_THRESHOLD_CPU" | bc -l) )); then
       echo "CPU Usage is above threshold ($ALERT_THRESHOLD_CPU%) - $cpu_usage%"
        #echo "Sending alert via email..."
       # echo "Subject: Alert - High CPU Usage ($cpu_usage%)" | mail -s "Alert - High CPU Usage ($cpu_usage%)" "$EMAIL_RECIPIENT"
   fi
    
   if (( $(echo "$memory_usage > $ALERT_THRESHOLD_MEMORY" | bc -l) )); then
        echo "Memory Usage is above threshold ($ALERT_THRESHOLD_MEMORY%) - $memory_usage%"
       # echo "Sending alert via email..."
       # echo "Subject: Alert - High Memory Usage ($memory_usage%)" | mail -s "Alert - High Memory Usage ($memory_usage%)" "$EMAIL_RECIPIENT"
    fi
}

# Report Generation
# ==================

# Function to generate system report
generate_system_report() {
    echo "### System Report ###"
    echo "Report generated at $(date)" > "$REPORT_FILE"
    monitor_cpu >> "$REPORT_FILE"
    monitor_memory >> "$REPORT_FILE"
    monitor_disk >> "$REPORT_FILE"
    monitor_network >> "$REPORT_FILE"
    capture_top_processes >> "$REPORT_FILE"
    parse_system_logs >> "$REPORT_FILE"
    check_service_status >> "$REPORT_FILE"
    check_external_services >> "$REPORT_FILE"
    trigger_alerts >> "$REPORT_FILE"
    echo "### End of Report ###" >> "$REPORT_FILE"
    echo "Report saved to: $REPORT_FILE"
    cat "$REPORT_FILE" >> "$LOG_FILE"
}

#  Automation and Scheduling
# ==========================

# Function to run script in interactive mode
run_interactive_mode() {
    echo "Running in Interactive Mode"
    generate_system_report
}

# Function to run script in non-interactive mode
run_non_interactive_mode() {
    echo "Running in Non-Interactive Mode"
    generate_system_report >> "$LOG_FILE" 2>&1
}

# Determine script mode: interactive or non-interactive
if [ -t 0 ]; then
    run_interactive_mode
else
    run_non_interactive_mode
fi


# End of Script
# ==============
