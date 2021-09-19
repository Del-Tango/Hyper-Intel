#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# COLD BANNER

declare -A MD_DEFAULT

SCRIPT_NAME="HyperIntel"
MD_DEFAULT=( ['tmp-file']="/tmp/hi-cb-${RANDOM}.tmp" )
BLACK=`tput setaf 0`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
RESET=`tput sgr0`

function display_cold_banner () {
    figlet -f lean -w 1000 "$SCRIPT_NAME" > "${MD_DEFAULT['tmp-file']}"
    clear; echo -n "${BLUE}`cat ${MD_DEFAULT['tmp-file']}`${RESET}
" && rm ${MD_DEFAULT['tmp-file']} &> /dev/null
    return 0
}

display_cold_banner
