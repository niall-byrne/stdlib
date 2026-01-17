#!/bin/bash

# stdlib trap handler create library

builtin set -eo pipefail

# @description Creates a cleanup function that removes files and directories.
# @arg {string} fn_name The name of the cleanup function to create.
# @arg {string} array_name The name of the array used for tracking filesystem objects to clean up.
# @arg {boolean} [recursive=false] A boolean indicating if recursive deletes should be done.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.trap.create.clean_up_fn() {
  builtin local rm_flags="-f"
  builtin local recursive_deletes="${3:-0}"

  stdlib.fn.args.require "2" "1" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126
  stdlib.string.assert.is_boolean "${recursive_deletes}" || builtin return 126

  if (("${recursive_deletes}")); then
    rm_flags+="r"
  fi

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

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
  # KCOV_EXCLUDE_END
}

# @description Creates a trap handler function and a corresponding register function.
# @arg $1 The name of the handler function to create.
# @arg $2 The name of the array to store handler function names in.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments is provided.
stdlib.trap.create.handler() {
  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.array.assert.is_array "${2}" || builtin return 126

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

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
  # KCOV_EXCLUDE_END
}
