#!/bin/bash

# stdlib testing mock sequence library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"

# @description Asserts that the sequence of mock calls matches the expected sequence.
# @arg $@ array The expected sequence of mock calls.
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
_mock.sequence.assert_is() {
  builtin local -a mock_sequence
  builtin local -a expected_mock_sequence

  expected_mock_sequence=("$@")

  _testing.__assertion.value.check "${@}"

  _mock.sequence.record.stop

  _mock.__internal.persistence.sequence.retrieve
  mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

# @description Asserts that no mock calls have been recorded in the sequence.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stderr The error message if the assertion fails.
_mock.sequence.assert_is_empty() {
  builtin local -a mock_sequence
  # shellcheck disable=SC2034
  builtin local -a expected_mock_sequence

  _mock.sequence.record.stop

  _mock.__internal.persistence.sequence.retrieve
  # shellcheck disable=SC2034
  mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

# @description Clears the recorded sequence of mock calls.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.sequence.clear() {
  _mock.__internal.persistence.sequence.clear
}

# @description Starts recording mock calls into a new sequence.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.sequence.record.start() {
  _mock.__internal.persistence.sequence.clear
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}

# @description Stops recording mock calls into the sequence.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.sequence.record.stop() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"
}

# @description Resumes recording mock calls into the existing sequence.
# @noargs
# @exitcode 0 If the operation succeeded.
_mock.sequence.record.resume() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}
