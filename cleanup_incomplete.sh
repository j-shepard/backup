#!/bin/bash

. ./set_backup_environment.sh

function delete_incomplete {
  YESTERDAY=$(date --date "now -1 day" "+%Y%m%d")
  for FILE_NAME in "${BACKUP_DIR}"/incomplete*
  do
    if [ -d "${FILE_NAME}" ]
    then
      FILE_DATE=${FILE_NAME: -19:4}${FILE_NAME: -14:2}${FILE_NAME: -11:2}
      if (("${FILE_DATE}" < "${YESTERDAY}"))
      then
        delete_file "${FILE_NAME}"
      fi
    fi
  done
}

is_backup_mounted
delete_incomplete

