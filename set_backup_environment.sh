#!/bin/bash

# Don't allow uninitialized variables
set -u

# Exit on any non-zero return value
set -e

# The backup directory
BACKUP_DIR=/media/Backup

# The desired free space on the backup disk in kilobytes
DESIRED_FREE=100000000

# Force a non zero return if the backup directory is not mounted
function is_backup_mounted {
  return $(mount | grep "${BACKUP_DIR}" > /dev/null 2>&1) 
}

# Delete a file or directory and log the deletion
function delete_file {
  FILE_NAME="${1}"
  rm -R "${FILE_NAME}"
  logger "Removed ${FILE_NAME}"
}

