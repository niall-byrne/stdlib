#!/bin/bash

# @description This is a valid function.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout The message "hello".
stdlib.valid() {
  builtin echo "hello"
}

eval "$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description This is a valid function.
#   * __${2}_mock_global_variable: The greeting message for this function to emit (default="").
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout The configured greeting message.
${1}.also_valid() {

  builtin echo "__${2}_mock_global_variable"
}

EOF
)"
