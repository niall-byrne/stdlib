#!/bin/bash

setup() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"

  _mock.create _mock.__internal.persistence.sequence.update
}

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION" \
    "existing_sequence___;value1|value2" \
    "no_existing_sequence;;"
}

# shellcheck disable=SC2034
test_stdlib_testing_mock_internal_persistence_sequence_clear__@vary__clears_array() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  local empty_array=()

  stdlib.array.make.from_string __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  _mock.__internal.persistence.sequence.clear

  assert_array_equals empty_array __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_internal_persistence_sequence_clear__@vary__clears_array

test_stdlib_testing_mock_internal_persistence_sequence_clear__@vary__calls_mocked_persistence_update() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()

  stdlib.array.make.from_string __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  _mock.__internal.persistence.sequence.clear

  _mock.__internal.persistence.sequence.update.mock.assert_called_once_with ""
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_internal_persistence_sequence_clear__@vary__calls_mocked_persistence_update
