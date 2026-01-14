#!/bin/bash

setup() {
  _mock.create __testing.protect_stdlib
  _mock.create __mock.persistence.registry.create
  _mock.create __mock.persistence.sequence.initialize
}

_fixture_load_module() {
  _testing.load "${STDLIB_DIRECTORY}/testing/mock/mock.snippet" > /dev/null
}

test_stdlib_testing_mock_snippet__sourced__protects_stdlib() {
  _fixture_load_module

  __testing.protect_stdlib.mock.assert_called_once_with ""
}

test_stdlib_testing_mock_snippet__sourced__creates_registry_persistence() {
  _fixture_load_module

  __mock.persistence.registry.create.mock.assert_called_once_with ""
}

test_stdlib_testing_mock_snippet__sourced__creates_sequence_persistence() {
  _fixture_load_module

  __mock.persistence.sequence.initialize.mock.assert_called_once_with ""
}
