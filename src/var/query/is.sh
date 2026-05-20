#!/bin/bash

# stdlib var query is library

builtin set -eo pipefail

STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN=""
STDLIB_VAR_VALIDATE_DEFAULT_VAR=""

# @description Checks if a variable is set to an empty string (null value).
# @arg $1 string The name of the variable to check.
# @exitcode 0 If the variable is set.
# @exitcode 1 If the variable is not set.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_empty() {
  [[ "${#@}" == "1" ]] || builtin return 127
  stdlib.var.query.is_set "${1}" || builtin return 126
  [[ -z "${!1}" ]]
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
#   * STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN: A boolean value that controls whether the variable's name (instead of value) is passed to the validation function (default=0).
#   * STDLIB_VAR_VALIDATE_DEFAULT_VAR: An optional variable name that can be used as a default source if the given variable is empty or unset (default="").
# @arg $1 string The validation function to run.
# @arg $2 string The name of the variable containing the value to perform validation on.
# @exitcode 0 If the variable passes the validation function.
# @exitcode 1 If the variable fails the validation check.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.var.query.is_valid_with() {
  builtin local return_code=0
  builtin local validate_by_name_boolean="${STDLIB_VAR_VALIDATE_BY_NAME_BOOLEAN:-0}"
  builtin local validate_default_value="${STDLIB_VAR_VALIDATE_DEFAULT_VAR}"
  builtin local value_source="${2}"

  [[ "${#@}" == "2" ]] || builtin return 127

  stdlib.fn.query.is_fn "${1}" || builtin return 126
  stdlib.var.query.is_valid_name "${2}" || builtin return 126
  stdlib.string.query.is_boolean "${validate_by_name_boolean}" || builtin return 126

  if [[ -n "${validate_default_value}" ]]; then
    stdlib.var.query.is_set "${validate_default_value}" || builtin return 126
    value_source="${validate_default_value}"
  fi

  if [[ "${validate_by_name_boolean}" -eq 1 ]]; then
    "${1}" "${value_source}" || return_code="$?"
  else
    "${1}" "${!value_source:-!validate_default_value}" || return_code="$?"
  fi

  builtin return "${return_code}"
}
