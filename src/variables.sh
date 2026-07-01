#!/bin/bash
# shellcheck disable=SC2034

# stdlib variables library

builtin set -eo pipefail

# globals
builtin declare -g "STDLIB_COLOUR_NULL="
builtin declare -g "STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN=${STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN:-}"
builtin declare -g "STDLIB_TRACEBACK_DISABLE_BOOLEAN=${STDLIB_TRACEBACK_DISABLE_BOOLEAN:-1}"
builtin declare -ga "STDLIB_CLEANUP_FN_TARGETS_ARRAY=()"
builtin declare -ga "STDLIB_HANDLER_ERR_FN_ARRAY=()"
builtin declare -ga "STDLIB_HANDLER_EXIT_FN_ARRAY=()"
builtin declare -gx "STDLIB_LOCK_WORKSPACE=${STDLIB_LOCK_WORKSPACE:-}"

# keywords
builtin declare -g "STDLIB_ARGS_CALLER_FN_NAME="
builtin declare -g "STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="
builtin declare -g "STDLIB_FIELD_DELIMITER_ENCODE_CHAR="
builtin declare -g "STDLIB_FIELD_DELIMITER="
builtin declare -g "STDLIB_KW_SOURCE_VAR="
builtin declare -g "STDLIB_LOCK_PERMISSION_OCTAL="
builtin declare -g "STDLIB_LOCK_POLLING_INTERVAL="
builtin declare -g "STDLIB_LOCK_QUIET_FAILURE_BOOLEAN="
builtin declare -g "STDLIB_LOCK_WAIT_SECONDS="
builtin declare -g "STDLIB_LOCK_WORKSPACE_PERMISSION_OCTAL="
builtin declare -g "STDLIB_LOGGING_MESSAGE_PREFIX="
builtin declare -g "STDLIB_PIPEABLE_STDIN_SOURCE_SPECIFIER="
builtin declare -g "STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="
builtin declare -g "STDLIB_VALIDATION_SOURCE_VAR="
builtin declare -g "STDLIB_WRAP_LINE_BREAK_FORCE_CHAR="
builtin declare -g "STDLIB_WRAP_PREFIX="
builtin declare -ga "STDLIB_ARGS_NULL_SAFE_ARRAY=()"

# reserved
builtin declare -g "__STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN="
builtin declare -ga "__STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()"
builtin declare -ga "__STDLIB_DEFERRED_FN_ARRAY=('stdlib.fn.derive.pipeable' 'stdlib.fn.derive.var')"
builtin declare -ga "__STDLIB_LOGGING_DECORATORS_ARRAY=('_testing.__protected')"
builtin declare -ga "__STDLIB_SECURE_DISTRIBUTION=${__STDLIB_SECURE_DISTRIBUTION:-0}"
