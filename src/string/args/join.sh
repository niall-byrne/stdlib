#!/bin/bash

# stdlib string args join library

builtin set -eo pipefail

# @description Joins the given arguments into a string by using the given delimiter.
# @arg $1 string The delimiter string used to join the arguments (an empty string is a valid argument).
# @arg $@ array A list of input strings to join together.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.args.join() {
  builtin local string_output
  builtin local delimiter="${1}"

  STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="1" stdlib.fn.args.require "2" "1000" "${@}" || builtin return "$?"

  builtin shift

  while [[ -n "${1}" ]]; do
    [[ -z "${string_output}" ]] || string_output+="${delimiter}"
    string_output+="${1}"
    builtin shift
  done

  builtin echo "${string_output}"
}

# @description A derivative of stdlib.string.args.join that can read from stdin.
# @arg $1 string The delimiter string used to join the arguments.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The strings to process (separated by newlines).
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.args.join_pipe() {
  builtin local string_input_line
  builtin local -a string_input
  builtin local delimiter="${1}"

  STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="1" stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"

  while IFS= builtin read -r string_input_line; do
    string_input+=("${string_input_line}")
  done

  stdlib.string.args.join "${delimiter}" "${string_input[@]}"
}

# @description A derivative of stdlib.string.args.join that can write to a variable.
# @arg $1 string The name of the variable to write to.
# @arg $2 string The delimiter string used to join the arguments (an empty string is a valid argument).
# @arg $@ array A list of input strings to join together.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The joined string.
# @stderr The error message if the operation fails.
stdlib.string.args.join_var() {
  builtin local var_name="${1}"

  STDLIB_ARGS_NULL_SAFE_ALL_BOOLEAN="1" stdlib.fn.args.require "3" "1000" "${@}" || builtin return "$?"
  stdlib.var.query.is_valid_name "${var_name}" || builtin return 126

  builtin shift

  builtin printf -v "${var_name}" "%s" "$(stdlib.string.args.join "${@}")"
}
