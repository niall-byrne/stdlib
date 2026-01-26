#!/bin/bash

# stdlib distributable for bash

# this snippet is included by the build script:
# src/security/shell/shell.snippet
# @description Asserts that a shell command is a safe builtin.
# @arg $1 string The command to verify safety on.
# @exitcode 0 If the command is safe.
# @exitcode 1 If the command is not safe or cannot be verified.
# @stderr The error message if the assertion fails.
# @internal
stdlib.security.__shell.assert.is_safe() {
  if [[ "$(stdlib.security.__shell.query.is_safe "${1}")" != "0" ]]; then
    /bin/echo "FATAL ERROR: The 'builtin' keyword could not be verified!  Cannot safely load stdlib!" >&2
    if [[ "${1}" == "return" ]]; then
      exit 1
    fi
    return 1
  fi
  return 0
}

# @description Checks if a shell command is a safe builtin.
# @arg $1 string The command to check.
# @exitcode 0 If the operation succeeded.
# @stdout A "0" if safe, "1" otherwise.
# @internal
# shellcheck disable=SC2120
stdlib.security.__shell.query.is_safe() {
  if ! unset "${1}" 2> /dev/null ||
    declare -F "${1}" 2> /dev/null ||
    [[ "$(type -t "${1}")" != "builtin" ]]; then
    /bin/echo "1"
  else
    /bin/echo "0"
  fi
}

stdlib.security.__shell.assert.is_safe return || exit "$?"
stdlib.security.__shell.assert.is_safe declare || return "$?"
stdlib.security.__shell.assert.is_safe type || return "$?"
stdlib.security.__shell.assert.is_safe unset || return "$?"
stdlib.security.__shell.assert.is_safe builtin || return "$?"

builtin set -Eeo pipefail

# stdlib variable definitions

declare -a STDLIB_CLEANUP_FN=()
declare -- STDLIB_COLOUR_BLACK=""
declare -- STDLIB_COLOUR_BLUE=""
declare -- STDLIB_COLOUR_CYAN=""
declare -- STDLIB_COLOUR_GREEN=""
declare -- STDLIB_COLOUR_GREY=""
declare -- STDLIB_COLOUR_LIGHT_BLUE=""
declare -- STDLIB_COLOUR_LIGHT_CYAN=""
declare -- STDLIB_COLOUR_LIGHT_GREEN=""
declare -- STDLIB_COLOUR_LIGHT_PURPLE=""
declare -- STDLIB_COLOUR_LIGHT_RED=""
declare -- STDLIB_COLOUR_LIGHT_WHITE=""
declare -- STDLIB_COLOUR_LIGHT_YELLOW=""
declare -- STDLIB_COLOUR_NC=""
declare -- STDLIB_COLOUR_PURPLE=""
declare -- STDLIB_COLOUR_RED=""
declare -- STDLIB_COLOUR_WHITE=""
declare -- STDLIB_COLOUR_YELLOW=""
declare -a STDLIB_DEFERRED_FN_ARRAY=()
declare -a STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
declare -a STDLIB_HANDLER_ERR=()
declare -a STDLIB_HANDLER_EXIT=([0]="stdlib.trap.fn.clean_up_on_exit")
declare -- STDLIB_THEME_LOGGER_ERROR="LIGHT_RED"
declare -- STDLIB_THEME_LOGGER_INFO="WHITE"
declare -- STDLIB_THEME_LOGGER_NOTICE="GREY"
declare -- STDLIB_THEME_LOGGER_SUCCESS="GREEN"
declare -- STDLIB_THEME_LOGGER_WARNING="YELLOW"
declare -- STDLIB_TRACEBACK_DISABLE_BOOLEAN="1"
declare -- _STDLIB_ARGS_CALLER_FN_NAME=""
declare -a _STDLIB_ARGS_NULL_SAFE=()
declare -- _STDLIB_ARRAY_BUFFER=""
declare -- _STDLIB_BINARY_CAT="/usr/bin/cat"
declare -- _STDLIB_BINARY_CUT="/usr/bin/cut"
declare -- _STDLIB_BINARY_GREP="/usr/bin/grep"
declare -- _STDLIB_BINARY_HEAD="/usr/bin/head"
declare -- _STDLIB_BINARY_MKTEMP="/usr/bin/mktemp"
declare -- _STDLIB_BINARY_RM="/usr/bin/rm"
declare -- _STDLIB_BINARY_SED="/usr/bin/sed"
declare -- _STDLIB_BINARY_SORT="/usr/bin/sort"
declare -- _STDLIB_BINARY_TAIL="/usr/bin/tail"
declare -- _STDLIB_BINARY_TPUT="/usr/bin/tput"
declare -- _STDLIB_BINARY_TR="/usr/bin/tr"
declare -- _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=""
declare -- _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN=""
declare -- _STDLIB_DELIMITER=""
declare -- _STDLIB_LINE_BREAK_CHAR=""
declare -a _STDLIB_LOGGING_DECORATORS=([0]="_testing.__protected")
declare -- _STDLIB_LOGGING_MESSAGE_PREFIX=""
declare -- _STDLIB_PASSWORD_BOOLEAN=""
declare -- _STDLIB_WRAP_PREFIX_STRING=""

# stdlib function definitions

stdlib.__builtin.overridable ()
{
    builtin local use_builtin_boolean="${_STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN:-0}";
    if [[ "${use_builtin_boolean}" == "0" ]]; then
        builtin "${@}";
    else
        "${@}";
    fi
}

stdlib.__gettext ()
{
    stdlib.__gettext.call "stdlib" "${1}"
}

stdlib.__gettext.call ()
{
    builtin local original_text_domain="${TEXTDOMAIN}";
    builtin local original_text_domain_dir="${TEXTDOMAINDIR}";
    TEXTDOMAIN="${1}";
    TEXTDOMAINDIR="${STDLIB_TEXTDOMAINDIR}";
    eval_gettext "${2}";
    TEXTDOMAIN="${original_text_domain}";
    TEXTDOMAINDIR="${original_text_domain_dir}"
}

stdlib.__gettext.fallback ()
{
    builtin unset -f stdlib.__gettext.call;
    fallback_function_definition="$("${_STDLIB_BINARY_CAT}" <<EOF

  stdlib.__gettext.call() {
    # $1: the translation base to use
    # $2: the message key to translate

    builtin local cleaned_text="\${2}"

    cleaned_text="\${2//"'"/"\\'"}"
    cleaned_text="\${cleaned_text//'\`'/'\\\`'}"
    cleaned_text="\${cleaned_text//"("/"\\("}"
    cleaned_text="\${cleaned_text//")"/"\\)"}"

    builtin eval builtin echo "\${cleaned_text}"
  }
EOF
)";
    builtin eval "${fallback_function_definition}"
}

stdlib.__message.get ()
{
    builtin local key="${1}";
    builtin local message;
    {
        builtin local option1="${2}";
        builtin local option2="${3}";
        builtin local option3="${4}"
    };
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        ARGUMENT_REQUIREMENTS_VIOLATION)
            required_options=2;
            message="$(stdlib.__gettext "Expected '\${option1}' required argument(s) and '\${option2}' optional argument(s).")"
        ;;
        ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL)
            required_options=1;
            message="$(stdlib.__gettext "Received '\${option1}' argument(s)!")"
        ;;
        ARGUMENT_REQUIREMENTS_VIOLATION_NULL)
            required_options=1;
            message="$(stdlib.__gettext "Argument '\${option1}' was null and is not null safe!")"
        ;;
        ARGUMENTS_INVALID)
            required_options=0;
            message="$(stdlib.__gettext "Invalid arguments provided!")"
        ;;
        ARRAY_ARE_EQUAL)
            required_options=2;
            message="$(stdlib.__gettext "The arrays '\${option1}' and '\${option2}' are equal!")"
        ;;
        ARRAY_ELEMENT_MISMATCH)
            required_options=3;
            message="$(stdlib.__gettext "At index '\${option2}': the array '\${option1}' has element '\${option3}'")"
        ;;
        ARRAY_IS_EMPTY)
            required_options=1;
            message="$(stdlib.__gettext "The array '\${option1}' is empty!")"
        ;;
        ARRAY_IS_NOT_EMPTY)
            required_options=1;
            message="$(stdlib.__gettext "The array '\${option1}' is not empty!")"
        ;;
        ARRAY_LENGTH_MISMATCH)
            required_options=2;
            message="$(stdlib.__gettext "The array '\${option1}' has length '\${option2}'")"
        ;;
        ARRAY_VALUE_FOUND)
            required_options=2;
            message="$(stdlib.__gettext "The value '\${option1}' is found in the '\${option2}' array!")"
        ;;
        ARRAY_VALUE_NOT_FOUND)
            required_options=2;
            message="$(stdlib.__gettext "The value '\${option1}' is not found in the '\${option2}' array!")"
        ;;
        COLOUR_INITIALIZE_ERROR)
            required_options=0;
            message="$(stdlib.__gettext "Terminal colours could not be initialized!")"
        ;;
        COLOUR_INITIALIZE_ERROR_TERM)
            required_options=0;
            message="$(stdlib.__gettext "Consider checking the 'TERM' environment variable.")"
        ;;
        COLOUR_NOT_DEFINED)
            required_options=1;
            message="$(stdlib.__gettext "The colour '\${option1}' is not defined!")"
        ;;
        FN_NAME_INVALID)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a valid function name!")"
        ;;
        FS_PATH_DOES_NOT_EXIST)
            required_options=1;
            message="$(stdlib.__gettext "The path '\${option1}' does not exist on the filesystem!")"
        ;;
        FS_PATH_EXISTS)
            required_options=1;
            message="$(stdlib.__gettext "The path '\${option1}' exists on the filesystem!")"
        ;;
        FS_PATH_IS_NOT_A_FILE)
            required_options=1;
            message="$(stdlib.__gettext "The path '\${option1}' is not a valid filesystem file!")"
        ;;
        FS_PATH_IS_NOT_A_FOLDER)
            required_options=1;
            message="$(stdlib.__gettext "The path '\${option1}' is not a valid filesystem folder!")"
        ;;
        IS_ARRAY)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is an array!")"
        ;;
        IS_BUILTIN)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is a shell builtin!")"
        ;;
        IS_EQUAL)
            required_options=1;
            message="$(stdlib.__gettext "A value equal to '\${option1}' cannot be used!")"
        ;;
        IS_FN)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is a function!")"
        ;;
        IS_NOT_ALPHABETIC)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a alphabetic only string!")"
        ;;
        IS_NOT_ALPHA_NUMERIC)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a alpha-numeric only string!")"
        ;;
        IS_NOT_ARRAY)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not an array!")"
        ;;
        IS_NOT_BOOLEAN)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a string containing a boolean (0 or 1)!")"
        ;;
        IS_NOT_BUILTIN)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a shell builtin!")"
        ;;
        IS_NOT_CHAR)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a string containing a single char!")"
        ;;
        IS_NOT_DIGIT)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a string containing a digit!")"
        ;;
        IS_NOT_FN)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a function!")"
        ;;
        IS_NOT_INTEGER)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a string containing an integer!")"
        ;;
        IS_NOT_INTEGER_IN_RANGE)
            required_options=3;
            message="$(stdlib.__gettext "The value '\${option3}' is not a string containing an integer in the inclusive range \${option1} to \${option2}!")"
        ;;
        IS_NOT_OCTAL_PERMISSION)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a string containing an octal file permission!")"
        ;;
        IS_NOT_SET_STRING)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a set string!")"
        ;;
        REGEX_DOES_NOT_MATCH)
            required_options=2;
            message="$(stdlib.__gettext "The regex '\${option1}' does not match the value '\${option2}'!")"
        ;;
        SECURITY_INSECURE_GROUP_OWNERSHIP)
            required_options=1;
            message="$(stdlib.__gettext "SECURITY: The group ownership on '\${option1}' is not secure!")"
        ;;
        SECURITY_INSECURE_OWNERSHIP)
            required_options=1;
            message="$(stdlib.__gettext "SECURITY: The ownership on '\${option1}' is not secure!")"
        ;;
        SECURITY_INSECURE_PERMISSIONS)
            required_options=1;
            message="$(stdlib.__gettext "SECURITY: The permissions on '\${option1}' are not secure!")"
        ;;
        SECURITY_MUST_BE_RUN_AS_ROOT)
            required_options=0;
            message="$(stdlib.__gettext "SECURITY: This script must be run as root.")"
        ;;
        SECURITY_SUGGEST_CHGRP)
            required_options=2;
            message="$(stdlib.__gettext "Please consider running: sudo chgrp '\${option1}' '\${option2}'")"
        ;;
        SECURITY_SUGGEST_CHMOD)
            required_options=2;
            message="$(stdlib.__gettext "Please consider running: sudo chmod '\${option1}' '\${option2}'")"
        ;;
        SECURITY_SUGGEST_CHOWN)
            required_options=2;
            message="$(stdlib.__gettext "Please consider running: sudo chown '\${option1}' '\${option2}'")"
        ;;
        STDIN_DEFAULT_CONFIRMATION_PROMPT)
            required_options=0;
            message="$(stdlib.__gettext "Are you sure you wish to proceed (Y/n) ?") "
        ;;
        STDIN_DEFAULT_PAUSE_PROMPT)
            required_options=0;
            message="$(stdlib.__gettext "Press any key to continue ...") "
        ;;
        STDIN_DEFAULT_VALUE_PROMPT)
            required_options=0;
            message="$(stdlib.__gettext "Enter a value:") "
        ;;
        TRACEBACK_HEADER)
            required_options=0;
            message="$(stdlib.__gettext "Callstack:")"
        ;;
        VAR_NAME_INVALID)
            required_options=1;
            message="$(stdlib.__gettext "The value '\${option1}' is not a valid variable name!")"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="$(stdlib.__gettext "Unknown message key '${key}'")"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    ((return_status == 0)) || {
        stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

stdlib.array.assert.is_array ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_array "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_ARRAY "${1}")"
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.is_contains ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_contains "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARRAY_VALUE_NOT_FOUND "${1}" "${2}")"
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.is_empty ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_empty "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        0)

        ;;
        1)
            stdlib.logger.error "$(stdlib.__message.get ARRAY_IS_NOT_EMPTY "${1}")"
        ;;
        126)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_ARRAY "${1}")"
        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.is_equal ()
{
    builtin local _stdlib_array_index;
    builtin local _stdlib_array_name_1="${1}";
    builtin local _stdlib_array_name_2="${2}";
    builtin local -a _stdlib_comparison_errors_array;
    builtin local -a _stdlib_indirect_array_1;
    builtin local -a _stdlib_indirect_array_2;
    builtin local _stdlib_indirect_reference_1;
    builtin local _stdlib_indirect_reference_2;
    [[ "${#@}" == "2" ]] || {
        stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    stdlib.array.assert.is_array "${1}" || builtin return 126;
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    _stdlib_indirect_reference_1="${_stdlib_array_name_1}[@]";
    _stdlib_indirect_array_1=("${!_stdlib_indirect_reference_1}");
    _stdlib_indirect_reference_2="${_stdlib_array_name_2}[@]";
    _stdlib_indirect_array_2=("${!_stdlib_indirect_reference_2}");
    if [[ "${#_stdlib_indirect_array_1[@]}" != "${#_stdlib_indirect_array_2[@]}" ]]; then
        _stdlib_comparison_errors_array+=("$(stdlib.__message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_1}" "${#_stdlib_indirect_array_1[@]}")");
        _stdlib_comparison_errors_array+=("$(stdlib.__message.get ARRAY_LENGTH_MISMATCH "${_stdlib_array_name_2}" "${#_stdlib_indirect_array_2[@]}")");
    fi;
    for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_indirect_array_1[@]}"; _stdlib_array_index++))
    do
        if ((_stdlib_array_index == "${#_stdlib_indirect_array_2[@]}")); then
            builtin break;
        fi;
        if [[ "${_stdlib_indirect_array_1[_stdlib_array_index]}" != "${_stdlib_indirect_array_2[_stdlib_array_index]}" ]]; then
            _stdlib_comparison_errors_array+=("$(stdlib.__message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_1}" "${_stdlib_array_index}" "${_stdlib_indirect_array_1[_stdlib_array_index]}")");
            _stdlib_comparison_errors_array+=("$(stdlib.__message.get ARRAY_ELEMENT_MISMATCH "${_stdlib_array_name_2}" "${_stdlib_array_index}" "${_stdlib_indirect_array_2[_stdlib_array_index]}")");
        fi;
    done;
    if [[ "${#_stdlib_comparison_errors_array[@]}" -gt "0" ]]; then
        for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_comparison_errors_array[@]}"; _stdlib_array_index++))
        do
            stdlib.logger.error "${_stdlib_comparison_errors_array[_stdlib_array_index]}";
        done;
        builtin return 1;
    fi;
    builtin return 0
}

stdlib.array.assert.not_array ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_array "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        0)
            stdlib.logger.error "$(stdlib.__message.get IS_ARRAY "${1}")";
            builtin return 1
        ;;
        1)
            builtin return 0
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.not_contains ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_contains "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        1)
            builtin return 0
        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARRAY_VALUE_FOUND "${1}" "${2}")";
            builtin return 1
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.not_empty ()
{
    builtin local _stdlib_return_code=0;
    stdlib.array.query.is_empty "${@}" || _stdlib_return_code="$?";
    case "${_stdlib_return_code}" in
        0)
            stdlib.logger.error "$(stdlib.__message.get ARRAY_IS_EMPTY "${1}")";
            builtin return 1
        ;;
        1)
            builtin return 0
        ;;
        126)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_ARRAY "${1}")"
        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${_stdlib_return_code}"
}

stdlib.array.assert.not_equal ()
{
    builtin local _stdlib_array_index;
    builtin local _stdlib_array_name_1="${1}";
    builtin local _stdlib_array_name_2="${2}";
    builtin local -a _stdlib_indirect_array_1;
    builtin local -a _stdlib_indirect_array_2;
    builtin local _stdlib_indirect_reference_1;
    builtin local _stdlib_indirect_reference_2;
    [[ "${#@}" == "2" ]] || {
        stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    stdlib.array.assert.is_array "${1}" || builtin return 126;
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    _stdlib_indirect_reference_1="${_stdlib_array_name_1}[@]";
    _stdlib_indirect_array_1=("${!_stdlib_indirect_reference_1}");
    _stdlib_indirect_reference_2="${_stdlib_array_name_2}[@]";
    _stdlib_indirect_array_2=("${!_stdlib_indirect_reference_2}");
    if [[ "${#_stdlib_indirect_array_1[@]}" != "${#_stdlib_indirect_array_2[@]}" ]]; then
        builtin return 0;
    fi;
    for ((_stdlib_array_index = 0; _stdlib_array_index < "${#_stdlib_indirect_array_1[@]}"; _stdlib_array_index++))
    do
        if [[ "${_stdlib_indirect_array_1[_stdlib_array_index]}" != "${_stdlib_indirect_array_2[_stdlib_array_index]}" ]]; then
            builtin return 0;
        fi;
    done;
    stdlib.logger.error "$(stdlib.__message.get ARRAY_ARE_EQUAL "${_stdlib_array_name_1}" "${_stdlib_array_name_2}")";
    builtin return 1
}

stdlib.array.get.last ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    builtin local indirect_array_last_element_index;
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.not_empty "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    indirect_array_last_element_index="$(("${#indirect_array[@]}" - 1))";
    _STDLIB_ARRAY_BUFFER="${indirect_array[indirect_array_last_element_index]}";
    builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.length ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    builtin local indirect_array_last_element_index;
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    _STDLIB_ARRAY_BUFFER="${#indirect_array[@]}";
    builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.longest ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    builtin local indirect_array_last_element_index;
    builtin local current_array_element;
    builtin local longest_array_element_length=-1;
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.not_empty "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    for current_array_element in "${indirect_array[@]}";
    do
        if [[ "${#current_array_element}" -gt "${longest_array_element_length}" ]]; then
            longest_array_element_length="${#current_array_element}";
        fi;
    done;
    _STDLIB_ARRAY_BUFFER="${longest_array_element_length}";
    builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.get.shortest ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    builtin local indirect_array_last_element_index;
    builtin local current_array_element;
    builtin local shortest_array_element_length=-1;
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.not_empty "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    for current_array_element in "${indirect_array[@]}";
    do
        if [[ "${#current_array_element}" -lt "${shortest_array_element_length}" ]] || [[ "${shortest_array_element_length}" == "-1" ]]; then
            shortest_array_element_length="${#current_array_element}";
        fi;
    done;
    _STDLIB_ARRAY_BUFFER="${shortest_array_element_length}";
    builtin echo "${_STDLIB_ARRAY_BUFFER}"
}

stdlib.array.make.from_file ()
{
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    stdlib.io.path.assert.is_file "${3}" || builtin return 126;
    IFS="${2}" builtin read -ra "${1}" < "${3}"
}

stdlib.array.make.from_string ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("3");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    IFS="${2}" builtin read -d "" -ra "${1}" < <(builtin echo -n "${3}") || builtin return 0
}

stdlib.array.make.from_string_n ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local array_index;
    _STDLIB_ARGS_NULL_SAFE=("3");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    stdlib.string.assert.is_digit "${2}" || builtin return 126;
    for ((array_index = 0; array_index < "${2}"; array_index++))
    do
        builtin printf -v "${1}[${array_index}]" "%s" "${3}";
    done
}

stdlib.array.map.fn ()
{
    builtin local element;
    builtin local indirect_reference;
    builtin local -a indirect_array;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for element in "${indirect_array[@]}";
    do
        "${1}" "${element}";
    done
}

stdlib.array.map.format ()
{
    builtin local element;
    builtin local indirect_reference;
    builtin local -a indirect_array;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for element in "${indirect_array[@]}";
    do
        builtin printf "${1}" "${element}";
    done
}

stdlib.array.mutate.append ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local -a indirect_array;
    builtin local indirect_array_index;
    builtin local indirect_reference;
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++))
    do
        indirect_array[indirect_array_index]="${indirect_array[indirect_array_index]}${1}";
    done;
    if [[ "${#indirect_array[@]}" == 0 ]]; then
        builtin eval "${2}=()";
    else
        builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))";
    fi
}

stdlib.array.mutate.filter ()
{
    builtin local array_element;
    builtin local -a new_array;
    builtin local -a indirect_array;
    builtin local indirect_reference;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for array_element in "${indirect_array[@]}";
    do
        if "${1}" "${array_element}"; then
            new_array+=("${array_element}");
        fi;
    done;
    if [[ "${#new_array[@]}" == 0 ]]; then
        builtin eval "${2}=()";
    else
        builtin eval "${2}=($(builtin printf '%q ' "${new_array[@]}"))";
    fi
}

stdlib.array.mutate.fn ()
{
    builtin local -a indirect_array;
    builtin local indirect_array_index=0;
    builtin local indirect_reference;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++))
    do
        indirect_array[indirect_array_index]="$("${1}" "${indirect_array[indirect_array_index]}")";
    done;
    if [[ "${#indirect_array[@]}" == 0 ]]; then
        builtin eval "${2}=()";
    else
        builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))";
    fi
}

stdlib.array.mutate.format ()
{
    builtin local -a indirect_array;
    builtin local indirect_array_index=0;
    builtin local indirect_reference;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++))
    do
        indirect_array[indirect_array_index]="$(builtin printf "${1}" "${indirect_array[indirect_array_index]}")";
    done;
    if [[ "${#indirect_array[@]}" == 0 ]]; then
        builtin eval "${2}=()";
    else
        builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))";
    fi
}

stdlib.array.mutate.insert ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local -a indirect_array;
    builtin local indirect_reference;
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${3}" || builtin return 126;
    indirect_reference="${3}[@]";
    indirect_array=("${!indirect_reference}");
    stdlib.string.assert.is_integer_with_range "0" "${#indirect_array[@]}" "${2}" || builtin return 126;
    indirect_array=("${indirect_array[@]:"0":"${2}"}" "${1}" "${indirect_array[@]:"${2}"}");
    builtin eval "${3}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

stdlib.array.mutate.prepend ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local -a indirect_array;
    builtin local indirect_array_index;
    builtin local indirect_reference;
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for ((indirect_array_index = 0; indirect_array_index < "${#indirect_array[@]}"; indirect_array_index++))
    do
        indirect_array[indirect_array_index]="${1}${indirect_array[indirect_array_index]}";
    done;
    if [[ "${#indirect_array[@]}" == 0 ]]; then
        builtin eval "${2}=()";
    else
        builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))";
    fi
}

stdlib.array.mutate.remove ()
{
    builtin local -a indirect_array;
    builtin local indirect_reference;
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    stdlib.array.assert.not_empty "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    stdlib.string.assert.is_integer_with_range "0" "$(("${#indirect_array[@]}" - 1))" "${1}" || builtin return 126;
    builtin unset 'indirect_array["${1}"]';
    builtin eval "${2}=($(builtin printf '%q ' "${indirect_array[@]}"))"
}

stdlib.array.mutate.reverse ()
{
    builtin local element;
    builtin local -a indirect_array;
    builtin local indirect_array_index_1;
    builtin local indirect_array_index_2;
    builtin local indirect_reference;
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    for ((indirect_array_index_1 = 0, indirect_array_index_2 = "${#indirect_array[@]}" - 1; indirect_array_index_1 < indirect_array_index_2; indirect_array_index_1++, indirect_array_index_2--))
    do
        element="${indirect_array[indirect_array_index_1]}";
        indirect_array[indirect_array_index_1]="${indirect_array[indirect_array_index_2]}";
        indirect_array[indirect_array_index_2]="${element}";
    done;
    if [[ "${#indirect_array[@]}" == 0 ]]; then
        builtin eval "${1}=()";
    else
        builtin eval "${1}=($(builtin printf '%q ' "${indirect_array[@]}"))";
    fi
}

stdlib.array.query.is_array ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    if builtin declare -p "${1}" 2> /dev/null | "${_STDLIB_BINARY_GREP}" -q 'declare -a'; then
        builtin return 0;
    fi;
    builtin return 1
}

stdlib.array.query.is_contains ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    builtin local check_value;
    builtin local query_value="${1}";
    [[ "${#@}" == "2" ]] || builtin return 127;
    stdlib.array.query.is_array "${2}" || builtin return 126;
    indirect_reference="${2}[@]";
    indirect_array=("${!indirect_reference}");
    for check_value in "${indirect_array[@]}";
    do
        if [[ ${check_value} == "${query_value}" ]]; then
            builtin return 0;
        fi;
    done;
    builtin return 1
}

stdlib.array.query.is_empty ()
{
    builtin local indirect_reference;
    builtin local -a indirect_array;
    [[ "${#@}" == "1" ]] || builtin return 127;
    stdlib.array.query.is_array "${1}" || builtin return 126;
    indirect_reference="${1}[@]";
    indirect_array=("${!indirect_reference}");
    if [[ "${#indirect_array[@]}" == "0" ]]; then
        builtin return 0;
    fi;
    builtin return 1
}

stdlib.array.query.is_equal ()
{
    builtin local indirect_reference_1;
    builtin local -a indirect_array_1;
    builtin local indirect_reference_2;
    builtin local -a indirect_array_2;
    [[ "${#@}" == "2" ]] || builtin return 127;
    stdlib.array.query.is_array "${1}" || builtin return 126;
    stdlib.array.query.is_array "${2}" || builtin return 126;
    builtin local array_name_1="${1}";
    builtin local array_name_2="${2}";
    builtin local array_index;
    indirect_reference_1="${array_name_1}[@]";
    indirect_array_1=("${!indirect_reference_1}");
    indirect_reference_2="${array_name_2}[@]";
    indirect_array_2=("${!indirect_reference_2}");
    builtin test "${#indirect_array_1[*]}" == "${#indirect_array_2[*]}" || builtin return 1;
    for ((array_index = 0; array_index < "${#indirect_array_1[*]}"; array_index++))
    do
        builtin test "${indirect_array_1[array_index]}" == "${indirect_array_2[array_index]}" || builtin return 1;
    done;
    builtin return 0
}

stdlib.deferred.__defer ()
{
    builtin local func="${1}";
    builtin local deferred_function_call="stdlib.__deferred.call.${#STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[*]}";
    builtin shift;
    builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF
${deferred_function_call}() {
  "${func}" ${@}
}
EOF
)";
    STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY+=("${deferred_function_call}")
}

stdlib.deferred.__execute ()
{
    builtin local func;
    for func in "${STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY[@]}";
    do
        "${func}";
        builtin unset -f "${func}";
    done;
    STDLIB_DEFERRED_FN_ARRAY=();
    STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
}

stdlib.deferred.__initialize ()
{
    builtin local func;
    for func in "${STDLIB_DEFERRED_FN_ARRAY[@]}";
    do
        builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF
${func}() {
  stdlib.deferred.__defer "${func}" "\${@}"
}
EOF
)";
    done
}

stdlib.fn.args.require ()
{
    builtin local -a args_null_safe_array;
    builtin local _STDLIB_LOGGING_MESSAGE_PREFIX="${_STDLIB_ARGS_CALLER_FN_NAME:-"${FUNCNAME[1]}"}";
    args_null_safe_array=("${_STDLIB_ARGS_NULL_SAFE[@]}");
    builtin local arg_index=1;
    builtin local args_optional_count="${2}";
    builtin local args_required_count="${1}";
    stdlib.string.assert.is_digit "${args_required_count}" || builtin return 126;
    stdlib.string.assert.is_digit "${args_optional_count}" || builtin return 126;
    stdlib.array.assert.is_array args_null_safe_array || builtin return 126;
    builtin shift 2;
    if (("${#@}" < "${args_required_count}" || "${#@}" > "${args_required_count}" + "${args_optional_count}")); then
        stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")";
        stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL "${#@}")";
        builtin return 127;
    fi;
    for ((arg_index = 1; arg_index <= "${#@}"; arg_index++))
    do
        if [[ -z "${!arg_index}" ]]; then
            if ! stdlib.array.query.is_contains "${arg_index}" args_null_safe_array; then
                stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION "${args_required_count}" "${args_optional_count}")";
                stdlib.logger.error "$(stdlib.__message.get ARGUMENT_REQUIREMENTS_VIOLATION_NULL "${arg_index}")";
                builtin return 126;
            fi;
        fi;
    done
}

stdlib.fn.assert.is_builtin ()
{
    builtin local return_code=0;
    stdlib.fn.query.is_builtin "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_BUILTIN "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.fn.assert.is_fn ()
{
    builtin local return_code=0;
    stdlib.fn.query.is_fn "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_FN "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.fn.assert.is_valid_name ()
{
    builtin local return_code=0;
    stdlib.fn.query.is_valid_name "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get FN_NAME_INVALID "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.fn.assert.not_builtin ()
{
    builtin local return_code=0;
    stdlib.fn.query.is_builtin "${@}" || return_code="$?";
    case "${return_code}" in
        0)
            stdlib.logger.error "$(stdlib.__message.get IS_BUILTIN "${1}")";
            builtin return 1
        ;;
        1)
            builtin return 0
        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.fn.assert.not_fn ()
{
    builtin local return_code=0;
    stdlib.fn.query.is_fn "${@}" || return_code="$?";
    case "${return_code}" in
        0)
            stdlib.logger.error "$(stdlib.__message.get IS_FN "${1}")";
            builtin return 1
        ;;
        1)
            builtin return 0
        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.fn.derive.clone ()
{
    builtin local function_name="${1}";
    builtin local function_reference="${2}";
    [[ "${#@}" == 2 ]] || builtin return 127;
    stdlib.fn.assert.is_fn "${function_name}" || builtin return 126;
    [[ -n "${function_reference}" ]] || builtin return 126;
    stdlib.fn.assert.is_valid_name "${function_reference}" || builtin return 126;
    builtin eval "$(builtin echo "${function_reference}()"
builtin declare -f "${function_name}" | "${_STDLIB_BINARY_TAIL}" -n +2)"
}

stdlib.fn.derive.pipeable ()
{
    builtin local derive_target_fn_name;
    builtin local stdin_source_specifier="${STDIN_SOURCE_SPECIFIER:-"-"}";
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    stdlib.string.assert.is_digit "${2}" || builtin return 126;
    derive_target_fn_name="${1}";
    builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF

${derive_target_fn_name}_pipe() {
  # \${@ 0:-2} the args to use
  # \${@ -1} the optional input string to operate on
  # NOTE: the position of stdin can also be specified with the arg "-"

  # mutate_pipe_parser_strategy
  #   ARGS_SPECIFIED:   the already specified arguments are sufficient to call the function
  #   STDIN_POSITIONAL: the user specified that an argument is explicitly from stdin
  #   STDIN_ASSUMED:    there are not enough arguments and no known position for stdin, append stdin

  builtin local mutate_examined_arg=""
  builtin local mutate_examined_arg_index=0
  builtin local mutate_pipe_input=""
  builtin local mutate_pipe_input_index=0
  builtin local mutate_pipe_input_line=''
  builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED"
  builtin local -a mutate_received_args

  mutate_received_args=("\$@")

  # Append stdin strategy
  if [[ "\${#@}" -lt "${2}" ]]; then
    mutate_pipe_parser_strategy="STDIN_ASSUMED"
    mutate_pipe_input_index="\$(("\${#@}" + 1))"
  fi

  # Replace placeholder stdin strategy
  if [[ "\${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
    for mutate_examined_arg in "\${@}"; do
      if [[ "\${mutate_examined_arg}" == "${stdin_source_specifier}" ]]; then
        mutate_pipe_parser_strategy="STDIN_POSITIONAL"
        mutate_pipe_input_index="\${mutate_examined_arg_index}"
        builtin break
      fi
      ((mutate_examined_arg_index+=1))
    done
  fi

  # Does the current strategy require stdin ?
  if [[ "\${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
    while IFS= builtin read -r mutate_pipe_input_line; do
      mutate_pipe_input+="\${mutate_pipe_input_line}"
      mutate_pipe_input+=$'\n'
    done
    mutate_pipe_input="\${mutate_pipe_input%?}"
    mutate_received_args[mutate_pipe_input_index]="\${mutate_pipe_input}"
  fi

  "${derive_target_fn_name}" "\${mutate_received_args[@]}"
}
EOF
)"
}

stdlib.fn.derive.var ()
{
    builtin local -a args_with_defaults;
    builtin local derive_source_fn_name="${1}";
    builtin local derive_target_fn_name;
    builtin local derive_argument_index="${3:-"-1"}";
    args_with_defaults=("$@");
    derive_target_fn_name="${2:-"${derive_source_fn_name}_var"}";
    args_with_defaults[1]="${derive_target_fn_name}";
    args_with_defaults[2]="${derive_argument_index}";
    stdlib.fn.args.require "3" "0" "${args_with_defaults[@]}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    stdlib.fn.assert.is_valid_name "${derive_target_fn_name}" || builtin return 126;
    stdlib.string.assert.is_integer "${derive_argument_index}" || builtin return 126;
    stdlib.string.assert.not_equal "0" "${derive_argument_index}" || builtin return 126;
    builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF

${derive_target_fn_name}() {
  # \${@} the args to pass to the source function, plus the variable name

  builtin local fn_argument_index
  builtin local fn_argument_index_variable_name="${derive_argument_index}"
  builtin local -a fn_arguments
  builtin local fn_variable_name=""

  stdlib.fn.args.require "1" "1000" "\${@}" || builtin return "\$?"

  if [[ "${derive_argument_index}" -lt "0" ]]; then
    fn_argument_index_variable_name="\$(("\${#@}" + 1 + "${derive_argument_index}"))"
  fi

  for ((fn_argument_index=1; fn_argument_index <= "\${#@}"; fn_argument_index+=1)); do
    if (("\${fn_argument_index}" == "\${fn_argument_index_variable_name}")); then
      fn_variable_name="\${!fn_argument_index}"
      fn_arguments+=("\${!fn_variable_name}")
    else
      fn_arguments+=("\${!fn_argument_index}")
    fi
  done

  builtin printf -v "\${fn_variable_name}" "%s" "\$("${derive_source_fn_name}" "\${fn_arguments[@]}")"
}

EOF
)"
}

stdlib.fn.query.is_builtin ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    if [[ "$(builtin type -t "${1}")" != "builtin" ]]; then
        builtin return 1;
    fi;
    builtin return 0
}

stdlib.fn.query.is_fn ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    if ! builtin declare -F "${1}" > /dev/null; then
        builtin return 1;
    fi;
    builtin return 0
}

stdlib.fn.query.is_valid_name ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    case "${1}" in
        *[!A-Za-z0-9_.@\-]*)
            builtin return 1
        ;;
        *)
            builtin return 0
        ;;
    esac
}

stdlib.io.path.assert.is_exists ()
{
    builtin local return_code=0;
    stdlib.io.path.query.is_exists "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get FS_PATH_DOES_NOT_EXIST "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.io.path.assert.is_file ()
{
    builtin local return_code=0;
    stdlib.io.path.query.is_file "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get FS_PATH_IS_NOT_A_FILE "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.io.path.assert.is_folder ()
{
    builtin local return_code=0;
    stdlib.io.path.query.is_folder "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get FS_PATH_IS_NOT_A_FOLDER "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.io.path.assert.not_exists ()
{
    builtin local return_code=0;
    stdlib.io.path.query.is_exists "${@}" || return_code="$?";
    case "${return_code}" in
        0)
            stdlib.logger.error "$(stdlib.__message.get FS_PATH_EXISTS "${1}")";
            builtin return 1
        ;;
        1)
            builtin return 0
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.io.path.query.is_exists ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    stdlib.__builtin.overridable test -e "${1}" || builtin return 1
}

stdlib.io.path.query.is_file ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    stdlib.__builtin.overridable test -f "${1}" || builtin return 1
}

stdlib.io.path.query.is_folder ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    stdlib.__builtin.overridable test -d "${1}" || builtin return 1
}

stdlib.io.stdin.confirmation ()
{
    builtin local input_char;
    builtin local prompt="${1:-"$(stdlib.__message.get STDIN_DEFAULT_CONFIRMATION_PROMPT)"}";
    stdlib.fn.args.require "0" "1" "${@}" || builtin return "$?";
    builtin echo -en "${prompt}";
    while builtin true; do
        builtin read -rs -n 1 input_char;
        if [[ "${input_char}" == "n" ]]; then
            builtin echo;
            builtin return 1;
        fi;
        if [[ "${input_char}" == "Y" ]]; then
            builtin echo;
            builtin return 0;
        fi;
    done
}

stdlib.io.stdin.pause ()
{
    builtin local input_char;
    builtin local prompt="${1:-"$(stdlib.__message.get STDIN_DEFAULT_PAUSE_PROMPT)"}";
    stdlib.fn.args.require "0" "1" "${@}" || builtin return "$?";
    builtin echo -en "${prompt}";
    builtin read -rs -n 1 input_char
}

stdlib.io.stdin.prompt ()
{
    builtin local flags="-rp";
    builtin local prompt="${2:-"$(stdlib.__message.get STDIN_DEFAULT_VALUE_PROMPT)"}";
    builtin local password="${_STDLIB_PASSWORD_BOOLEAN:-0}";
    stdlib.fn.args.require "1" "1" "${@}" || builtin return "$?";
    if [[ "${password}" == "1" ]]; then
        flags="-rsp";
    fi;
    while [[ -z "${!1}" ]]; do
        stdlib.__builtin.overridable read "${flags}" "${prompt}" "${1}";
        if [[ "${password}" == "1" ]]; then
            stdlib.__builtin.overridable echo;
        fi;
    done
}

stdlib.logger.__message_prefix ()
{
    builtin local message_prefix="${_STDLIB_LOGGING_MESSAGE_PREFIX:-${FUNCNAME[3]}}";
    if stdlib.array.query.is_contains "${message_prefix}" _STDLIB_LOGGING_DECORATORS; then
        message_prefix="${FUNCNAME[4]}";
    fi;
    builtin echo -n "${message_prefix}: "
}

stdlib.logger.error ()
{
    {
        stdlib.logger.__message_prefix;
        stdlib.string.colour "${STDLIB_THEME_LOGGER_ERROR}" "${1}"
    } 1>&2
}

stdlib.logger.error_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.logger.error" "${mutate_received_args[@]}"
}

stdlib.logger.info ()
{
    stdlib.logger.__message_prefix;
    stdlib.string.colour "${STDLIB_THEME_LOGGER_INFO}" "${1}"
}

stdlib.logger.info_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.logger.info" "${mutate_received_args[@]}"
}

stdlib.logger.notice ()
{
    stdlib.logger.__message_prefix;
    stdlib.string.colour "${STDLIB_THEME_LOGGER_NOTICE}" "${1}"
}

stdlib.logger.notice_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.logger.notice" "${mutate_received_args[@]}"
}

stdlib.logger.success ()
{
    stdlib.logger.__message_prefix;
    stdlib.string.colour "${STDLIB_THEME_LOGGER_SUCCESS}" "${1}"
}

stdlib.logger.success_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.logger.success" "${mutate_received_args[@]}"
}

stdlib.logger.traceback ()
{
    builtin local fn_name_index;
    builtin local fn_name_indent=">";
    stdlib.__message.get TRACEBACK_HEADER;
    builtin echo;
    for ((fn_name_index = ("${#FUNCNAME[@]}" - 1); fn_name_index > 1; fn_name_index--))
    do
        builtin echo "${fn_name_indent}  ${BASH_SOURCE["${fn_name_index}"]}:${BASH_LINENO[$(("${fn_name_index}" - 1))]}:${FUNCNAME["${fn_name_index}"]}()";
        fn_name_indent+=">";
    done
}

stdlib.logger.warning ()
{
    {
        stdlib.logger.__message_prefix;
        stdlib.string.colour "${STDLIB_THEME_LOGGER_WARNING}" "${1}"
    } 1>&2
}

stdlib.logger.warning_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.logger.warning" "${mutate_received_args[@]}"
}

stdlib.security.__shell.query.is_safe ()
{
    if ! unset "${1}" 2> /dev/null || declare -F "${1}" 2> /dev/null || [[ "$(type -t "${1}")" != "builtin" ]]; then
        /bin/echo "1";
    else
        /bin/echo "0";
    fi
}

stdlib.security.get.euid ()
{
    [[ "${#@}" == "0" ]] || builtin return 127;
    builtin echo "${EUID}"
}

stdlib.security.get.gid ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    getent group "${1}" | "${_STDLIB_BINARY_CUT}" -d ":" -f 3 || builtin return 126
}

stdlib.security.get.uid ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    id -u "${1}" || builtin return 126
}

stdlib.security.get.unused_uid ()
{
    builtin local current_id;
    builtin local -a existing_ids;
    builtin local existing_ids_index=0;
    [[ "${#@}" == "0" ]] || builtin return 127;
    builtin read -d '' -ra existing_ids <<< "$("${_STDLIB_BINARY_CAT}" /etc/group /etc/passwd | "${_STDLIB_BINARY_CUT}" -d ':' -f 3 | "${_STDLIB_BINARY_SORT}" -n | "${_STDLIB_BINARY_GREP}" "^....$\|^.....$")" || builtin true;
    for ((current_id = "1000"; current_id <= "65535"; current_id++))
    do
        while ((existing_ids_index < "${#existing_ids[@]}")); do
            if ((current_id < "${existing_ids[existing_ids_index]}")); then
                builtin break;
            fi;
            if ((current_id == "${existing_ids[existing_ids_index]}")); then
                ((existing_ids_index = existing_ids_index + 1));
                builtin continue 2;
            fi;
            ((existing_ids_index = existing_ids_index + 1));
        done;
        id "${current_id}" > /dev/null 2>&1 || {
            builtin echo "${current_id}";
            builtin return 0
        };
    done;
    builtin return 1
}

stdlib.security.path.assert.has_group ()
{
    builtin local return_code=0;
    stdlib.security.path.query.has_group "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        1)
            stdlib.logger.error "$(stdlib.__message.get SECURITY_INSECURE_GROUP_OWNERSHIP "${1}")";
            stdlib.logger.info "$(stdlib.__message.get SECURITY_SUGGEST_CHGRP "${2}" "${1}")"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.security.path.assert.has_owner ()
{
    builtin local return_code=0;
    stdlib.security.path.query.has_owner "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        1)
            stdlib.logger.error "$(stdlib.__message.get SECURITY_INSECURE_OWNERSHIP "${1}")";
            stdlib.logger.info "$(stdlib.__message.get SECURITY_SUGGEST_CHOWN "${2}" "${1}")"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.security.path.assert.has_permissions ()
{
    builtin local return_code=0;
    stdlib.security.path.query.has_permissions "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        1)
            stdlib.logger.error "$(stdlib.__message.get SECURITY_INSECURE_PERMISSIONS "${1}")";
            stdlib.logger.info "$(stdlib.__message.get SECURITY_SUGGEST_CHMOD "${2}" "${1}")"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.security.path.assert.is_secure ()
{
    [[ "${#@}" == "4" ]] || builtin return 127;
    stdlib.security.path.assert.has_owner "${1}" "${2}" || builtin return "$?";
    stdlib.security.path.assert.has_group "${1}" "${3}" || builtin return "$?";
    stdlib.security.path.assert.has_permissions "${1}" "${4}" || builtin return "$?"
}

stdlib.security.path.make.dir ()
{
    [[ "${#@}" == "4" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    [[ -n "${3}" ]] || builtin return 126;
    [[ -n "${4}" ]] || builtin return 126;
    mkdir -p "${1}";
    stdlib.security.path.secure "${@}"
}

stdlib.security.path.make.file ()
{
    [[ "${#@}" == "4" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    [[ -n "${3}" ]] || builtin return 126;
    [[ -n "${4}" ]] || builtin return 126;
    touch "${1}";
    stdlib.security.path.secure "${@}"
}

stdlib.security.path.query.has_group ()
{
    builtin local required_gid;
    [[ "${#@}" == "2" ]] || builtin return 127;
    stdlib.io.path.query.is_exists "${1}" || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    required_gid="$(stdlib.security.get.gid "${2}")";
    if [[ "$(stat -c "%g" "${1}")" != "${required_gid}" ]]; then
        builtin return 1;
    fi
}

stdlib.security.path.query.has_owner ()
{
    builtin local required_uid;
    [[ "${#@}" == "2" ]] || builtin return 127;
    stdlib.io.path.query.is_exists "${1}" || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    required_uid="$(stdlib.security.get.uid "${2}")";
    if [[ "$(stat -c "%u" "${1}")" != "${required_uid}" ]]; then
        builtin return 1;
    fi
}

stdlib.security.path.query.has_permissions ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    stdlib.io.path.query.is_exists "${1}" || builtin return 126;
    stdlib.string.query.is_octal_permission "${2}" || builtin return 126;
    if [[ "$(stat -c "%a" "${1}")" != "${2}" ]]; then
        builtin return 1;
    fi
}

stdlib.security.path.query.is_secure ()
{
    [[ "${#@}" == "4" ]] || builtin return 127;
    if ! stdlib.security.path.query.has_owner "${1}" "${2}" || ! stdlib.security.path.query.has_group "${1}" "${3}" || ! stdlib.security.path.query.has_permissions "${1}" "${4}"; then
        builtin return 1;
    fi
}

stdlib.security.path.secure ()
{
    stdlib.fn.args.require "4" "0" "${@}" || builtin return "$?";
    chown "${2}":"${3}" "${1}";
    chmod "${4}" "${1}"
}

stdlib.security.user.assert.is_root ()
{
    builtin local return_code=0;
    stdlib.security.user.query.is_root "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        1)
            stdlib.logger.error "$(stdlib.__message.get SECURITY_MUST_BE_RUN_AS_ROOT)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.security.user.query.is_root ()
{
    [[ "${#@}" == "0" ]] || builtin return 127;
    if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
        builtin return 1;
    fi
}

stdlib.setting.colour.disable ()
{
    stdlib.setting.colour.state.disabled;
    stdlib.setting.theme.load
}

stdlib.setting.colour.enable ()
{
    builtin local silent_fallback_boolean="${_STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN:-0}";
    builtin local error_message="";
    if ! "${_STDLIB_BINARY_TPUT}" init 2> /dev/null; then
        if [[ "${silent_fallback_boolean}" != "1" ]]; then
            stdlib.setting.colour.enable._generate_error_message;
            builtin return 1;
        fi;
        stdlib.setting.colour.disable;
        builtin return 0;
    fi;
    stdlib.setting.colour.state.enabled;
    stdlib.setting.theme.load
}

stdlib.setting.colour.enable._generate_error_message ()
{
    builtin local error_message="";
    error_message+="$(stdlib.__message.get COLOUR_INITIALIZE_ERROR)\n";
    if [[ -z "${TERM}" ]]; then
        error_message+="$(stdlib.__message.get COLOUR_INITIALIZE_ERROR_TERM)\n";
    fi;
    builtin echo -en "${error_message}" 1>&2
}

stdlib.setting.colour.state.disabled ()
{
    STDLIB_COLOUR_NC="";
    STDLIB_COLOUR_BLACK="";
    STDLIB_COLOUR_RED="";
    STDLIB_COLOUR_GREEN="";
    STDLIB_COLOUR_YELLOW="";
    STDLIB_COLOUR_BLUE="";
    STDLIB_COLOUR_PURPLE="";
    STDLIB_COLOUR_CYAN="";
    STDLIB_COLOUR_WHITE="";
    STDLIB_COLOUR_GREY="";
    STDLIB_COLOUR_LIGHT_RED="";
    STDLIB_COLOUR_LIGHT_GREEN="";
    STDLIB_COLOUR_LIGHT_YELLOW="";
    STDLIB_COLOUR_LIGHT_BLUE="";
    STDLIB_COLOUR_LIGHT_PURPLE="";
    STDLIB_COLOUR_LIGHT_CYAN="";
    STDLIB_COLOUR_LIGHT_WHITE=""
}

stdlib.setting.colour.state.enabled ()
{
    STDLIB_COLOUR_NC="$("${_STDLIB_BINARY_TPUT}" sgr0)";
    STDLIB_COLOUR_BLACK="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 0)";
    STDLIB_COLOUR_RED="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 1)";
    STDLIB_COLOUR_GREEN="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 2)";
    STDLIB_COLOUR_YELLOW="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 3)";
    STDLIB_COLOUR_BLUE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 4)";
    STDLIB_COLOUR_PURPLE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 5)";
    STDLIB_COLOUR_CYAN="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 6)";
    STDLIB_COLOUR_WHITE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 7)";
    STDLIB_COLOUR_GREY="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 0 bold)";
    STDLIB_COLOUR_LIGHT_RED="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 1 bold)";
    STDLIB_COLOUR_LIGHT_GREEN="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 2 bold)";
    STDLIB_COLOUR_LIGHT_YELLOW="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 3 bold)";
    STDLIB_COLOUR_LIGHT_BLUE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 4 bold)";
    STDLIB_COLOUR_LIGHT_PURPLE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 5 bold)";
    STDLIB_COLOUR_LIGHT_CYAN="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 6 bold)";
    STDLIB_COLOUR_LIGHT_WHITE="$("${_STDLIB_BINARY_TPUT}" sgr0
"${_STDLIB_BINARY_TPUT}" setaf 7 bold)"
}

stdlib.setting.colour.state.theme ()
{
    STDLIB_THEME_LOGGER_ERROR="LIGHT_RED";
    STDLIB_THEME_LOGGER_WARNING="YELLOW";
    STDLIB_THEME_LOGGER_INFO="WHITE";
    STDLIB_THEME_LOGGER_NOTICE="GREY";
    STDLIB_THEME_LOGGER_SUCCESS="GREEN"
}

stdlib.setting.theme.get_colour ()
{
    builtin local theme_colour;
    theme_colour="STDLIB_COLOUR_${1}";
    if [[ -z "${!theme_colour+set}" ]]; then
        stdlib.logger.warning "$(stdlib.__message.get COLOUR_NOT_DEFINED "${1}")";
    fi;
    builtin echo "${theme_colour}"
}

stdlib.setting.theme.load ()
{
    stdlib.setting.colour.state.theme
}

stdlib.string.assert.is_alpha ()
{
    builtin local return_code=0;
    stdlib.string.query.is_alpha "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_ALPHABETIC "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_alpha_numeric ()
{
    builtin local return_code=0;
    stdlib.string.query.is_alpha_numeric "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_ALPHA_NUMERIC "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_boolean ()
{
    builtin local return_code=0;
    stdlib.string.query.is_boolean "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_BOOLEAN "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_char ()
{
    builtin local return_code=0;
    stdlib.string.query.is_char "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_CHAR "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_digit ()
{
    builtin local return_code=0;
    stdlib.string.query.is_digit "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_DIGIT "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_integer ()
{
    builtin local return_code=0;
    stdlib.string.query.is_integer "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_INTEGER "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_integer_with_range ()
{
    builtin local return_code=0;
    stdlib.string.query.is_integer_with_range "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_INTEGER_IN_RANGE "${1}" "${2}" "${3}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_octal_permission ()
{
    builtin local return_code=0;
    stdlib.string.query.is_octal_permission "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_OCTAL_PERMISSION "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_regex_match ()
{
    builtin local return_code=0;
    stdlib.string.query.is_regex_match "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get REGEX_DOES_NOT_MATCH "${1}" "${2}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.is_string ()
{
    builtin local return_code=0;
    stdlib.string.query.is_string "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_NOT_SET_STRING "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.assert.not_equal ()
{
    builtin local return_code=0;
    [[ "${1}" != "${2}" ]] || return_code="1";
    [[ -n "${1}" ]] || return_code="126";
    [[ "${#@}" == "2" ]] || return_code="127";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get IS_EQUAL "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.string.colour ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local string_output;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    string_output="$(stdlib.string.colour_n "${1}" "${2}")";
    builtin echo -e "${string_output}"
}

stdlib.string.colour.substring ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local string_colour;
    _STDLIB_ARGS_NULL_SAFE=("2" "3");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    string_colour="$(stdlib.setting.theme.get_colour "${1}")";
    builtin echo -e "${3/${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

stdlib.string.colour.substring_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "3" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.colour.substring" "${mutate_received_args[@]}"
}

stdlib.string.colour.substring_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.colour.substring" "${fn_arguments[@]}")"
}

stdlib.string.colour.substrings ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local string_colour;
    _STDLIB_ARGS_NULL_SAFE=("2" "3");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    string_colour="$(stdlib.setting.theme.get_colour "${1}")";
    builtin echo -e "${3//${2}/${!string_colour}${2}${STDLIB_COLOUR_NC}}"
}

stdlib.string.colour.substrings_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "3" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.colour.substrings" "${mutate_received_args[@]}"
}

stdlib.string.colour.substrings_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.colour.substrings" "${fn_arguments[@]}")"
}

stdlib.string.colour_n ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local string_colour;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    string_colour="$(stdlib.setting.theme.get_colour "${1}")";
    builtin echo -ne "${!string_colour}${2}${STDLIB_COLOUR_NC}"
}

stdlib.string.colour_n_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.colour_n" "${mutate_received_args[@]}"
}

stdlib.string.colour_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.colour" "${mutate_received_args[@]}"
}

stdlib.string.colour_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.colour_n" "${fn_arguments[@]}")"
}

stdlib.string.justify.left ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    builtin printf "%-${1}b"'
' "${2}"
}

stdlib.string.justify.left_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.justify.left" "${mutate_received_args[@]}"
}

stdlib.string.justify.left_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.justify.left" "${fn_arguments[@]}")"
}

stdlib.string.justify.right ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    builtin printf "%${1}s"'
' "${2}"
}

stdlib.string.justify.right_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.justify.right" "${mutate_received_args[@]}"
}

stdlib.string.justify.right_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.justify.right" "${fn_arguments[@]}")"
}

stdlib.string.lines.join ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local delimiter="${_STDLIB_DELIMITER:-
}";
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    builtin printf '%s\n' "${1//${delimiter}/}"
}

stdlib.string.lines.join_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.lines.join" "${mutate_received_args[@]}"
}

stdlib.string.lines.join_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.lines.join" "${fn_arguments[@]}")"
}

stdlib.string.lines.map.fn ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local delimiter="${_STDLIB_DELIMITER:-
}";
    builtin local line="";
    builtin local output="";
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
        "${1}" "${2}";
        builtin return;
    fi;
    while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
        output+="$("${1}" "${line}")${delimiter}";
    done < <(builtin echo -n "${2}${delimiter}");
    builtin echo -e "${output%?}"
}

stdlib.string.lines.map.fn_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.lines.map.fn" "${mutate_received_args[@]}"
}

stdlib.string.lines.map.fn_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.lines.map.fn" "${fn_arguments[@]}")"
}

stdlib.string.lines.map.format ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local delimiter="${_STDLIB_DELIMITER:-
}";
    builtin local line="";
    builtin local output="";
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    if ! stdlib.string.query.has_substring "${delimiter}" "${2}"; then
        builtin printf "${1}" "${2}";
        builtin return;
    fi;
    while IFS="${delimiter}" builtin read -r -d "${delimiter}" line; do
        output+="$(builtin printf "${1}" "${line}")${delimiter}";
    done < <(builtin echo -n "${2}${delimiter}");
    builtin echo -e "${output%?}"
}

stdlib.string.lines.map.format_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.lines.map.format" "${mutate_received_args[@]}"
}

stdlib.string.lines.map.format_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.lines.map.format" "${fn_arguments[@]}")"
}

stdlib.string.pad.left ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    builtin printf "%*s%s"'
' "${1}" " " "${2}"
}

stdlib.string.pad.left_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.pad.left" "${mutate_received_args[@]}"
}

stdlib.string.pad.left_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.pad.left" "${fn_arguments[@]}")"
}

stdlib.string.pad.right ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("2");
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    builtin printf "%s%*s"'
' "${2}" "${1}" " "
}

stdlib.string.pad.right_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "2" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.pad.right" "${mutate_received_args[@]}"
}

stdlib.string.pad.right_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.pad.right" "${fn_arguments[@]}")"
}

stdlib.string.query.ends_with ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    [[ "${2}" == *"${1}" ]] || builtin return 1;
    builtin return 0
}

stdlib.string.query.first_char_is ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ "${#1}" == "1" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    stdlib.string.query.has_char_n "${1}" "0" "${2}"
}

stdlib.string.query.has_char_n ()
{
    [[ "${#@}" == "3" ]] || builtin return 127;
    stdlib.string.query.is_char "${1}" || builtin return "$?";
    stdlib.string.query.is_digit "${2}" || builtin return "$?";
    [[ -n "${3}" ]] || builtin return 126;
    [[ "${1}" != "${3:${2}:1}" ]] && builtin return 1;
    builtin return 0
}

stdlib.string.query.has_substring ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    [[ "${2}" != *"${1}"* ]] && builtin return 1;
    builtin return 0
}

stdlib.string.query.is_alpha ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    case "${1}" in
        "")
            builtin return 126
        ;;
        *[![:alpha:]]*)
            builtin return 1
        ;;
        *)
            builtin return 0
        ;;
    esac
}

stdlib.string.query.is_alpha_numeric ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    case "${1}" in
        "")
            builtin return 126
        ;;
        *[![:alnum:]]*)
            builtin return 1
        ;;
        *)
            builtin return 0
        ;;
    esac
}

stdlib.string.query.is_boolean ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    case "${1}" in
        "")
            builtin return 126
        ;;
        [0-1])
            builtin return 0
        ;;
        *)
            builtin return 1
        ;;
    esac
}

stdlib.string.query.is_char ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ "${#1}" == "1" ]] || builtin return 1
}

stdlib.string.query.is_digit ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    case "${1}" in
        "")
            builtin return 126
        ;;
        *[!0-9]*)
            builtin return 1
        ;;
        *)
            builtin return 0
        ;;
    esac
}

stdlib.string.query.is_integer ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    if {
        builtin test "${1}" -gt "-1" 2> /dev/null || builtin test "${1}" -lt "1" 2> /dev/null
    }; then
        builtin return 0;
    fi;
    builtin return 1
}

stdlib.string.query.is_integer_with_range ()
{
    [[ "${#@}" == "3" ]] || builtin return 127;
    stdlib.string.query.is_integer "${1}" || builtin return 126;
    stdlib.string.query.is_integer "${2}" || builtin return 126;
    [[ "${1}" -le ${2} ]] || builtin return 126;
    stdlib.string.query.is_integer "${3}" || builtin return 126;
    if [[ "${3}" -ge "${1}" ]] && [[ "${3}" -le "${2}" ]]; then
        builtin return 0;
    fi;
    builtin return 1
}

stdlib.string.query.is_octal_permission ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    case "${1}" in
        "")
            builtin return 126
        ;;
        [0-7][0-7][0-7] | [0-7][0-7][0-7][0-7])
            builtin return 0
        ;;
        *)
            builtin return 1
        ;;
    esac
}

stdlib.string.query.is_regex_match ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    if [[ "${2}" =~ ${1} ]]; then
        builtin return 0;
    fi;
    builtin return 1
}

stdlib.string.query.is_string ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 1
}

stdlib.string.query.last_char_is ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ "${#1}" == "1" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    stdlib.string.query.has_char_n "${1}" "$(("${#2}" - 1))" "${2}"
}

stdlib.string.query.starts_with ()
{
    [[ "${#@}" == "2" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    [[ -n "${2}" ]] || builtin return 126;
    [[ "${2}" == "${1}"* ]] || builtin return 1;
    builtin return 0
}

stdlib.string.trim.left ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    builtin shopt -s extglob;
    builtin printf '%s\n' "${1##+([[:space:]])}";
    builtin shopt -u extglob
}

stdlib.string.trim.left_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.trim.left" "${mutate_received_args[@]}"
}

stdlib.string.trim.left_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.trim.left" "${fn_arguments[@]}")"
}

stdlib.string.trim.right ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    _STDLIB_ARGS_NULL_SAFE=("1");
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    builtin shopt -s extglob;
    builtin printf '%s\n' "${1%%+([[:space:]])}";
    builtin shopt -u extglob
}

stdlib.string.trim.right_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "1" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.trim.right" "${mutate_received_args[@]}"
}

stdlib.string.trim.right_var ()
{
    builtin local fn_argument_index;
    builtin local fn_argument_index_variable_name="-1";
    builtin local -a fn_arguments;
    builtin local fn_variable_name="";
    stdlib.fn.args.require "1" "1000" "${@}" || builtin return "$?";
    if [[ "-1" -lt "0" ]]; then
        fn_argument_index_variable_name="$(("${#@}" + 1 + "-1"))";
    fi;
    for ((fn_argument_index=1; fn_argument_index <= "${#@}"; fn_argument_index+=1))
    do
        if (("${fn_argument_index}" == "${fn_argument_index_variable_name}")); then
            fn_variable_name="${!fn_argument_index}";
            fn_arguments+=("${!fn_variable_name}");
        else
            fn_arguments+=("${!fn_argument_index}");
        fi;
    done;
    builtin printf -v "${fn_variable_name}" "%s" "$("stdlib.string.trim.right" "${fn_arguments[@]}")"
}

stdlib.string.wrap ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local wrap_indent_string="${_STDLIB_WRAP_PREFIX_STRING:-""}";
    builtin local forced_line_break_char="${_STDLIB_LINE_BREAK_CHAR:-*}";
    builtin local current_line="";
    builtin local current_line_length=0;
    builtin local current_word="";
    builtin local current_word_length=0;
    builtin local -a input_array;
    builtin local output="";
    builtin local wrap_limit=0;
    builtin local wrap_indent_length="${#wrap_indent_string}";
    _STDLIB_ARGS_NULL_SAFE=("3");
    stdlib.fn.args.require "3" "0" "${@}" || builtin return "$?";
    stdlib.string.assert.is_digit "${1}" || builtin return 126;
    stdlib.string.assert.is_digit "${2}" || builtin return 126;
    wrap_limit="$(("${2}" - "${1}"))";
    builtin read -ra input_array <<< "${3}";
    for current_word in "${input_array[@]}";
    do
        current_line_length="${#current_line}";
        current_word_length="${#current_word}";
        if stdlib.string.query.first_char_is "${forced_line_break_char}" "${current_word}"; then
            current_word="${current_word:1}";
            current_line_length="${wrap_limit}";
        fi;
        if (("$((current_line_length + current_word_length + wrap_indent_length))" <= wrap_limit)); then
            current_line+="${current_word} ";
            output+="${current_word} ";
        else
            current_line="${current_word} ";
            current_word="${wrap_indent_string}${current_word}";
            stdlib.string.pad.left_var "${1}" "current_word";
            output="${output%?}";
            output+="\n${current_word} ";
        fi;
    done;
    builtin echo -e "${output%?}"
}

stdlib.string.wrap_pipe ()
{
    builtin local mutate_examined_arg="";
    builtin local mutate_examined_arg_index=0;
    builtin local mutate_pipe_input="";
    builtin local mutate_pipe_input_index=0;
    builtin local mutate_pipe_input_line='';
    builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED";
    builtin local -a mutate_received_args;
    mutate_received_args=("$@");
    if [[ "${#@}" -lt "3" ]]; then
        mutate_pipe_parser_strategy="STDIN_ASSUMED";
        mutate_pipe_input_index="$(("${#@}" + 1))";
    fi;
    if [[ "${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
        for mutate_examined_arg in "${@}";
        do
            if [[ "${mutate_examined_arg}" == "-" ]]; then
                mutate_pipe_parser_strategy="STDIN_POSITIONAL";
                mutate_pipe_input_index="${mutate_examined_arg_index}";
                builtin break;
            fi;
            ((mutate_examined_arg_index+=1));
        done;
    fi;
    if [[ "${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
        while IFS= builtin read -r mutate_pipe_input_line; do
            mutate_pipe_input+="${mutate_pipe_input_line}";
            mutate_pipe_input+='
';
        done;
        mutate_pipe_input="${mutate_pipe_input%?}";
        mutate_received_args[mutate_pipe_input_index]="${mutate_pipe_input}";
    fi;
    "stdlib.string.wrap" "${mutate_received_args[@]}"
}

stdlib.trap.__register_default_handlers ()
{
    stdlib.trap.create.handler "stdlib.trap.handler.err.fn" STDLIB_HANDLER_ERR;
    stdlib.trap.create.handler "stdlib.trap.handler.exit.fn" STDLIB_HANDLER_EXIT;
    stdlib.trap.create.clean_up_fn "stdlib.trap.fn.clean_up_on_exit" STDLIB_CLEANUP_FN;
    stdlib.trap.handler.exit.fn.register "stdlib.trap.fn.clean_up_on_exit";
    if [[ "${STDLIB_TRACEBACK_DISABLE_BOOLEAN}" -eq "0" ]]; then
        stdlib.trap.handler.err.fn.register stdlib.logger.traceback;
    fi
}

stdlib.trap.create.clean_up_fn ()
{
    builtin local rm_flags="-f";
    builtin local recursive_deletes="${3:-0}";
    stdlib.fn.args.require "2" "1" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    stdlib.string.assert.is_boolean "${recursive_deletes}" || builtin return 126;
    if (("${recursive_deletes}")); then
        rm_flags+="r";
    fi;
    builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF

${1}() {
  builtin local clean_up_path

  [[ "\${#@}" -eq 0 ]] || builtin return 127

  for clean_up_path in "\${${2}[@]}"; do
    if stdlib.io.path.query.is_exists "\${clean_up_path}"; then
      "${_STDLIB_BINARY_RM}" "${rm_flags}" "\${clean_up_path}"
    fi
  done
}

EOF
)"
}

stdlib.trap.create.handler ()
{
    stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?";
    stdlib.array.assert.is_array "${2}" || builtin return 126;
    builtin eval "$("${_STDLIB_BINARY_CAT}" <<EOF

${1}() {
  builtin local trap_handler_fn

  [[ "\${#@}" -eq 0 ]] || builtin return 127

  for trap_handler_fn in "\${${2}[@]}"; do
    "\${trap_handler_fn}"
  done
}

${1}.register() {
  # $1: the function to register

  stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  stdlib.fn.assert.is_fn "\${1}" || builtin return 126

  ${2}+=("\${1}")
}

EOF
)"
}

stdlib.trap.fn.clean_up_on_exit ()
{
    builtin local clean_up_path;
    [[ "${#@}" -eq 0 ]] || builtin return 127;
    for clean_up_path in "${STDLIB_CLEANUP_FN[@]}";
    do
        if stdlib.io.path.query.is_exists "${clean_up_path}"; then
            "/usr/bin/rm" "-f" "${clean_up_path}";
        fi;
    done
}

stdlib.trap.handler.err.fn ()
{
    builtin local trap_handler_fn;
    [[ "${#@}" -eq 0 ]] || builtin return 127;
    for trap_handler_fn in "${STDLIB_HANDLER_ERR[@]}";
    do
        "${trap_handler_fn}";
    done
}

stdlib.trap.handler.err.fn.register ()
{
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    STDLIB_HANDLER_ERR+=("${1}")
}

stdlib.trap.handler.exit.fn ()
{
    builtin local trap_handler_fn;
    [[ "${#@}" -eq 0 ]] || builtin return 127;
    for trap_handler_fn in "${STDLIB_HANDLER_EXIT[@]}";
    do
        "${trap_handler_fn}";
    done
}

stdlib.trap.handler.exit.fn.register ()
{
    stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?";
    stdlib.fn.assert.is_fn "${1}" || builtin return 126;
    STDLIB_HANDLER_EXIT+=("${1}")
}

stdlib.var.assert.is_valid_name ()
{
    builtin local return_code=0;
    stdlib.var.query.is_valid_name "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        126 | 127)
            stdlib.logger.error "$(stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            stdlib.logger.error "$(stdlib.__message.get VAR_NAME_INVALID "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

stdlib.var.query.is_valid_name ()
{
    [[ "${#@}" == "1" ]] || builtin return 127;
    [[ -n "${1}" ]] || builtin return 126;
    case "${1}" in
        *[!A-Za-z0-9_]*)
            builtin return 1
        ;;
        *)
            builtin return 0
        ;;
    esac
}

# this snippet is included by the build script:
# src/gettext.snippet
STDLIB_TEXTDOMAINDIR="${STDLIB_TEXTDOMAINDIR-$(dirname -- "${BASH_SOURCE[0]}/locales")}"

# shellcheck disable=SC2034
{
  builtin export TEXTDOMAIN
  builtin export TEXTDOMAINDIR
}

set +e
stdlib.__builtin.overridable source gettext.sh 2> /dev/null || stdlib.__gettext.fallback
set -e

# this snippet is included by the build script:
# src/trap/register.snippet
stdlib.trap.__register_default_handlers

trap stdlib.trap.handler.err.fn ERR
trap stdlib.trap.handler.exit.fn EXIT

# colours are disabled by default
stdlib.setting.colour.disable
