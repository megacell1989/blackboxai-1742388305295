#!/bin/sh

# Configuration
BACKUP_DIR="/backups"
POSTGRES_HOST=${POSTGRES_HOST:-postgres}
POSTGRES_DB=${POSTGRES_DB:-pos_system}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}
BACKUP_RETAIN_DAYS=30

# Create backup directory if it doesn't exist
mkdir -p ${BACKUP_DIR}

# Function to create backup filename with timestamp
get_backup_filename() {
    echo "${BACKUP_DIR}/backup_$(date +%Y%m%d_%H%M%S).sql.gz"
}

# Function to perform backup
perform_backup() {
    BACKUP_FILE=$(get_backup_filename)
    echo "Creating backup: ${BACKUP_FILE}"
    
    if PGPASSWORD="${POSTGRES_PASSWORD}" pg_dump -h ${POSTGRES_HOST} -U ${POSTGRES_USER} ${POSTGRES_DB} | gzip > "${BACKUP_FILE}"; then
        echo "Backup completed successfully"
        # Create a symlink to the latest backup
        ln -sf "${BACKUP_FILE}" "${BACKUP_DIR}/latest.sql.gz"
    else
        echo "Backup failed"
        rm -f "${BACKUP_FILE}"
        return 1
    fi
}

# Function to clean old backups
clean_old_backups() {
    echo "Cleaning backups older than ${BACKUP_RETAIN_DAYS} days"
    find ${BACKUP_DIR} -type f -name "backup_*.sql.gz" -mtime +${BACKUP_RETAIN_DAYS} -delete
}

# Function to verify backup
verify_backup() {
    LATEST_BACKUP="${BACKUP_DIR}/latest.sql.gz"
    if [ -f "${LATEST_BACKUP}" ]; then
        echo "Verifying backup integrity"
        if gunzip -t "${LATEST_BACKUP}"; then
            echo "Backup verification successful"
            return 0
        else
            echo "Backup verification failed"
            return 1
        fi
    else
        echo "No backup file found to verify"
        return 1
    fi
}

# Main backup routine
main() {
    echo "Starting backup process at $(date)"
    
    # Wait for PostgreSQL to be ready
    until PGPASSWORD="${POSTGRES_PASSWORD}" pg_isready -h ${POSTGRES_HOST} -U ${POSTGRES_USER}; do
        echo "Waiting for PostgreSQL to be ready..."
        sleep 5
    done

    # Perform backup
    if perform_backup; then
        # Verify backup
        if verify_backup; then
            # Clean old backups
            clean_old_backups
            echo "Backup process completed successfully at $(date)"
            
            # Create success flag file
            touch "${BACKUP_DIR}/last_backup_success"
        else
            echo "Backup verification failed at $(date)"
            # Create failure flag file
            touch "${BACKUP_DIR}/last_backup_failed"
            exit 1
        fi
    else
        echo "Backup creation failed at $(date)"
        # Create failure flag file
        touch "${BACKUP_DIR}/last_backup_failed"
        exit 1
    fi
}

# Schedule backup
if [ "${1}" = "schedule" ]; then
    # Run backup every day at 1 AM
    while true; do
        current_hour=$(date +%H)
        if [ "${current_hour}" = "01" ]; then
            main
            # Sleep for 1 hour to avoid multiple backups
            sleep 3600
        else
            # Check every 5 minutes
            sleep 300
        fi
    done
else
    # Run backup once
    main
fi