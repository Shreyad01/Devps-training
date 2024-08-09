#!/bin/bash

# Define variables
LOG_DIR="/home/einfochips/Desktop/learning/day21/log"
ARCHIVE_DIR="/home/einfochips/Desktop/learning/day21/archive"
REPORT_FILE="/home/einfochips/Desktop/learning/day21/log/log_management_report.log"
DAYS_OLD=30
MAX_SIZE=10000000  # 10 MB in bytes

# Ensure directories exist
mkdir -p $ARCHIVE_DIR

# Create or clear the report file
> $REPORT_FILE

# Record date and time in the report
echo "Log Management Report - $(date)" >> $REPORT_FILE

# Rotate and compress logs
for log_file in $LOG_DIR/*.log; do
    if [ -f "$log_file" ]; then
        file_size=$(stat -c%s "$log_file")
        if [ $file_size -gt $MAX_SIZE ]; then
            # Rotate the log file
            mv "$log_file" "$ARCHIVE_DIR/$(basename "$log_file")-$(date +%F).log"
            gzip "$ARCHIVE_DIR/$(basename "$log_file")-$(date +%F).log"
            echo "Rotated and compressed: $(basename "$log_file")" >> $REPORT_FILE
        fi
    fi
done

# Delete old logs from the archive directory
find $ARCHIVE_DIR -type f -mtime +$DAYS_OLD -exec rm {} \;
echo "Deleted logs older than $DAYS_OLD days from $ARCHIVE_DIR." >> $REPORT_FILE

# Print the report to the console
cat $REPORT_FILE
