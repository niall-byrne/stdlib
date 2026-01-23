#!/bin/bash

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION" \
    "existing_sequence___;value1|value2" \
    "no_existing_sequence;;"
}

test_stdlib_testing_mock_internal_persistence_sequence_update__@vary__outputs_array_definition_to_persistence_file() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="/dev/stderr"
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  stdlib.array.make.from_string __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"

  _capture.stderr _mock.__internal.persistence.sequence.update

  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")
  assert_output "$(declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY)"
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_internal_persistence_sequence_update__@vary__outputs_array_definition_to_persistence_file
