#!/bin/bash

. ./set_backup_environment.sh

DATE=`date "+%Y-%m-%dT%H_%M_%S"`
SOURCE_DIR=/
SOURCE_DIR2=/home
CURRENT_DIR=current
INCOMPLETE_DIR=incomplete_back-${DATE}
COMPLETED_DIR=back-${DATE}
EXCLUDE_FILE=/root/exclude

is_backup_mounted
rsync -ax \
  --delete \
  --delete-excluded \
  --exclude-from="${EXCLUDE_FILE}" \
  --link-dest="${BACKUP_DIR}/${CURRENT_DIR}" \
  "${SOURCE_DIR}" \
  "${SOURCE_DIR2}" \
  "${BACKUP_DIR}/${INCOMPLETE_DIR}"
cd "${BACKUP_DIR}"
mv "${INCOMPLETE_DIR}" "${COMPLETED_DIR}"
rm -f "${CURRENT_DIR}"
ln -s "${COMPLETED_DIR}" "${CURRENT_DIR}"
logger "Backup ${COMPLETED_DIR} successful."
