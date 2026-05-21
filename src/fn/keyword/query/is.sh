#!/bin/bash

# stdlib fn keyword query is library

builtin set -eo pipefail

STDLIB_KW_SOURCE_VAR=""

# @description Checks if a keyword's value is valid against a validation function.
#   * STDLIB_KW_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the keyword to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the keyword is passed to the validation function.
# @exitcode 0 If the keyword passes the validation function.
# @exitcode 1 If the keyword fails the validation check.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.fn.keyword.query.is_valid_with() {
  builtin local return_code=0
  builtin local -a kw_source_types
  builtin local validation_source="${2}"
  builtin local validation_source_selection="${3:-value}"
  builtin local keyword_source_var="${STDLIB_KW_SOURCE_VAR}"

  # prevent keyword propagation
  STDLIB_KW_SOURCE_VAR=""

  # shellcheck disable=SC2034
  kw_source_types=("name" "value")

  { [[ "${#@}" -ge "2" ]] && [[ "${#@}" -le "3" ]]; } || builtin return 127

  stdlib.fn.query.is_fn "${1}" || builtin return 126
  stdlib.var.query.is_set "${validation_source}" || builtin return 126
  stdlib.array.query.is_contains "${validation_source_selection}" kw_source_types || builtin return 126

  if ! stdlib.string.query.is_empty "${keyword_source_var}"; then
    stdlib.var.query.is_set "${keyword_source_var}" || builtin return 125 # validates STDLIB_KW_SOURCE_VAR
    validation_source="${keyword_source_var}"
  fi

  if [[ "${validation_source_selection}" == "name" ]]; then
    "${1}" "${validation_source}" || return_code="$?"
  else
    "${1}" "${!validation_source}" || return_code="$?"
  fi

  builtin return "${return_code}"
}
