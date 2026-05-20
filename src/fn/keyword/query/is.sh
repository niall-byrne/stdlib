#!/bin/bash

# stdlib fn keyword query is library

builtin set -eo pipefail

STDLIB_KW_DEFAULT=""

# @description Checks if a keyword's value is valid against a validation function.
#   * STDLIB_KW_DEFAULT: A default value to use for this keyword if it has not been set (default='').
# @arg $1 string The validation function to run.
# @arg $2 string The name of the variable containing the value to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.
# @exitcode 0 If the variable passes the validation function.
# @exitcode 1 If the variable fails the validation check.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.fn.keyword.query.is_valid_with() {
  builtin local return_code=0
  builtin local -a kw_source_types
  builtin local validation_source="${2}"
  builtin local validation_source_selection="${3:-value}"

  # shellcheck disable=SC2034
  kw_source_types=("name" "value")

  { [[ "${#@}" -ge "2" ]] && [[ "${#@}" -le "3" ]]; } || builtin return 127

  stdlib.fn.query.is_fn "${1}" || builtin return 126
  stdlib.var.query.is_set "${validation_source}" || builtin return 126
  stdlib.array.query.is_contains "${validation_source_selection}" kw_source_types || builtin return 126

  if ! stdlib.string.query.is_empty "${STDLIB_KW_DEFAULT}"; then
    stdlib.var.query.is_set "${STDLIB_KW_DEFAULT}" || builtin return 125 # validates STDLIB_KW_DEFAULT
    if stdlib.var.query.is_empty "${validation_source}"; then
      validation_source="${STDLIB_KW_DEFAULT}"
    fi
  fi

  if [[ "${validation_source_selection}" == "name" ]]; then
    "${1}" "${validation_source}" || return_code="$?"
  else
    "${1}" "${!validation_source}" || return_code="$?"
  fi

  builtin return "${return_code}"
}
