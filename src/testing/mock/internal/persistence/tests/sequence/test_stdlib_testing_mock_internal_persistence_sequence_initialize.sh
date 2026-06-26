#!/bin/bash

setup() {
  __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"

  _mock.create _mktemp
  _mock.create _mock.__internal.persistence.sequence.update
  _mock.create stdlib.testing.internal.logger.error
  _mock.create stdlib.testing.internal.io.path.query.is_folder
  _mock.create stdlib.testing.internal.io.path.query.is_file

  _STDLIB_BINARY_MKTEMP="_mktemp"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________valid_folder____does_not_call_mktemp() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________valid_folder____does_not_call_persistence_update() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________valid_folder____returns_status_code___0() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _capture.rc _mock.__internal.persistence.sequence.initialize

  assert_rc "0"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__valid_folder____calls_mktemp() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_called_once_with \
    "1(-p) 2(${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER})"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__valid_folder____calls_persistence_update() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _capture.output _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_called_once_with ""
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__valid_folder____returns_status_code___0() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="/tmp/mocked/folder"

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _capture.rc _mock.__internal.persistence.sequence.initialize

  assert_rc "0"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________invalid_folder__does_not_call_mktemp() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__invalid_folder__does_not_call_mktemp() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________invalid_folder__does_not_call_persistence_update() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__invalid_folder__does_not_call_persistence_update() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__invalid_folder__returns_status_code_123() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _capture.rc _mock.__internal.persistence.sequence.initialize

  assert_rc "123"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________invalid_folder__returns_status_code_123() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _capture.rc _mock.__internal.persistence.sequence.initialize

  assert_rc "123"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exist__invalid_folder__logs_error_message() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="mocked_path/mocked_file.txt"
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 0

  _mock.__internal.persistence.sequence.initialize

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTRY_FOLDER)))"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists__________invalid_folder__logs_error_message() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
  local __STDLIB_TESTING_MOCK_REGISTRY_FOLDER=""

  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1
  stdlib.testing.internal.io.path.query.is_file.mock.set.rc 1

  _capture.rc _mock.__internal.persistence.sequence.initialize

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL __STDLIB_TESTING_MOCK_REGISTRY_FOLDER)))"
}
