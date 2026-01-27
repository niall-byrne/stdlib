#!/bin/bash

# stdlib testing mock internal persistence sequence library

builtin set -eo pipefail

# @description Clears the persisted sequence of mock calls.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.sequence.clear() {
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  _mock.__internal.persistence.sequence.update
}

# @description Initializes the persistence file for the mock call sequence.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.sequence.initialize() {
  if [[ -z "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}" ]]; then
    __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
    _mock.__internal.persistence.sequence.update
  fi
}

# @description Retrieves the persisted sequence of mock calls.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.sequence.retrieve() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  builtin eval "$(${_STDLIB_BINARY_CAT} "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}")"
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY[@]}")
}

# @description Updates the persistence file with the current sequence of mock calls.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.sequence.update() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  builtin declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"
}
