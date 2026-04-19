#!/bin/bash

setup() {
  _mock.create test_mock_1
  _mock.create test_mock_2
  _mock.create test_mock_3 
}

test_stdlib_testing_mock_object_call__with_concurrency__captures_all_calls_correctly() {
  local actual_calls=()
  local index_call
  local index_mock

  test_mock_1.mock.set.subcommand "sleep 0.1"
  test_mock_2.mock.set.subcommand "sleep 0.2"
  test_mock_3.mock.set.subcommand "sleep 0.3"

  for index_call in {1..100}; do
    test_mock_1 "${index_call}" &
    test_mock_2 "${index_call}" &
    test_mock_3 "${index_call}" &    
  done

  for index_mock in {1..3}; do
    stdlib.array.make.from_string actual_calls $'\n' "$(test_mock_${index_mock}.mock.get.calls)"
    
    assert_equals "${#actual_calls[@]}" "100"

    for index_call in {1..100}; do
      stdlib.array.assert.is_contains "1(${index_call})" actual_calls
    done    
  done
}

test_stdlib_testing_mock_object_call__with_concurrency__captures_sequence_correctly() {
  local actual_calls=()
  local index_call
  local index_mock
  local expected_calls=()

  for index_call in {1..100}; do
    expected_calls+=("1($index_call)")
  done

  _mock.sequence.record.start
 
  for index_call in {1..100}; do
    test_mock_1 "${index_call}" &
    test_mock_2 "${index_call}" &
    test_mock_3 "${index_call}" &    
  done

   _mock.sequence.record.stop

   #mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

   assert_equals "${#mock_sequence[@]}" "300"
}