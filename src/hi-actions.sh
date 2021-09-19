#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# ACTIONS

function action_hyper_intel () {
    action_hyper_intel_browse_procedures
    return $?
}

function action_hyper_intel_browse_procedures () {
    local OPTIONS=(
        "${GREEN}New-Procedure${RESET}"
        "${YELLOW}Root-Index${RESET}"
        `cd ${MD_DEFAULT['procedure-dir']} && find . -type d | \
            awk -F/ '{print $2}' | sort -u | sed '/^$/d' && cd - &> /dev/null`
        "${RED}Remove-Procedure${RESET}"
    )
    while :
    do
        display_formatted_procedure_index
        echo
        local SELECTION=`fetch_selection_from_user "${BLUE}H(i)TLP${RESET}" ${OPTIONS[@]}`
        if [ $? -ne 0 ] || [ -z "$SELECTION" ]; then
            break
        fi
        case "$SELECTION" in
            "${GREEN}New-Procedure${RESET}")
                action_hyper_intel_create_procedure
                ;;
            "${YELLOW}Root-Index${RESET}")
                action_hyper_intel_component_interact
                ;;
            "${RED}Remove-Procedure${RESET}")
                action_hyper_intel_remove_procedure
                ;;
            *)
                action_hyper_intel_browse_hintels "$SELECTION"
                ;;
        esac
    done
    return $?
}

function action_hyper_intel_browse_hintels () {
    local PROCEDURE="$1"
    local PROC_DIR="${MD_DEFAULT['procedure-dir']}/${PROCEDURE}"
    local OPTIONS=(
        "${GREEN}New-Hintel${RESET}"
        "${YELLOW}Hintel-Index${RESET}"
        `cd $PROC_DIR && find . -type d | awk -F/ '{print $2}' | \
            sort -u | sed '/^$/d' && cd - &> /dev/null`
        "${RED}Remove-Hintel${RESET}"
    )
    while :
    do
        display_formatted_hintel_index "$PROCEDURE"
        echo
        local SELECTION=`fetch_selection_from_user "${BLUE}H(i)HLI${RESET}" ${OPTIONS[@]}`
        if [ $? -ne 0 ] || [ -z "$SELECTION" ]; then
            break
        fi
        case "$SELECTION" in
            "${GREEN}New-Hintel${RESET}")
                action_hyper_intel_create_hintel "$PROCEDURE"
                ;;
            "${YELLOW}Hintel-Index${RESET}")
                action_hyper_intel_component_interact "$PROCEDURE"
                ;;
            "${RED}Remove-Hintel${RESET}")
                action_hyper_intel_remove_hintel "$PROCEDURE"
                ;;
            *)
                action_hyper_intel_browse_lintels "$PROCEDURE" "$SELECTION"
                ;;
        esac
    done
    return $?
}

function action_hyper_intel_browse_lintels () {
    local PROCEDURE="$1"
    local HINTEL="$2"
    local HINTEL_DIR="${MD_DEFAULT['procedure-dir']}/${PROCEDURE}/${HINTEL}"
    local OPTIONS=(
        "${GREEN}New-Lintel${RESET}"
        "${YELLOW}Lintel-Index${RESET}"
        `cd $HINTEL_DIR && find . -type f | awk -F/ '{print $2}' | \
            grep -v "${MD_DEFAULT['lintel-index']}" | sort -u | \
            sed '/^$/d' && cd - &> /dev/null`
        "${RED}Remove-Lintel${RESET}"
    )
    while :
    do
        display_formatted_lintel_index "$PROCEDURE" "$HINTEL"
        echo
        local SELECTION=`fetch_selection_from_user "${BLUE}H(i)LLI${RESET}" ${OPTIONS[@]}`
        if [ $? -ne 0 ] || [ -z "$SELECTION" ]; then
            break
        fi
        case "$SELECTION" in
            "${GREEN}New-Lintel${RESET}")
                action_hyper_intel_create_lintel "$PROCEDURE" "$HINTEL"
                ;;
            "${YELLOW}Lintel-Index${RESET}")
                action_hyper_intel_component_interact "$PROCEDURE" "$HINTEL"
                ;;
            "${RED}Remove-Lintel${RESET}")
                action_hyper_intel_remove_lintel "$PROCEDURE" "$HINTEL"
                ;;
            *)
                action_hyper_intel_component_interact "$PROCEDURE" "$HINTEL" "$SELECTION"
                ;;
        esac
    done
    return $?
}

function action_hyper_intel_create_procedure () {
    echo; info_msg "Type new Top Level Procedure name or (${MAGENTA}.back${RESET}).
    "
    local NEW_PROCEDURE=`fetch_data_from_user "${GREEN}NewProcedure${RESET}"`
    if [ $? -ne 0 ] || [ -z "$NEW_PROCEDURE" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --create --procedure="$NEW_PROCEDURE"
    return $?
}

function action_hyper_intel_remove_procedure () {
    echo; info_msg "Type Top Level Procedure name or (${MAGENTA}.back${RESET}).
    "
    local PROCEDURE=`fetch_data_from_user "${RED}Procedure${RESET}"`
    if [ $? -ne 0 ] || [ -z "$PROCEDURE" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --remove --procedure="$PROCEDURE"
    return $?
}

function action_hyper_intel_remove_hintel () {
    local PROCEDURE="$1"
    echo; info_msg "Type (${PROCEDURE}) High Level Instruction name or (${MAGENTA}.back${RESET}).
    "
    local HINTEL=`fetch_data_from_user "${RED}Hintel${RESET}"`
    if [ $? -ne 0 ] || [ -z "$HINTEL" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --remove --procedure="$PROCEDURE" --hintel="$HINTEL"
    return $?
}

function action_hyper_intel_create_hintel () {
    local PROCEDURE="$1"
    echo; info_msg "Type new (${PROCEDURE}) High Level Instruction name or (${MAGENTA}.back${RESET}).
    "
    local HINTEL=`fetch_data_from_user "${BLUE}Hintel${RESET}"`
    if [ $? -ne 0 ] || [ -z "$HINTEL" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --create --procedure="$PROCEDURE" --hintel="$HINTEL"
    return $?
}

function action_hyper_intel_create_lintel () {
    local PROCEDURE="$1"
    local HINTEL="$2"
    echo; info_msg "Type new (${PROCEDURE}/${HINTEL}) Low Level Instruction name or (${MAGENTA}.back${RESET}).
    "
    local LINTEL=`fetch_data_from_user "${BLUE}Lintel${RESET}"`
    if [ $? -ne 0 ] || [ -z "$LINTEL" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --create --procedure="$PROCEDURE" --hintel="$HINTEL" --lintel="$LINTEL"
    return $?
}

function action_hyper_intel_remove_lintel () {
    local PROCEDURE="$1"
    local HINTEL="$2"
    echo; info_msg "Type (${PROCEDURE}/${HINTEL}) Low Level Instruction name or (${MAGENTA}.back${RESET}).
    "
    local LINTEL=`fetch_data_from_user "${RED}Lintel${RESET}"`
    if [ $? -ne 0 ] || [ -z "$HINTEL" ]; then
        return 0
    fi
    ${MD_CARGO['hyper-intel']} --remove --procedure="$PROCEDURE" --hintel="$HINTEL" --lintel="$LINTEL"
    return $?
}

function action_hyper_intel_component_interact () {
    local PROCEDURE="$1"
    local HINTEL="$2"
    local LINTEL="$3"
    if [ ! -z "$LINTEL" ] && [ ! -z "$HINTEL" ] && [ ! -z "$PROCEDURE" ]; then
        ${MD_CARGO['hyper-intel']} --find='text' --procedure="$PROCEDURE" --hintel="$HINTEL" --lintel="$LINTEL"
    elif [ ! -z "$HINTEL" ] && [ ! -z "$PROCEDURE" ]; then
        ${MD_CARGO['hyper-intel']} --find='text' --procedure="$PROCEDURE" --hintel="$HINTEL"
    elif [ ! -z "$PROCEDURE" ]; then
        ${MD_CARGO['hyper-intel']} --find='text' --procedure="$PROCEDURE"
    else
        ${MD_CARGO['hyper-intel']} --find='text'
    fi; echo
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        warning_msg "Component interaction failure! ($PROCEDURE/$HINTEL/$LINTEL)"
    else
        fetch_ultimatum_from_user "Edit component? ${YELLOW}Y/N${RESET}"
        if [ $? -eq 0 ]; then
            ${MD_CARGO['hyper-intel']} --edit --procedure="$PROCEDURE" --hintel="$HINTEL" --lintel="$LINTEL"
        fi
        echo
    fi
    return $EXIT_CODE
}

function action_set_forced_flag () {
    echo; case "$MD_SAFETY" in
        'on'|'On'|'ON')
            info_msg "Forced flag is (${GREEN}ON${RESET}), switching to (${RED}OFF${RESET}) -"
            action_set_forced_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Forced flag is (${RED}OFF${RESET}), switching to (${GREEN}ON${RESET}) -"
            action_set_forced_on
            ;;
        *)
            info_msg "Forced flag not set, switching to (${GREEN}ON${RESET}) -"
            action_set_forced_on
            ;;
    esac
    return $?
}

function action_set_safety_flag () {
    echo; case "$MD_SAFETY" in
        'on'|'On'|'ON')
            info_msg "Safety is (${GREEN}ON${RESET}), switching to (${RED}OFF${RESET}) -"
            action_set_safety_off
            ;;
        'off'|'Off'|'OFF')
            info_msg "Safety is (${RED}OFF${RESET}), switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
        *)
            info_msg "Safety not set, switching to (${GREEN}ON${RESET}) -"
            action_set_safety_on
            ;;
    esac
    return $?
}

function action_set_forced_on () {
    set_forced_flag 'on'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) forced flag"\
            "to (${GREEN}ON${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) forced flag"\
            "to (${GREEN}ON${RESET})."
    fi
    return $EXIT_CODE
}

function action_set_forced_off () {
    set_forced_flag 'off'
    EXIT_CODE=$?
    echo; if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set (${BLUE}$SCRIPT_NAME${RESET}) forced flag"\
            "to (${RED}OFF${RESET})."
    else
        ok_msg "Succesfully set (${BLUE}$SCRIPT_NAME${RESET}) forced flag"\
            "to (${RED}OFF${RESET})."
    fi
    return $EXIT_CODE
}

function action_install_project_dependencies () {
    action_install_dependencies 'apt'
    return $?
}

function action_project_self_destruct () {
    echo; info_msg "You are about to delete all (${RED}$SCRIPT_NAME${RESET})"\
        "project files from directory (${RED}${MD_DEFAULT['project-path']}${RESET})."
    fetch_ultimatum_from_user "${YELLOW}Are you sure about this? Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action."
        return 0
    fi
    check_safety_on
    if [ $? -ne 0 ]; then
        echo; warning_msg "Safety is (${GREEN}ON${RESET})!"\
            "Aborting self destruct sequence."
        return 0
    fi; echo
    symbol_msg "${RED}$SCRIPT_NAME${RESET}" "Initiating self destruct sequence!"
    action_self_destruct
    local EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "(${RED}$SCRIPT_NAME${RESET}) self destruct sequence failed!"
    else
        ok_msg "Destruction complete!"\
            "Project (${GREEN}$SCRIPT_NAME${RESET}) removed from system."
    fi
    return $EXIT_CODE
}

