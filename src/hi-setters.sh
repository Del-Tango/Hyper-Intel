#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETTERS

function set_forced_flag () {
    local FORCED_FLAG="$1"
    MD_DEFAULT['forced-flag']="$FORCED_FLAG"
    return $?
}

function set_log_file () {
    local FILE_PATH="$1"
    check_file_exists "$FILE_PATH"
    if [ $? -ne 0 ]; then
        error_msg "File (${RED}$FILE_PATH${RESET}) does not exist."
        return 1
    fi
    MD_DEFAULT['log-file']="$FILE_PATH"
    return 0
}

function set_log_lines () {
    local LOG_LINES=$1
    if [ -z "$LOG_LINES" ]; then
        error_msg "Log line value (${RED}$LOG_LINES${RESET}) is not a number."
        return 1
    fi
    MD_DEFAULT['log-lines']=$LOG_LINES
    return 0
}
