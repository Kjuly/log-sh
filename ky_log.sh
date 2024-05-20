#!/bin/bash

__KY_LOG_LEVEL__=3

readonly KY_LOG_ARG_PREFIX="-v"
export KY_LOG_ARG_PREFIX

# https://en.wikipedia.org/wiki/Syslog#Severity_level
readonly KY_LOG_LEVELS=(
  [0]="emerg"   # System is unusable; A panic condition.
  [1]="alert"   # Action must be taken immediately; A condition that should be corrected immediately, such as a corrupted system database.
  [2]="crit"    # Critical conditions; Hard device errors.
  [3]="err"     # Error conditions.
  [4]="warn"    # Warning conditions.
  [5]="notice"  # Normal but significant conditions; Conditions that are not error conditions, but that may require special handling.
  [6]="info"    # Informational messages; Confirmation that the program is working as expected.
  [7]="debug"   # Debug-level messages; Messages that contain information normally of use only when debugging a program.
  [8]="verbose" # Verbose debug-level messages.
)

# https://en.wikipedia.org/wiki/ANSI_escape_code
# https://stackoverflow.com/a/28938235/904365
readonly KY_LOG_COLOR_OFF='\033[0m'            # No Color
readonly KY_LOG_COLOR_RED='\033[0;31m'         # Red
readonly KY_LOG_COLOR_RED_BOLD='\033[1;31m'    # Red - Bold
readonly KY_LOG_COLOR_RED_BG='\033[41m'        # Red - Background
readonly KY_LOG_COLOR_PINK='\033[1;35m'        # Pink
readonly KY_LOG_COLOR_PINK_BG='\033[45m'       # Pink - Background
readonly KY_LOG_COLOR_GREEN='\033[0;32m'       # Green
readonly KY_LOG_COLOR_GREEN_BOLD='\033[1;32m'  # Green - Bold
readonly KY_LOG_COLOR_YELLOW='\033[0;33m'      # Yellow
readonly KY_LOG_COLOR_YELLOW_BOLD='\033[1;33m' # Yellow - Bold
readonly KY_LOG_COLOR_CYAN='\033[0;36m'        # Cyan
readonly KY_LOG_COLOR_CYAN_BOLD='\033[1;36m'   # Cyan - Bold
readonly KY_LOG_COLOR_PURPLE='\033[0;34m'      # Blue
readonly KY_LOG_COLOR_PURPLE_BOLD='\033[1;34m' # Blue - Bold

# Log

ky_log_set_level() {
  local level="$1"
  if [ -z "$level" ] || [ "$level" -gt "8" ]; then
    level="8"
  elif [ "$level" -lt "0" ]; then
    level="0"
  fi
  __KY_LOG_LEVEL__="$level"
  echo "Set Log Level: $level (${KY_LOG_LEVELS[$level]})." >&2
}

ky_log_is_verbose() {
  if [ "$__KY_LOG_LEVEL__" -eq "8" ]; then
    echo "1"
  else
    echo ""
  fi
}

__ky_log() {
  local level="$1"
  local c="$2"
  shift 2
  if [ "$__KY_LOG_LEVEL__" -ge "$level" ]; then
    echo -e "[$c${KY_LOG_LEVELS[$level]}$KY_LOG_COLOR_OFF]" "$@" >&2
  fi
}

ky_log_fatal()    { __ky_log 0 "$KY_LOG_COLOR_RED_BG" "$@"; }
ky_log_alert()    { __ky_log 1 "$KY_LOG_COLOR_RED_BG" "$@"; }
ky_log_critical() { __ky_log 2 "$KY_LOG_COLOR_PINK_BG" "$@"; }
ky_log_error()    { __ky_log 3 "$KY_LOG_COLOR_RED_BOLD" "$@"; }
ky_log_warn()     { __ky_log 4 "$KY_LOG_COLOR_YELLOW_BOLD" "$@"; }
ky_log_notice()   { __ky_log 5 "$KY_LOG_COLOR_YELLOW" "$@"; }
ky_log_info()     { __ky_log 6 "$KY_LOG_COLOR_GREEN_BOLD" "$@"; }
ky_log_debug()    { __ky_log 7 "$KY_LOG_COLOR_CYAN_BOLD" "$@"; }
ky_log_verbose()  { __ky_log 8 "$KY_LOG_COLOR_PURPLE_BOLD" "$@"; }

# Func Log

__ky_func_log() {
  local level="$1"
  local c="$2"
  local func_c="$3"
  local func="$4"
  shift 4
  if [ "$__KY_LOG_LEVEL__" -ge "$level" ]; then
    echo -e "[$c${KY_LOG_LEVELS[$level]}$KY_LOG_COLOR_OFF][$func_c${func}$KY_LOG_COLOR_OFF]" "$@" >&2
  fi
}

ky_func_log_fatal()    { __ky_func_log 0 "$KY_LOG_COLOR_RED_BG" "$KY_LOG_COLOR_RED" "$@"; }
ky_func_log_alert()    { __ky_func_log 1 "$KY_LOG_COLOR_RED_BG" "$KY_LOG_COLOR_RED" "$@"; }
ky_func_log_critical() { __ky_func_log 2 "$KY_LOG_COLOR_PINK_BG" "$KY_LOG_COLOR_PINK" "$@"; }
ky_func_log_error()    { __ky_func_log 3 "$KY_LOG_COLOR_RED_BOLD" "$KY_LOG_COLOR_RED_BOLD" "$@"; }
ky_func_log_warn()     { __ky_func_log 4 "$KY_LOG_COLOR_YELLOW_BOLD" "$KY_LOG_COLOR_YELLOW" "$@"; }
ky_func_log_notice()   { __ky_func_log 5 "$KY_LOG_COLOR_YELLOW" "$KY_LOG_COLOR_YELLOW" "$@"; }
ky_func_log_info()     { __ky_func_log 6 "$KY_LOG_COLOR_GREEN_BOLD" "$KY_LOG_COLOR_GREEN" "$@"; }
ky_func_log_debug()    { __ky_func_log 7 "$KY_LOG_COLOR_CYAN_BOLD" "$KY_LOG_COLOR_CYAN" "$@"; }
ky_func_log_verbose()  { __ky_func_log 8 "$KY_LOG_COLOR_PURPLE_BOLD" "$KY_LOG_COLOR_PURPLE" "$@"; }

# Test

__test() {
  local level="$1"
  if [ -n "$level" ]; then
    ky_log_set_level "$level"
  fi

  echo
  ky_log_fatal "Test"
  ky_log_alert "Test"
  ky_log_critical "Test"
  ky_log_error "Test"
  ky_log_warn "Test"
  ky_log_notice "Test"
  ky_log_info "Test"
  ky_log_debug "Test"
  ky_log_verbose "Tets"
  ky_log_verbose "Multi-line text one\n  text two\n  text three"
  echo
  ky_func_log_fatal "${FUNCNAME[0]}" "Test"
  ky_func_log_alert "${FUNCNAME[0]}" "Test"
  ky_func_log_critical "${FUNCNAME[0]}" "Test"
  ky_func_log_error "${FUNCNAME[0]}" "Test"
  ky_func_log_warn "${FUNCNAME[0]}" "Test"
  ky_func_log_notice "${FUNCNAME[0]}" "Test"
  ky_func_log_info "${FUNCNAME[0]}" "Test"
  ky_func_log_debug "${FUNCNAME[0]}" "Test"
  ky_func_log_verbose "${FUNCNAME[0]}" "Tets"
  ky_func_log_verbose "${FUNCNAME[0]}" "Multi-line text one\n  text two\n  text three"
  echo
}

if [[ ${BASH_SOURCE[0]} = "$0" ]]; then
  __test "$@"; exit 0
fi
