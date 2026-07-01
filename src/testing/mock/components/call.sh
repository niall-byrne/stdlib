#!/bin/bash

# stdlib testing mock call component

builtin set -eo pipefail

builtin export __STDLIB_TESTING_MOCK_COMPONENT

# shellcheck disable=SC2034
__STDLIB_TESTING_MOCK_COMPONENT="$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description Persists a mock call, storing it's arguments as an arg string in the correct persistence file.  If sequence tracking is enabled, the mock will also be added to the sequence persistence file.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array reserved: An array containing the sequence of mock calls (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME string reserved: This string identifies the lock file used to control locking during sequence tracking (default="__stdlib_testing_internal__mock_sequence_lock").
#   * __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN string reserved: This boolean determines whether sequence information will be persisted for this call (default="0").
# @arg $@ string The arguments the mock was called with.
# @exitcode 0 If the mock's call was persisted successfully.
# @internal
${1}.mock.__call() {
  builtin local -a _mock_object_args
  builtin local -a _mock_object_call_array

  # clean __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY

  _mock_object_args=("\${@}")

  _mock.__internal.arg_array.make.from_array \
    _mock_object_call_array \
    _mock_object_args \
    "__${2}_mock_keywords"  # noqa

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"  # noqa

  if [[ "\${__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN}" == "1" ]]; then  # validates __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN
    _testing.__protected stdlib.io.lock.acquire "${__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME}"  # validates __STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME
    _mock.__internal.persistence.sequence.retrieve
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY+=("${1}")
    _mock.__internal.persistence.sequence.update
    _testing.__protected stdlib.io.lock.release "${__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME}"
  fi
}

EOF
)"
