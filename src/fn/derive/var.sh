#!/bin/bash

# stdlib fn derive var library

builtin set -eo pipefail

# @description Creates a version of a function that accepts a variable name as an argument.
# @arg $1 string The name of the source function.
# @arg $2 string (optional, default="${1}_var") The name of the new target function.
# @arg $3 integer (optional, default="-1") The argument index for the variable's existing value.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
stdlib.fn.derive.var() {
  builtin local -a args_with_defaults
  builtin local derive_source_fn_name="${1}"
  builtin local derive_target_fn_name
  builtin local derive_argument_index="${3:-"-1"}"

  args_with_defaults=("$@")

  derive_target_fn_name="${2:-"${derive_source_fn_name}_var"}"

  args_with_defaults[1]="${derive_target_fn_name}"
  args_with_defaults[2]="${derive_argument_index}"

  stdlib.fn.args.require "3" "0" "${args_with_defaults[@]}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.fn.assert.is_valid_name "${derive_target_fn_name}" || builtin return 126
  stdlib.string.assert.is_integer "${derive_argument_index}" || builtin return 126
  stdlib.string.assert.not_equal "0" "${derive_argument_index}" || builtin return 126

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${derive_target_fn_name}() {
  # \${@} the args to pass to the source function, plus the variable name

  builtin local fn_argument_index
  builtin local fn_argument_index_variable_name="${derive_argument_index}"
  builtin local -a fn_arguments
  builtin local fn_variable_name=""

  stdlib.fn.args.require "1" "1000" "\${@}" || builtin return "\$?"

  if [[ "${derive_argument_index}" -lt "0" ]]; then
    fn_argument_index_variable_name="\$(("\${#@}" + 1 + "${derive_argument_index}"))"
  fi

  for ((fn_argument_index=1; fn_argument_index <= "\${#@}"; fn_argument_index+=1)); do
    if (("\${fn_argument_index}" == "\${fn_argument_index_variable_name}")); then
      fn_variable_name="\${!fn_argument_index}"
      fn_arguments+=("\${!fn_variable_name}")
    else
      fn_arguments+=("\${!fn_argument_index}")
    fi
  done

  builtin printf -v "\${fn_variable_name}" "%s" "\$("${derive_source_fn_name}" "\${fn_arguments[@]}")"
}

EOF
  )"
  # KCOV_EXCLUDE_END
}
