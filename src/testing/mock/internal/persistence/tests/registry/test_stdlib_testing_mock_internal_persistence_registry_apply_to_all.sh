#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

mock1.mock.mock_command() {
  echo "command 1"
}

mock2.mock.mock_command() {
  echo "command 2"
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__no_mocks_______is_not_applied() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  _capture.stdout _mock.__internal.persistence.registry.apply_to_all "mock_command"

  assert_output_null
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__no_mocks_______returns_status_code___0() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  _capture.rc _mock.__internal.persistence.registry.apply_to_all "mock_command" > /dev/null

  assert_rc "0"
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__two_mocks______applies_to_both() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=("mock1" "mock2")

  _capture.stdout _mock.__internal.persistence.registry.apply_to_all "mock_command"

  assert_output "command 1"$'\n'"command 2"
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__two_mocks______returns_status_code___0() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=("mock1" "mock2")

  _capture.rc _mock.__internal.persistence.registry.apply_to_all "mock_command" > /dev/null

  assert_rc "0"
}

# shellcheck disable=SC2178
test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__invalid_array__return_status_code_123() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY="aaa"

  _capture.rc _mock.__internal.persistence.registry.apply_to_all "mock_command"

  assert_rc "123"
}

# shellcheck disable=SC2178
test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__invalid_array__logs_expected_error() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY="aaa"

  _mock.__internal.persistence.registry.apply_to_all "mock_command"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY))"
}
