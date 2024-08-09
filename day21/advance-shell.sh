#!/bin/bash

# Define variables
LOG_DIR="/home/einfochips/Desktop/learning/day21/advance"
ARCHIVE_DIR="/home/einfochips/Desktop/learning/day21/advance_archive"
REPORT_FILE="/home/einfochips/Desktop/learning/day21/advance/advance_log_management_report.log"
DAYS_OLD=30
MAX_SIZE=10000000  # 10 MB in bytes

# Ensure the log directory exists
ensure_directory() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo "Directory $dir does not exist. Creating it."
        mkdir -p "$dir"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create directory $dir." >&2
            exit 1
        fi
    fi
}

# Initialize or clear the report file
initialize_report() {
    > "$REPORT_FILE"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to initialize report file $REPORT_FILE." >&2
        exit 1
    fi
    echo "Log Management Report - $(date)" >> "$REPORT_FILE"
}

# Rotate and compress logs
rotate_and_compress_logs() {
    for log_file in "$LOG_DIR"/*.log; do
        if [ -f "$log_file" ]; then
            local file_size
            file_size=$(stat -c%s "$log_file")
            if [ $file_size -gt $MAX_SIZE ]; then
                local archived_file="$ARCHIVE_DIR/$(basename "$log_file")-$(date +%F).log"
                mv "$log_file" "$archived_file"
                if [ $? -ne 0 ]; then
                    echo "Error: Failed to move log file $log_file to $archived_file." >&2
                    continue
                fi
                gzip "$archived_file"
                if [ $? -ne 0 ]; then
                    echo "Error: Failed to compress log file $archived_file." >&2
                    continue
                fi
                echo "Rotated and compressed: $(basename "$log_file")" >> "$REPORT_FILE"
            fi
        else
            echo "Warning: No log files found in $LOG_DIR." >> "$REPORT_FILE"
        fi
    done
}

# Delete old logs from the archive directory
delete_old_logs() {
    find "$ARCHIVE_DIR" -type f -mtime +$DAYS_OLD -exec rm {} \;
    if [ $? -ne 0 ]; then
        echo "Error: Failed to delete old logs from $ARCHIVE_DIR." >&2
        exit 1
    fi
    echo "Deleted logs older than $DAYS_OLD days from $ARCHIVE_DIR." >> "$REPORT_FILE"
}

# Main function to execute log management tasks
main() {
    # Ensure required directories exist
    ensure_directory "$LOG_DIR"
    ensure_directory "$ARCHIVE_DIR"

    # Initialize the report file
    initialize_report

    # Perform log rotation and compression
    rotate_and_compress_logs

    # Delete old logs
    delete_old_logs

    # Print the report to the console
    cat "$REPORT_FILE"
}

# Execute the main function
main
