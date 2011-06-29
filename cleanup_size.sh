#!/bin/bash

. ./set_backup_environment.sh

function cleanup_size {
  MAXIMUM_BACKUPS_TO_DELETE=5
  DELETE_COUNT=0
  for FILE_NAME in $(ls -1d "${BACKUP_DIR}"/back* | sort)
  do
    echo $FILE_NAME
    FREE=$(df -Pk "${BACKUP_DIR}" | grep "${BACKUP_DIR}" | awk '{ print $4 }')
    if [ ${FREE} -ge ${DESIRED_FREE} ]
    then
      exit 0
    fi
    echo ${FREE}kB free. Removing...
    delete_file "${FILE_NAME}"
    DELETE_COUNT=$(expr ${DELETE_COUNT} + 1)
    if [ ${DELETE_COUNT} -ge ${MAXIMUM_BACKUPS_TO_DELETE} ]
    then
      echo Maximum delete count reached. Exiting...
      exit 1
    fi
  done
}

is_backup_mounted
cleanup_size
