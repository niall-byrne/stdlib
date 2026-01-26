#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create underlying_fn1
  _mock.create underlying_fn2
}

_fixture_single_call() {
  stdlib.deferred.__defer "underlying_fn1" "arg1" "arg2"
}

_fixture_two_calls() {
  _fixture_single_call
  stdlib.deferred.__defer "underlying_fn2" "arg3" "arg4"
}

test_deferred_defer__single_call__creates_expected_function() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()

  _fixture_single_call

  assert_is_fn "stdlib.__deferred.call.0"
}

test_deferred_defer__single_call__registers_deferred_call() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
  local expected_calls=("stdlib.__deferred.call.0")

  _fixture_single_call

  assert_array_equals expected_calls STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY
}

test_deferred_defer__single_call__deferred_fn_is_called_______calls_original_fn() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
  _fixture_single_call

  stdlib.__deferred.call.0

  underlying_fn1.mock.assert_called_once_with \
    "1(arg1) 2(arg2)"
}

test_deferred_defer__two_calls____creates_expected_functions() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
  _fixture_two_calls

  assert_is_fn "stdlib.__deferred.call.0"
  assert_is_fn "stdlib.__deferred.call.1"
}

test_deferred_defer__two_calls____registers_deferred_call() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
  local expected_calls=("stdlib.__deferred.call.0" "stdlib.__deferred.call.1")

  _fixture_two_calls

  assert_array_equals expected_calls STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY
}

test_deferred_defer__two_calls____deferred_fns_is_called_____calls_original_fns() {
  local STDLIB_DEFERRED_FN_ARRAY_CALLS_ARRAY=()
  _fixture_two_calls

  stdlib.__deferred.call.0
  stdlib.__deferred.call.1

  underlying_fn1.mock.assert_called_once_with \
    "1(arg1) 2(arg2)"
  underlying_fn2.mock.assert_called_once_with \
    "1(arg3) 2(arg4)"
}
