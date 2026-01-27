#!/bin/bash

# stdlib testing mock call component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description Persists a mock call, storing it's arguments as an arg string in the correct persistence file.  If sequence tracking is enabled, the mock will also be added to the sequence persistence file.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN: This boolean determines whether sequence information will be persisted for this call (default="0").
# @arg $@ string The arguments the mock was called with.
# @exitcode 0 If the operation is successful.
# @internal
${1}.mock.__call() {
  builtin local -a _mock_object_args
  builtin local -a _mock_object_call_array

  _mock_object_args=("\${@}")

  _mock.__internal.arg_array.make.from_array \
    _mock_object_call_array \
    _mock_object_args \
    "__${2}_mock_keywords"

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"

  if [[ "\${__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN}" == "1" ]]; then
    _mock.__internal.persistence.sequence.retrieve
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY+=("${1}")
    _mock.__internal.persistence.sequence.update
  fi
}

EOF
)"
