#!/bin/bash
#
# Regards, the Alveare Solutions society.
#
# CREATORS

function create_project_menu_controllers () {
    create_main_menu_controller
    create_control_panel_menu_controller
    done_msg "${BLUE}$SCRIPT_NAME${RESET} controller construction complete."
    return 0
}

function create_control_panel_menu_controller () {
    info_msg "Creating menu controller"\
        "${YELLOW}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$SETTINGS_CONTROLLER_LABEL" \
        "${RED}$SETTINGS_CONTROLLER_DESCRIPTION${RESET}"
    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$SETTINGS_CONTROLLER_LABEL" \
        "$SETTINGS_CONTROLLER_OPTIONS"
    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MAGENTA}display_project_settings${RESET}..."
    set_menu_controller_extended_banner "$SETTINGS_CONTROLLER_LABEL" \
        'display_project_settings'
    return 0
}

function create_main_menu_controller () {
    info_msg "Creating menu controller"\
        "${YELLOW}$MAIN_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$MAIN_CONTROLLER_LABEL" \
        "${RED}$MAIN_CONTROLLER_DESCRIPTION${RESET}"
    info_msg "Setting ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$MAIN_CONTROLLER_LABEL" \
        "$MAIN_CONTROLLER_OPTIONS"
    return 0
}


