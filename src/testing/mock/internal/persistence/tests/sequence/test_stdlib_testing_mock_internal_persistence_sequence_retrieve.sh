#!/bin/bash

setup_suite() {
  mock_persistence_file="$(mktemp)"
}

teardown_suite() {
  rm "${mock_persistence_file}"
}

@parametrize_with_sequences() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_EXISTING_SEQUENCE_DEFINITION;TEST_PERSISTED_SEQUENCE_DEFINITION" \
    "existing_sequence_____existing_definition___;value1|value2;value3|value4" \
    "existing_sequence_____no_existing_definition;value1|value2;;" \
    "no_existing_sequence__existing_definition___;;value1|value2" \
    "no_existing_sequence__no_existing_definition;;;"
}

test_stdlib_testing_mock_internal_persistence_sequence_retrieve__@vary__replaces_sequence_with_persisted_definition() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="${mock_persistence_file}"
  local __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=()

  stdlib.array.make.from_string __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY "|" "${TEST_EXISTING_SEQUENCE_DEFINITION}"
  stdlib.array.make.from_string __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY "|" "${TEST_PERSISTED_SEQUENCE_DEFINITION}"
  declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${mock_persistence_file}"

  _mock.__internal.persistence.sequence.retrieve

  assert_array_equals __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY
}

@parametrize_with_sequences \
  test_stdlib_testing_mock_internal_persistence_sequence_retrieve__@vary__replaces_sequence_with_persisted_definition
