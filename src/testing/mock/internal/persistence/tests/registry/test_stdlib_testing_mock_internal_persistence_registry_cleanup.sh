#!/bin/bash

setup() {
  _mock.create rm
  _mock.create stdlib.testing.internal.io.path.query.is_folder
}

test_stdlib_testing_mock_internal_persistence_registry_cleanup__registry_exists__________calls_rm_as_expected() {
  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 0

  _STDLIB_BINARY_RM="rm" __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="test_registry" \
    _mock.__internal.persistence.registry.cleanup

  rm.mock.assert_called_once_with "1(-rf) 2(test_registry)"
}

test_stdlib_testing_mock_internal_persistence_registry_cleanup__registry_does_not_exist__does_not_call_rm() {
  stdlib.testing.internal.io.path.query.is_folder.mock.set.rc 1

  _STDLIB_BINARY_RM="rm" __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="test_registry" \
    _mock.__internal.persistence.registry.cleanup

  rm.mock.assert_not_called
}
