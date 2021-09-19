#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# SETUP

function project_setup () {
    lock_and_load
    load_project_config
    create_project_menu_controllers
    setup_project_menu_controllers
    return 0
}

function setup_project_menu_controllers () {
    setup_project_dependencies
    setup_main_menu_controller
    setup_control_panel_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller setup complete."
    return 0
}

# LOADERS

function load_project_config () {
    load_project_script_name
    load_project_prompt_string
    load_settings_project_default
    load_project_logging_levels
    load_project_cargo_scripts
}

function load_project_cargo_scripts () {
    if [ ${#HI_CARGO[@]} -eq 0 ]; then
        warning_msg "No cargo scripts found docked to $HI_SCRIPT_NAME."
        return 1
    fi
    for cargo in ${!HI_CARGO[@]}; do
        load_cargo "$cargo" "${HI_CARGO[$cargo]}"
    done
    return $?
}

function load_project_prompt_string () {
    if [ -z "$HI_PS3" ]; then
        warning_msg "No default prompt string found. Defaulting to $MD_PS3."
        return 1
    fi
    local PPROMPT="${BLUE}${HI_PS3}${RESET}"
    set_project_prompt "$PPROMPT"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load prompt string ${RED}$HI_PS3${RESET}."
    else
        ok_msg "Successfully loaded"\
            "prompt string ${GREEN}$HI_PS3${RESET}"
    fi
    return $EXIT_CODE
}

function load_project_logging_levels () {
    if [ ${#HI_LOGGING_LEVELS[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} logging levels found."
        return 1
    fi
    MD_LOGGING_LEVELS=( ${HI_LOGGING_LEVELS[@]} )
    ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} logging levels."
    return 0
}

function load_settings_project_default () {
    if [ ${#HI_DEFAULT[@]} -eq 0 ]; then
        warning_msg "No ${BLUE}$SCRIPT_NAME${RESET} defaults found."
        return 1
    fi
    for sc_setting in ${!HI_DEFAULT[@]}; do
        MD_DEFAULT[$sc_setting]=${HI_DEFAULT[$sc_setting]}
        ok_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET}"\
            "default setting"\
            "(${GREEN}$sc_setting - ${HI_DEFAULT[$sc_setting]}${RESET})."
    done
    done_msg "Successfully loaded ${BLUE}$SCRIPT_NAME${RESET} default settings."
    return 0
}

function load_project_script_name () {
    if [ -z "$HI_SCRIPT_NAME" ]; then
        warning_msg "No default script name found. Defaulting to $SCRIPT_NAME."
        return 1
    fi
    set_project_name "$HI_SCRIPT_NAME"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not load script name ${RED}$HI_SCRIPT_NAME${RESET}."
    else
        ok_msg "Successfully loaded"\
            "script name ${GREEN}$HI_SCRIPT_NAME${RESET}"
    fi
    return $EXIT_CODE
}

# SETUP DEPENDENCIES

function setup_project_dependencies () {
    setup_project_apt_dependencies
    return 0
}

function setup_project_apt_dependencies () {
    if [ ${#HI_APT_DEPENDENCIES[@]} -eq 0 ]; then
        warning_msg "No ${RED}$SCRIPT_NAME${RESET} dependencies found."
        return 1
    fi
    FAILURE_COUNT=0
    SUCCESS_COUNT=0
    for util in ${HI_APT_DEPENDENCIES[@]}; do
        add_apt_dependency "$util"
        if [ $? -ne 0 ]; then
            FAILURE_COUNT=$((FAILURE_COUNT + 1))
        else
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        fi
    done
    done_msg "(${GREEN}$SUCCESS_COUNT${RESET}) ${BLUE}$SCRIPT_NAME${RESET}"\
        "dependencies staged for installation using the APT package manager."\
        "(${RED}$FAILURE_COUNT${RESET}) failures."
    return 0
}

# MAIN MENU SETUP

function setup_main_menu_controller () {
    setup_main_menu_option_hyper_intel
    setup_main_menu_option_self_destruct
    setup_main_menu_option_control_panel
    setup_main_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_main_menu_option_hyper_intel () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Hyper-Intel${RESET}"\
        "to function ${MAGENTA}action_hyper_intel${RESET}..."
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" 'Hyper-Intel' 'action_hyper_intel'
    return $?
}

function setup_main_menu_option_self_destruct () {
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" "Self-Destruct" \
        'action_project_self_destruct'
    return $?
}

function setup_main_menu_option_control_panel () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Control-Panel${RESET}"\
        "to menu ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}"
    setup_menu_controller_menu_option \
        "$MAIN_CONTROLLER_LABEL" 'Control-Panel' "$SETTINGS_CONTROLLER_LABEL"
    return $?
}

function setup_main_menu_option_back () {
    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    setup_menu_controller_action_option \
        "$MAIN_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

# SETTINGS CONTROLLER

function setup_control_panel_menu_controller () {
    setup_control_panel_menu_option_set_safety_flag
    setup_control_panel_menu_option_set_forced_flag
    setup_control_panel_menu_option_set_log_file
    setup_control_panel_menu_option_set_log_lines
    setup_control_panel_menu_option_install_dependencies
    setup_control_panel_menu_option_back
    done_msg "${CYAN}$MAIN_CONTROLLER_LABEL${RESET} controller option"\
        "binding complete."
    return 0
}

function setup_control_panel_menu_option_set_safety_flag () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Safety-FLAG${RESET}"\
        "to function ${MAGENTA}action_set_safety_flag${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Safety-FLAG' 'action_set_safety_flag'
    return $?
}

function setup_control_panel_menu_option_set_forced_flag () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Forced-FLAG${RESET}"\
        "to function ${MAGENTA}action_set_forced_flag${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Forced-FLAG' 'action_set_forced_flag'
    return $?
}

function setup_control_panel_menu_option_set_log_file () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-File${RESET}"\
        "to function ${MAGENTA}action_set_log_file${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-File' 'action_set_log_file'
    return $?
}

function setup_control_panel_menu_option_set_log_lines () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Log-Lines${RESET}"\
        "to function ${MAGENTA}action_set_log_lines${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Set-Log-Lines' 'action_set_log_lines'
    return $?
}

function setup_control_panel_menu_option_install_dependencies () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Install-Dependencies' \
        'action_install_project_dependencies'
    return $?
}

function setup_control_panel_menu_option_back () {
    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    setup_menu_controller_action_option \
        "$SETTINGS_CONTROLLER_LABEL" 'Back' 'action_back'
    return $?
}

#   # CODE DUMP
