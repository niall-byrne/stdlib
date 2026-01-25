#!/bin/bash
# shellcheck disable=SC2086

eval "$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
${1}.missing_description() {
  builtin echo "hello"
}

EOF
)"
