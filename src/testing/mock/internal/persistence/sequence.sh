#!/bin/bash

# stdlib testing mock internal persistence sequence library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME="__stdlib_testing_internal__mock_sequence_lock"
__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""

# @description Clears the persisted sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array reserved: An array containing the sequence of mock calls (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string reserved: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence was cleared.
# @set __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array An array containing the sequence of mock calls.
# @internal
_mock.__internal.persistence.sequence.clear() {
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()      # defaults __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY
  _mock.__internal.persistence.sequence.update # validates __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
}

# @description Initializes the persistence file for the mock call sequence.
#   * __STDLIB_TESTING_MOCK_REGISTRY_FOLDER string reserved: The folder where mock related tracking data is stored during test execution (default="").
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array reserved: An array containing the sequence of mock calls (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string reserved: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence persistence file was initialized.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @stderr The error message if the operation fails.
# @internal
_mock.__internal.persistence.sequence.initialize() {
  if ! _testing.__protected stdlib.io.path.query.is_folder "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}"; then # validates __STDLIB_TESTING_MOCK_REGISTRY_FOLDER
    _testing.__protected stdlib.logger.error "$(_testing.__protected stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTRY_FOLDER))"
    builtin return 123
  fi

  if ! _testing.__protected stdlib.io.path.query.is_file "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"; then               # validates __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
    __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}")" # defaults __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME
    _mock.__internal.persistence.sequence.update                                                                          # defaults __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY
  fi
}

# @description Retrieves the persisted sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string reserved: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence was retrieved.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @set __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array An array containing the sequence of mock calls.
# @internal
_mock.__internal.persistence.sequence.retrieve() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  # clean __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME

  builtin eval "$(${_STDLIB_BINARY_CAT} "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}")"
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY[@]}")
}

# @description Updates the persistence file with the current sequence of mock calls.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY array reserved: An array containing the sequence of mock calls (default=()).
#   * __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME string reserved: The filename containing the persisted sequence of mock calls (default="").
# @noargs
# @exitcode 0 If the sequence persistence file was updated.
# @internal
_mock.__internal.persistence.sequence.update() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  # clean __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME

  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}") # defaults __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY

  builtin declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"
}
