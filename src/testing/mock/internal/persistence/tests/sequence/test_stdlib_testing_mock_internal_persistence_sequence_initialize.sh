#!/bin/bash

setup() {
  __MOCK_SEQUENCE_TRACKING="0"

  _mock.create _mktemp
  _mock.create _mock.__internal.persistence.sequence.update

  _STDLIB_BINARY_MKTEMP="_mktemp"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists___________does_not_call_mktemp() {
  local __MOCK_SEQUENCE_PERSISTENCE_FILE="mocked_path/mocked_file.txt"
  local __MOCK_REGISTRY="/tmp/mocked/folder"

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_exists___________does_not_call_persistence_update() {
  local __MOCK_SEQUENCE_PERSISTENCE_FILE="mocked_path/mocked_file.txt"
  local __MOCK_REGISTRY="/tmp/mocked/folder"

  _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_not_called
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exists__calls_mktemp() {
  local __MOCK_SEQUENCE_PERSISTENCE_FILE=""
  local __MOCK_REGISTRY="/tmp/mocked/folder"

  _mock.__internal.persistence.sequence.initialize

  _mktemp.mock.assert_called_once_with \
    "1(-p) 2(${__MOCK_REGISTRY})"
}

test_stdlib_testing_mock_internal_persistence_sequence_initialize__persistence_file_does_not_exists__calls_persistence_update() {
  local __MOCK_SEQUENCE_PERSISTENCE_FILE=""
  local __MOCK_REGISTRY="/tmp/mocked/folder"

  _capture.output _mock.__internal.persistence.sequence.initialize

  _mock.__internal.persistence.sequence.update.mock.assert_called_once_with ""
}
