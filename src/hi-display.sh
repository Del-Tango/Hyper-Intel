#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# DISPLAY

function display_formatted_lintel_index () {
    local PROCEDURE="$1"
    local HINTEL="$2"
    local INDEX_FILE=`${MD_CARGO['hyper-intel']} --find=path --procedure="$PROCEDURE" --hintel="$HINTEL" | grep 'Path:' | cut -d":" -f 3 | xargs`
    echo; echo "[ ${BLUE}Low Level Instructions${RESET} ]: ${YELLOW}$INDEX_FILE${RESET}
    "
    echo ${CYAN}
    cat "$INDEX_FILE" | grep -e '^*' | sed 's/^* //g' | awk -F, '
    BEGIN {
        header_format = "%8s %28s %14s %20s %26s\n"
        record_format = "%4s %24s %20s %27s %25s\n"
        printf header_format,"Priority","Low Level Instructions","Status","Write Date","Create Date"
        print "_____________________________________________________________________________________________________________"
    }
    {
        print ""
        printf record_format,$1,$2,$3,$4,$5,$6
    }
    END {
        print "_____________________________________________________________________________________________________________"
    }'
    echo ${RESET}
    return $?
}

function display_formatted_hintel_index () {
    local PROCEDURE="$1"
    local INDEX_FILE=`${MD_CARGO['hyper-intel']} --find=path --procedure="$PROCEDURE" | grep 'Path:' | cut -d":" -f 3 | xargs`
    echo; echo "[ ${BLUE}High Level Instructions${RESET} ]: ${YELLOW}$INDEX_FILE${RESET}
    "
    echo ${CYAN}
    cat "$INDEX_FILE" | grep -e '^*' | sed 's/^* //g' | awk -F, '
    BEGIN {
        header_format = "%4s %14s %14s %13s %20s %26s\n"
        record_format = "%4s %19s %10s %14s %27s %25s\n"
        printf header_format,"Priority","Hintel","Lintels","Status","Write Date","Create Date"
        print "_____________________________________________________________________________________________________________"
    }
    {
        print ""
        printf record_format,$1,$2,$3,$4,$5,$6
    }
    END {
        print "_____________________________________________________________________________________________________________"
    }'
    echo ${RESET}
    return $?
}

function display_formatted_procedure_index () {
    local INDEX_FILE=`${MD_CARGO['hyper-intel']} --find=path | grep 'Path:' | cut -d":" -f 3 | xargs`
    echo; echo "[ ${BLUE}Top Level Procedures${RESET} ]: ${YELLOW}$INDEX_FILE${RESET}
    "
    echo ${CYAN}
    cat "$INDEX_FILE" | grep -e '^*' | sed 's/^* //g' | awk -F, '
    BEGIN {
        header_format = "%1s %14s %15s %13s %20s %26s\n"
        record_format = "%4s %21s %9s %14s %27s %25s\n"
        printf header_format,"Priority","Procedure","Hintels","Status","Write Date","Create Date"
        print "_____________________________________________________________________________________________________________"
    }
    {
        print ""
        printf record_format,$1,$2,$3,$4,$5,$6
    }
    END {
        print "_____________________________________________________________________________________________________________"
    }'
    echo ${RESET}
    return $?
}

function display_banners () {
    if [ -z "${MD_DEFAULT['banner']}" ]; then
        return 1
    fi
    case "${MD_DEFAULT['banner']}" in
        *','*)
            for cargo_key in `echo ${MD_DEFAULT['banner']} | sed 's/,/ /g'`; do
                ${MD_CARGO[$cargo_key]} "${MD_DEFAULT['conf-file']}"
            done
            ;;
        *)
            ${MD_CARGO[${MD_DEFAULT['banner']}]} "${MD_DEFAULT['conf-file']}"
            ;;
    esac
    return $?
}

function display_project_settings () {
    echo "[ ${CYAN}Banner${RESET}         ]: ${MAGENTA}${MD_DEFAULT['banner']}${RESET}
[ ${CYAN}Log File${RESET}       ]: ${YELLOW}`basename ${MD_DEFAULT['log-dir']}`/`basename ${MD_DEFAULT['log-file']}`${RESET}
[ ${CYAN}Log Lines${RESET}      ]: ${WHITE}${MD_DEFAULT['log-lines']}${RESET}
[ ${CYAN}Safety${RESET}         ]: `format_flag_colors $MD_SAFETY`
[ ${CYAN}Forced${RESET}         ]: `format_flag_colors ${MD_DEFAULT['forced-flag']}`"
    echo; return $?
}

