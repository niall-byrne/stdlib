#!/bin/bash

# stdlib testing mock internal persistence sequence library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME="__stdlib_testing_internal__mock_sequence_lock"
__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""

# @description Clears the persisted sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array global: An array containing the sequence of mock class (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string global: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence was cleared.
# @set __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array The sequence of mock calls.
# @internal
_mock.__internal.persistence.sequence.clear() {
  # clean __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY,__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  _mock.__internal.persistence.sequence.update
}

# @description Initializes the persistence file for the mock call sequence.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array global: An array containing the sequence of mock class (default=()).
#   * __STDLIB_TESTING_MOCK_REGISTRY_FOLDER string global: The folder where mock related tracking data is stored during test execution (default="").
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string global: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence persistence file was initialized.
# @internal
_mock.__internal.persistence.sequence.initialize() {
  # clean __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY,__STDLIB_TESTING_MOCK_REGISTRY_FOLDER,__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
  if [[ -z "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}" ]]; then
    __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}")"
    _mock.__internal.persistence.sequence.update
  fi
}

# @description Retrieves the persisted sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string global: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence was retrieved.
# @set __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array The sequence of mock calls.
# @internal
_mock.__internal.persistence.sequence.retrieve() {
  # clean __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  builtin eval "$(${_STDLIB_BINARY_CAT} "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}")"
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY[@]}")
}

# @description Updates the persistence file with the current sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array global: An array containing the sequence of mock class (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string global: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence persistence file was updated.
# @internal
_mock.__internal.persistence.sequence.update() {
  # clean __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY,__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  builtin declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"
}
