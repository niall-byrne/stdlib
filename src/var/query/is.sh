#!/bin/bash

# stdlib var query is library

builtin set -eo pipefail

STDLIB_VALIDATION_SOURCE_VAR=""

# @description Checks if a variable is an empty value (unset variables, empty arrays, empty associative arrays, empty strings and empty integers).
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is an empty value.
# @exitcode 1 If the variable is not an empty value.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_empty() {
  builtin local variable_declaration

  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.var.query.is_valid_name "${1}" || builtin return 126

  variable_declaration="$(builtin declare -p "${1}" 2> /dev/null)" || builtin return 0

  case "${variable_declaration}" in
    # 1. Empty arrays
    *"-a "*"=()" | *"-a ${1}") # KCOV_EXCLUDE_LINE
      builtin return 0
      ;;
    # 2. Empty associative arrays.
    *"-A "*"=()" | *"-A ${1}") # KCOV_EXCLUDE_LINE
      builtin return 0
      ;;
    # 3. Populated arrays and associative arrays.
    *"-a "* | *"-A "*)
      builtin return 1
      ;;
    # 4. Scalar strings, integers, or other types.
    *)
      [[ -z "${!1}" ]] && builtin return 0
      builtin return 1
      ;;
  esac
}

# @description Checks if a variable is set.
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is set.
# @exitcode 1 If the variable is not set.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_set() {
  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.var.query.is_valid_name "${1}" || builtin return 126

  if ! builtin declare -p "${1}" > /dev/null 2>&1; then
    builtin return 1
  fi
  builtin return 0
}

# @description Checks if a string is a valid variable name.
# @arg $1 string The string to check.
# @exitcode 0 If the string is a valid variable name.
# @exitcode 1 If the string is not a valid variable name.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_valid_name() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  # shellcheck disable=SC1001
  case "${1}" in
    *[!A-Za-z0-9_]*)
      builtin return 1
      ;;
    *)
      builtin return 0
      ;;
  esac
}

# @description Checks if a variable's value is valid against a validation function.
#   * STDLIB_VALIDATION_SOURCE_VAR string keyword: An optional variable name that can be used as a source for validation (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the variable containing the value to perform validation on.
# @arg $3 string (optional, default="value") Controls whether the 'name' or 'value' of the variable is passed to the validation function.
# @exitcode 0 If the variable passes the validation function.
# @exitcode 1 If the variable fails the validation check.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_valid_with() {
  builtin local return_code=0
  builtin local validate_default_value="${STDLIB_VALIDATION_SOURCE_VAR}"
  builtin local validation_source="${2}"
  builtin local validation_source_selection="${3:-value}"
  builtin local -a var_source_types

  # shellcheck disable=SC2034
  var_source_types=("name" "value")

  { [[ "${#@}" -ge "2" ]] && [[ "${#@}" -le "3" ]]; } || builtin return 127

  stdlib.fn.query.is_fn "${1}" || builtin return 126
  stdlib.var.query.is_valid_name "${2}" || builtin return 126
  stdlib.array.query.is_contains "${validation_source_selection}" var_source_types || builtin return 126

  if [[ -n "${validate_default_value}" ]]; then
    stdlib.var.query.is_set "${validate_default_value}" || builtin return 125 # validates STDLIB_VALIDATION_SOURCE_VAR
    validation_source="${validate_default_value}"
  fi

  if [[ "${validation_source_selection}" == "name" ]]; then
    "${1}" "${validation_source}" || return_code="$?"
  else
    "${1}" "${!validation_source}" || return_code="$?"
  fi

  builtin return "${return_code}"
}
