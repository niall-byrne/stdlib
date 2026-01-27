#!/bin/bash

# stdlib testing mock sequence library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"

_mock.sequence.assert_is() {
  # $@: the expected sequence of mock calls

  builtin local -a mock_sequence
  builtin local -a expected_mock_sequence

  expected_mock_sequence=("$@")

  _testing.__assertion.value.check "${@}"

  _mock.sequence.record.stop

  _mock.__internal.persistence.sequence.retrieve
  mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

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

_mock.sequence.clear() {
  _mock.__internal.persistence.sequence.clear
}

_mock.sequence.record.resume() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}

_mock.sequence.record.start() {
  _mock.__internal.persistence.sequence.clear
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}

_mock.sequence.record.stop() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"
}
