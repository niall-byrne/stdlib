#!/bin/bash

setup() {
  _mock.create mktemp
  mktemp.mock.set.stdout "mocked_temp_directory"
  _mock.create stdlib.testing.internal.io.path.query.is_folder
}

test_stdlib_testing_mock_internal_persistence_registry_create__existing_registry_____does_not_call_mktemp() {
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="existing_value"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _STDLIB_BINARY_MKTEMP="mktemp" \
    _mock.__internal.persistence.registry.create

  mktemp.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_registry_create__existing_registry_____does_not_change_variable() {
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="existing_value"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _STDLIB_BINARY_MKTEMP="mktemp" \
    _mock.__internal.persistence.registry.create

  assert_equals "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}" "existing_value"
}

test_stdlib_testing_mock_internal_persistence_registry_create__no_existing_registry__calls_mktemp_as_expected() {
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1

  _STDLIB_BINARY_MKTEMP="mktemp" \
    _mock.__internal.persistence.registry.create

  mktemp.mock.assert_called_once_with "1(-d)"
}

test_stdlib_testing_mock_internal_persistence_registry_create__no_existing_registry__sets_registry_variable() {
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1

  _STDLIB_BINARY_MKTEMP="mktemp" \
    _mock.__internal.persistence.registry.create

  assert_equals "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}" "mocked_temp_directory"
}
