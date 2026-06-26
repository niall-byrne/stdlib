#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.io.path.query.is_folder
  _mock.create stdlib.testing.internal.logger.error
}

test_stdlib_testing_mock_internal_persistence_add_mock__valid_array____valid_registry__registers_the_mock_instance() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  stdlib.array.assert.is_contains "my_mock" "__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY"
}

test_stdlib_testing_mock_internal_persistence_add_mock__valid_array____valid_registry__creates_the_correct_persistence_files() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()
  local calls_file_var="__my_mock_sanitized_mock_calls_file"
  local side_effects_file_var="__my_mock_sanitized_mock_side_effects_file"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  stdlib.io.path.assert.is_file "${!calls_file_var}"
  stdlib.io.path.assert.is_file "${!side_effects_file_var}"
}

test_stdlib_testing_mock_internal_persistence_add_mock__valid_array____valid_registry__returns_status_code___0() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _capture.rc _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  assert_rc "0"
}

# shellcheck disable=SC2178
test_stdlib_testing_mock_internal_persistence_add_mock__invalid_array__valid_registry__returns_status_code_123() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY="aaa"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _capture.rc _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  assert_rc "123"
}

# shellcheck disable=SC2178
test_stdlib_testing_mock_internal_persistence_add_mock__invalid_array__valid_registry__logs_expected_error() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY="aaa"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_ARRAY __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY))"
}

test_stdlib_testing_mock_internal_persistence_add_mock__valid_array__invalid_registry__returns_status_code_123() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1

  _capture.rc _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  assert_rc "123"
}

test_stdlib_testing_mock_internal_persistence_add_mock__valid_array__invalid_registry__logs_expected_error() {
  local __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1

  _mock.__internal.persistence.registry.add_mock "my_mock" "my_mock_sanitized"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get FS_PATH_IS_NOT_A_FOLDER "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}"))" \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTRY_FOLDER))"
}
