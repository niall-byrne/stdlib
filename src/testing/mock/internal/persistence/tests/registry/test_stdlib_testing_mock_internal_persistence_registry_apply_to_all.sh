#!/bin/bash

mock1.mock.mock_command() {
  echo "command 1"
}

mock2.mock.mock_command() {
  echo "command 2"
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__no_mocks__is_not_applied() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  _capture.stdout _mock.__internal.persistence.registry.apply_to_all "mock_command"

  assert_output_null
}

test_stdlib_testing_mock_internal_persistence_registry_apply_to_all__two_mocks__applies_to_both() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=("mock1" "mock2")

  _capture.stdout _mock.__internal.persistence.registry.apply_to_all "mock_command"

  assert_output "command 1"$'\n'"command 2"
}
