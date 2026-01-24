#!/bin/bash

# stdlib io stdin library

builtin set -eo pipefail

STDLIB_STDIN_PASSWORD_MASK_BOOLEAN=""

# @description Prompts the user for a confirmation (Y/n).
# @arg $1 string (optional, default=STDIN_DEFAULT_CONFIRMATION_PROMPT) The prompt to display.
# @exitcode 0 If the user confirmed with 'Y'.
# @exitcode 1 If the user declined with 'n'.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The user input character.
# @stdout The prompt and a newline after input.
# @stderr The error message if the operation fails.
stdlib.io.stdin.confirmation() {
  builtin local input_char
  builtin local prompt="${1:-"$(stdlib.__message.get STDIN_DEFAULT_CONFIRMATION_PROMPT)"}"

  stdlib.fn.args.require "0" "1" "${@}" || builtin return "$?"

  builtin echo -en "${prompt}"

  while builtin true; do
    builtin read -rs -n 1 input_char
    if [[ "${input_char}" == "n" ]]; then
      builtin echo
      builtin return 1
    fi
    if [[ "${input_char}" == "Y" ]]; then
      builtin echo
      builtin return 0
    fi
  done
}

# @description Pauses the script until the user presses a key.
# @arg $1 string (optional, default=STDIN_DEFAULT_PAUSE_PROMPT) The prompt to display.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The user input character.
# @stdout The prompt.
# @stderr The error message if the operation fails.
stdlib.io.stdin.pause() {
  builtin local input_char
  builtin local prompt="${1:-"$(stdlib.__message.get STDIN_DEFAULT_PAUSE_PROMPT)"}"

  stdlib.fn.args.require "0" "1" "${@}" || builtin return "$?"

  builtin echo -en "${prompt}"
  builtin read -rs -n 1 input_char
}

# @description Prompts the user for a value and saves it to a variable.
#   * STDLIB_STDIN_PASSWORD_MASK_BOOLEAN: Indicates if the input should be masked, i.e. for passwords (default="0").
# @arg $1 string The variable name to save the input to.
# @arg $2 string (optional, default=STDIN_DEFAULT_VALUE_PROMPT) The prompt to display.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The user input.
# @stdout The prompt.
# @stderr The error message if the operation fails.
stdlib.io.stdin.prompt() {
  builtin local flags="-rp"
  builtin local prompt="${2:-"$(stdlib.__message.get STDIN_DEFAULT_VALUE_PROMPT)"}"
  builtin local password="${STDLIB_STDIN_PASSWORD_MASK_BOOLEAN:-0}"

  stdlib.fn.args.require "1" "1" "${@}" || builtin return "$?"

  if [[ "${password}" == "1" ]]; then
    flags="-rsp"
  fi

  while [[ -z "${!1}" ]]; do
    # shellcheck disable=SC2229,SC2162
    stdlib.__builtin.overridable read "${flags}" "${prompt}" "${1}"
    if [[ "${password}" == "1" ]]; then
      stdlib.__builtin.overridable echo
    fi
  done
}
