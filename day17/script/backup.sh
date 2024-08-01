#!/bin/bash

# Set variables
DATABASE_NAME=mydatabase
BACKUP_DIR=/var/backups/mysql
DATE=$(date +"%Y-%m-%d")

# Create backup file name
BACKUP_FILE="${BACKUP_DIR}/${DATABASE_NAME}_${DATE}.sql"

# Dump database to backup file
mysqldump -u shreya -p${database_password} ${DATABASE_NAME} > ${BACKUP_FILE}


# Remove old backups (keep only 2 days)
find ${BACKUP_DIR} -type f -mtime +2 -delete
