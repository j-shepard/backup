#!/bin/bash

. ./set_backup_environment.sh

function cleanup_day {
  declare -A DAY_COUNT

  YESTERDAY=$(date --date "now -1 day" "+%Y%m%d")
  for FILE_NAME in "${BACKUP_DIR}"/back*
  do
    FILE_DATE=${FILE_NAME: -19:4}${FILE_NAME: -14:2}${FILE_NAME: -11:2}
    if (("${FILE_DATE}" < "${YESTERDAY}"))
    then
      COUNT=${DAY_COUNT["${FILE_DATE}"]:-0}
      COUNT=$(expr $COUNT + 1)
      DAY_COUNT["${FILE_DATE}"]=${COUNT}
    fi
  done
  
  for FILE_DATE in ${!DAY_COUNT[@]}
  do
    COUNT=${DAY_COUNT["${FILE_DATE}"]}
    if ((${COUNT} > 1))
    then
      #echo ${FILE_DATE} ${COUNT}
      FILE_PATTERN="${BACKUP_DIR}/back-${FILE_DATE:0:4}-${FILE_DATE:4:2}-${FILE_DATE:6:2}"
      for FILE_NAME in $(ls -d "${FILE_PATTERN}"* | sort)
      do
        if ((${COUNT} > 1))
        then
          delete_file "${FILE_NAME}"
          COUNT=$(expr $COUNT - 1)
        fi
      done
    fi
  done
}

is_backup_mounted
cleanup_day
