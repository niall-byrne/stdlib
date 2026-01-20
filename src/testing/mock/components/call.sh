#!/bin/bash

# stdlib testing mock calls component

builtin set -eo pipefail

builtin export CONTENT

# shellcheck disable=SC2034
CONTENT="$(
  "${_STDLIB_BINARY_CAT}" << EOF
${1}.mock.__call() {
  # $@: the arguments the mock was called with

  builtin local -a _mock_object_args
  builtin local -a _mock_object_call_array

  _mock_object_args=("\${@}")

  _mock.__internal.arg_array.make.from_array \
    _mock_object_call_array \
    _mock_object_args \
    "__${2}_mock_keywords"

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"

  if [[ "\${__MOCK_SEQUENCE_TRACKING}" == "1" ]]; then
    _mock.__internal.persistence.sequence.retrieve
    __MOCK_SEQUENCE+=("${1}")
    _mock.__internal.persistence.sequence.update
  fi
}
EOF
)"
