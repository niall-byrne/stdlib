#!/bin/bash

# stdlib testing mock sequence library

builtin set -eo pipefail

__MOCK_SEQUENCE=()
__MOCK_SEQUENCE_TRACKING="0"

_mock.sequence.assert_is() {
  # $@: the expected sequence of mock calls

  builtin local -a mock_sequence
  builtin local -a expected_mock_sequence

  expected_mock_sequence=("$@")

  _testing.__assertion.value.check "${@}"

  _mock.sequence.record.stop

  _mock.__internal.persistence.sequence.retrieve
  mock_sequence=("${__MOCK_SEQUENCE[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.assert_is_empty() {

  builtin local -a mock_sequence
  # shellcheck disable=SC2034
  builtin local -a expected_mock_sequence

  _mock.sequence.record.stop

  _mock.__internal.persistence.sequence.retrieve
  # shellcheck disable=SC2034
  mock_sequence=("${__MOCK_SEQUENCE[@]}")

  assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.clear() {
  _mock.__internal.persistence.sequence.clear
}

_mock.sequence.record.start() {
  _mock.__internal.persistence.sequence.clear
  __MOCK_SEQUENCE_TRACKING="1"
}

_mock.sequence.record.stop() {
  __MOCK_SEQUENCE_TRACKING="0"
}

_mock.sequence.record.resume() {
  __MOCK_SEQUENCE_TRACKING="1"
}
