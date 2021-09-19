#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# HOT BANNER

PROC_DIR='data/procedures'
PROCEDURE_INDEX='hi-procedures.index'
HINTEL_INDEX='hi-hintel.index'
LINTEL_INDEX='hi-lintel.index'
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

function display_procedure_count () {
    local PROC_COUNT=`cd $PROC_DIR && find . -type d | awk -F/ '{print $2}' | \
        sort -u | sed '/^$/d' | wc -l && cd - &> /dev/null`
    echo $PROC_COUNT
    return $?
}

function display_hintel_count () {
    local HINTEL_COUNT=`cd $PROC_DIR && find . -type d | awk -F/ '{print $3}' | \
        sort -u | sed '/^$/d' | wc -l && cd - &> /dev/null`
    echo $HINTEL_COUNT
    return $?
}

function display_lintel_count () {
    local COUNT=0
    local LINTEL_COUNT=`cd $PROC_DIR && find . -type f | grep -v '.index' | \
        awk -F/ '{print $4}' | sed '/^$/d' | sort -u | wc -l && cd - &> /dev/null`
    echo $LINTEL_COUNT
    return $?
}

function display_hot_banner () {
    local PROCEDURE_COUNT=`display_procedure_count`
    local HINTEL_COUNT=`display_hintel_count`
    local LINTEL_COUNT=`display_lintel_count`
    cat<<EOF

    ${CYAN}Top  Level Procedures${RESET}   : ${WHITE}${PROCEDURE_COUNT}${RESET}
    ${CYAN}High Level Instructions${RESET} : ${WHITE}${HINTEL_COUNT}${RESET}
    ${CYAN}Low  Level Instructions${RESET} : ${WHITE}${LINTEL_COUNT}${RESET}
EOF
}

display_hot_banner

# CODE DUMP
