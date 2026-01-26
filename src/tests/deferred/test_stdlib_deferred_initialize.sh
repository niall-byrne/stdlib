#!/bin/bash

setup() {
  test_functions=("test_fn1" "test_fn2")
  _mock.create test_fn3

  _mock.create stdlib.deferred.__defer
}

teardown() {
  unset -f test_fn1 test_fn2
}

# shellcheck disable=SC2034
test_deferred_initialize__creates_deferred_functions() {
  local STDLIB_DEFERRED_FN_ARRAY=("${test_functions[@]}")

  stdlib.deferred.__initialize

  assert_is_fn "test_fn1"
  assert_is_fn "test_fn2"
}

# shellcheck disable=SC2034
test_deferred_initialize__test_fn_is_called_____call_is_deferred() {
  local STDLIB_DEFERRED_FN_ARRAY=("${test_functions[@]}")
  stdlib.deferred.__initialize

  test_fn1 arg1 arg2
  test_fn2 arg3 arg4

  stdlib.deferred.__defer.mock.assert_calls_are \
    "1(test_fn1) 2(arg1) 3(arg2)" \
    "1(test_fn2) 2(arg3) 3(arg4)"
}

# shellcheck disable=SC2034
test_deferred_initialize__regular_fn_is_called__call_is_not_deferred() {
  local STDLIB_DEFERRED_FN_ARRAY=("${test_functions[@]}")
  stdlib.deferred.__initialize

  test_fn3 arg1 arg2

  stdlib.deferred.__defer.mock.assert_not_called
}
