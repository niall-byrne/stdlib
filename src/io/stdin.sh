#!/bin/bash

# stdlib io stdin library

builtin set -eo pipefail

_STDLIB_PASSWORD_BOOLEAN=""

# @description Prompts the user for confirmation (Y/n).
# @arg $1 (optional) The prompt to display.
# @exitcode 0 If the user confirms (Y).
# @exitcode 1 If the user denies (n).
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The confirmation prompt.
stdlib.io.stdin.confirmation() {
  builtin local input_char
  builtin local prompt="${1:-"$(stdlib.message.get STDIN_DEFAULT_CONFIRMATION_PROMPT)"}"

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

# @description Pauses execution until the user presses any key.
# @arg $1 (optional) The prompt to display.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The pause prompt.
stdlib.io.stdin.pause() {
  builtin local input_char
  builtin local prompt="${1:-"$(stdlib.message.get STDIN_DEFAULT_PAUSE_PROMPT)"}"

  stdlib.fn.args.require "0" "1" "${@}" || builtin return "$?"

  builtin echo -en "${prompt}"
  builtin read -rs -n 1 input_char
}

# @description Prompts the user for a value and saves it to a variable.
#     _STDLIB_PASSWORD_BOOLEAN: Set to 1 to mask password entry.
# @arg $1 The name of the variable to save the input to.
# @arg $2 (optional) The prompt to display.
# @exitcode 127 If the wrong number of arguments is provided.
# @stdout The value prompt.
stdlib.io.stdin.prompt() {
  builtin local flags="-rp"
  builtin local prompt="${2:-"$(stdlib.message.get STDIN_DEFAULT_VALUE_PROMPT)"}"
  builtin local password="${_STDLIB_PASSWORD_BOOLEAN:-0}"

  stdlib.fn.args.require "1" "1" "${@}" || builtin return "$?"

  if [[ "${password}" == "1" ]]; then
    flags="-rsp"
  fi

  while [[ -z "${!1}" ]]; do
    # shellcheck disable=SC2229,SC2162
    stdlib.builtin.overridable read "${flags}" "${prompt}" "${1}"
    if [[ "${password}" == "1" ]]; then
      stdlib.builtin.overridable echo
    fi
  done
}
