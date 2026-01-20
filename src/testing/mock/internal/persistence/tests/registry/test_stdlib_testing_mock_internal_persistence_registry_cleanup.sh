#!/bin/bash

setup() {
  _mock.create rm
}

test_stdlib_testing_mock_internal_persistence_registry_cleanup__registry_exists__________calls_rm_as_expected() {
  _STDLIB_BINARY_RM="rm" __MOCK_REGISTRY="test_registry" \
    _mock.__internal.persistence.registry.cleanup

  rm.mock.assert_called_once_with "1(-rf) 2(test_registry)"
}

test_stdlib_testing_mock_internal_persistence_registry_cleanup__registry_does_not_exist__does_not_call_rm() {
  _STDLIB_BINARY_RM="rm" __MOCK_REGISTRY="" \
    _mock.__internal.persistence.registry.cleanup

  rm.mock.assert_not_called
}
