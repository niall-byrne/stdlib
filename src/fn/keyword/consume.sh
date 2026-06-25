#!/bin/bash

# stdlib fn keyword consume library

builtin set -eo pipefail

# @description Consumes a scalar keyword, using a default value if required, (the keyword is also reset to "" so it's value can't propagate).
# @arg $1 string The name of the scalar variable to assign, usually this is a locally scoped scalar variable.
# @arg $1 string The name of the scalar keyword variable to consume.
# @arg $2 string (optional, default="") A string representation of a default value to use if the scalar keyword variable is empty or unset.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The calculated value.
# @stderr The error message if the operation fails.
stdlib.fn.keyword.consume() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local default_value="${3}"
  builtin local keyword_variable="${2}"
  builtin local output_variable="${1}"

  # shellcheck disable=SC2034
  STDLIB_ARGS_NULL_SAFE_ARRAY=("3")

  stdlib.fn.args.require "2" "1" "${@}" || builtin return "$?"
  stdlib.var.assert.is_valid_name "${output_variable}" || builtin return 126
  stdlib.var.assert.is_set "${keyword_variable}" || builtin return 126

  if stdlib.var.query.is_empty "${keyword_variable}" &&
    stdlib.string.query.not_empty "${default_value}"; then
    builtin printf -v "${output_variable}" "%s" "${default_value}"
  else
    builtin printf -v "${output_variable}" "%s" "${!keyword_variable}"
  fi

  builtin printf -v "${keyword_variable}" "%s" ""
}

# @description Consumes an array keyword, using a default array's contents if required, (the keyword is also reset to () so it's value can't propagate).
# @arg $1 string The name of the array to assign, usually this is a locally scoped array.
# @arg $2 string The name of the array keyword variable to consume.
# @arg $3 string (optional, default="") A name of another array containing a default value to use if the keyword is empty or unset.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.fn.keyword.consume_array() {
  builtin local -a indirect_array
  builtin local default_value="${3}"
  builtin local indirect_reference
  builtin local keyword_variable="${2}"
  builtin local output_variable="${1}"

  stdlib.fn.args.require "2" "1" "${@}" || builtin return "$?"
  stdlib.var.assert.is_valid_name "${output_variable}" || builtin return 126

  if stdlib.var.query.is_set "${keyword_variable}"; then
    stdlib.array.assert.is_array "${keyword_variable}" || builtin return 126
  fi
  if stdlib.string.query.not_empty "${default_value}"; then
    stdlib.array.assert.is_array "${default_value}" || builtin return 126
  fi

  if stdlib.var.query.is_empty "${keyword_variable}" &&
    stdlib.string.query.not_empty "${default_value}"; then
    indirect_reference="${default_value}[@]"
  else
    stdlib.array.assert.is_array "${keyword_variable}" || builtin return 126
    indirect_reference="${keyword_variable}[@]"
  fi

  indirect_array=("${!indirect_reference}")

  if [[ "${#indirect_array[@]}" == 0 ]]; then
    builtin eval "${output_variable}=()"
  else
    builtin eval "${output_variable}=($(builtin printf '%q ' "${indirect_array[@]}"))"
  fi

  if stdlib.var.query.is_set "${keyword_variable}"; then
    builtin eval "${keyword_variable}=()"
  fi
}
