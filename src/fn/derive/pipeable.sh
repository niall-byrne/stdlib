#!/bin/bash

# stdlib fn derive pipeable library

builtin set -eo pipefail

STDIN_SOURCE_SPECIFIER="${STDIN_SOURCE_SPECIFIER:-""}"

# @description Creates a pipeable version of an existing function.
#   * STDIN_SOURCE_SPECIFIER: A string used to specify the position of stdin in the arguments (default='-').
# @arg $1 string The name of the function to make pipeable.
# @arg $2 integer The number of arguments the function requires.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.fn.derive.pipeable() {
  builtin local derive_target_fn_name
  builtin local stdin_source_specifier="${STDIN_SOURCE_SPECIFIER:-"-"}"

  stdlib.fn.args.require "2" "0" "${@}" || builtin return "$?"
  stdlib.fn.assert.is_fn "${1}" || builtin return 126
  stdlib.string.assert.is_digit "${2}" || builtin return 126

  derive_target_fn_name="${1}"

  builtin eval "$(
    # KCOV_EXCLUDE_BEGIN
    "${_STDLIB_BINARY_CAT}" << EOF

${derive_target_fn_name}_pipe() {
  # \${@ 0:-2} the args to use
  # \${@ -1} the optional input string to operate on
  # NOTE: the position of stdin can also be specified with the arg "-"

  # mutate_pipe_parser_strategy
  #   ARGS_SPECIFIED:   the already specified arguments are sufficient to call the function
  #   STDIN_POSITIONAL: the user specified that an argument is explicitly from stdin
  #   STDIN_ASSUMED:    there are not enough arguments and no known position for stdin, append stdin

  builtin local mutate_examined_arg=""
  builtin local mutate_examined_arg_index=0
  builtin local mutate_pipe_input=""
  builtin local mutate_pipe_input_index=0
  builtin local mutate_pipe_input_line=''
  builtin local mutate_pipe_parser_strategy="ARG_SPECIFIED"
  builtin local -a mutate_received_args

  mutate_received_args=("\$@")

  # Append stdin strategy
  if [[ "\${#@}" -lt "${2}" ]]; then
    mutate_pipe_parser_strategy="STDIN_ASSUMED"
    mutate_pipe_input_index="\$(("\${#@}" + 1))"
  fi

  # Replace placeholder stdin strategy
  if [[ "\${mutate_pipe_parser_strategy}" == "ARG_SPECIFIED" ]]; then
    for mutate_examined_arg in "\${@}"; do
      if [[ "\${mutate_examined_arg}" == "${stdin_source_specifier}" ]]; then
        mutate_pipe_parser_strategy="STDIN_POSITIONAL"
        mutate_pipe_input_index="\${mutate_examined_arg_index}"
        builtin break
      fi
      ((mutate_examined_arg_index+=1))
    done
  fi

  # Does the current strategy require stdin ?
  if [[ "\${mutate_pipe_parser_strategy}" != "ARG_SPECIFIED" ]]; then
    while IFS= builtin read -r mutate_pipe_input_line; do
      mutate_pipe_input+="\${mutate_pipe_input_line}"
      mutate_pipe_input+=$'\n'
    done
    mutate_pipe_input="\${mutate_pipe_input%?}"
    mutate_received_args[mutate_pipe_input_index]="\${mutate_pipe_input}"
  fi

  "${derive_target_fn_name}" "\${mutate_received_args[@]}"
}
EOF
  )"
  # KCOV_EXCLUDE_END
}
