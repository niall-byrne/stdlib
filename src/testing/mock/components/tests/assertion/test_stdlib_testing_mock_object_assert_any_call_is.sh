#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create stdlib.testing.internal.logger.error
  stdlib.testing.internal.logger.error.mock.set.keywords "STDLIB_ARGS_CALLER_FN_NAME"
  keyword1="value1"
  keyword2="value2"
}

@parametrize_with_invalid_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_MESSAGE_ARG_DEFINITIONS" \
    "no_args__________________;;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|0" \
    "extra_arg________________;1(expected call)|extra argument;127;ARGUMENT_REQUIREMENTS_VIOLATION|1|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|2"
}

test_stdlib_testing_mock_object_assert_any_call_is__@vary__returns_expected_status_code() {
  local args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc test_mock.mock.assert_any_call_is "${args[@]}" || true

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_any_call_is__@vary__returns_expected_status_code

test_stdlib_testing_mock_object_assert_any_call_is__@vary__generates_expected_log_messages() {
  local args=()
  local expected_log_messages=()
  local message_arg_definition
  local message_arg_definitions=()
  local message_args=()

  _mock.create test_mock
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_arg_definitions " " "${TEST_MESSAGE_ARG_DEFINITIONS}"
  for message_arg_definition in "${message_arg_definitions[@]}"; do
    stdlib.array.make.from_string message_args "|" "${message_arg_definition}"
    expected_log_messages+=("1($(stdlib.__message.get "${message_args[@]}")) STDLIB_ARGS_CALLER_FN_NAME(test_mock.mock.assert_any_call_is)")
  done

  test_mock.mock.assert_any_call_is "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "${expected_log_messages[@]}"
}

@parametrize_with_invalid_arg_combos \
  test_stdlib_testing_mock_object_assert_any_call_is__@vary__generates_expected_log_messages

test_stdlib_testing_mock_object_assert_any_call_is__builtin_unavailable________returns_expected_status_code() {
  _mock.create declare
  _mock.create test_mock

  _capture.rc test_mock.mock.assert_any_call_is "1(arg1)" 2> /dev/null || true

  assert_rc "1"
}

test_stdlib_testing_mock_object_assert_any_call_is__builtin_unavailable________generates_expected_log_messages() {
  _mock.create declare
  _mock.create test_mock

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "test_mock.mock.assert_any_call_is: $(_testing.mock.__message.get "MOCK_REQUIRES_BUILTIN" "test_mock" "declare")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____no_calls__value_absent____fails() {
  _mock.create test_mock

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__no_calls__value_absent____fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____1_call____no_args_________fails() {
  _mock.create test_mock
  test_mock

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__1_call____no_args_________fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____1_call____no_args_________succeeds() {
  _mock.create test_mock
  test_mock

  test_mock.mock.assert_any_call_is ""
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__1_call____no_args_________succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock

  test_mock.mock.assert_any_call_is "keyword1(value1) keyword2(value2)"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____2_calls___value_absent____fails() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__2_calls___value_absent____fails() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2

  _capture.assertion_failure test_mock.mock.assert_any_call_is "1(arg1)"

  assert_equals \
    "$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "test_mock" "1(arg1)")
 expected different value than [0] but was the same" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____3_calls___value_present___succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "1(arg1) 2(arg2) 3(successful)"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__3_calls___value_present___succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "1(arg1) 2(arg2) 3(successful) keyword1(value1) keyword2(value2)"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__no_keywords____3_calls___value_repeated__succeeds() {
  _mock.create test_mock
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "1(arg1) 2(arg2)"
}

test_stdlib_testing_mock_object_assert_any_call_is__valid_args__with_keywords__3_calls___value_repeated__succeeds() {
  _mock.create test_mock
  test_mock.mock.set.keywords "keyword1" "keyword2"
  test_mock arg1 arg2
  test_mock arg1 arg2 successful
  test_mock arg1 arg2

  test_mock.mock.assert_any_call_is "1(arg1) 2(arg2) keyword1(value1) keyword2(value2)"
}
