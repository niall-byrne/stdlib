#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create mock_deferred_fn1
  _mock.create mock_deferred_fn2
}

test_stdlib_deferred_execute__calls_registered_fn() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=("mock_deferred_fn1" "mock_deferred_fn2")

  stdlib.deferred.__execute

  mock_deferred_fn1.mock.assert_called_once_with ""
  mock_deferred_fn2.mock.assert_called_once_with ""
}

test_stdlib_deferred_execute__unsets_registered_fn() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=("mock_deferred_fn1" "mock_deferred_fn2")

  stdlib.deferred.__execute

  assert_not_fn "mock_deferred_fn1"
  assert_not_fn "mock_deferred_fn2"
}

test_stdlib_deferred_execute__resets_stdlib_deferred_fn_array() {
  local STDLIB_DEFERRED_FN_ARRAY=("mock_fn1" "mock_fn2" "mock_fn3")
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=("mock_deferred_fn1" "mock_deferred_fn2")

  stdlib.deferred.__execute

  assert_array_length 0 STDLIB_DEFERRED_FN_ARRAY
}

test_stdlib_deferred_execute__resets_stdlib_deferred_fn_calls_array() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=("mock_deferred_fn1" "mock_deferred_fn2")

  stdlib.deferred.__execute

  assert_array_length 0 STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY
}
