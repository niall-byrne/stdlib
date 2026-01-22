#!/bin/bash

# shellcheck disable=SC2034
setup() {
  not_builtin_string="not a builtin"
  not_builtin_array=()

  _mock.create _testing.error
}

not_builtin_fn() {
  echo "test"
}

fake.mock.object.method() {
  "${@}"
}

@parametrize_with_arg_combos() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________returns_status_code_127;;127" \
    "arg_is_null_________returns_status_code_126;|;126" \
    "extra_arg___________returns_status_code_127;echo|extra_arg;127" \
    "arg_is_string_______returns_status_code___1;not_builtin_string;1" \
    "arg_is_array________returns_status_code___1;not_builtin_array;1" \
    "arg_does_not_exist__returns_status_code___1;nothing_at_all;1" \
    "arg_is_fn___________returns_status_code___1;not_builtin_fn;1" \
    "arg_is_builtin______returns_status_code___0;echo;0"
}

@parametrize_with_invalid_arguments() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args___________;;ARGUMENTS_INVALID" \
    "arg_is_null_______;;ARGUMENTS_INVALID" \
    "extra_arg_________;echo|extra_arg;ARGUMENTS_INVALID"
}

@parametrize_with_error_messages() {
  # $1: test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "arg_is_string_____;not_builtin_string;MOCK_REQUIRES_BUILTIN|fake|not_builtin_string" \
    "arg_is_array______;not_builtin_array;MOCK_REQUIRES_BUILTIN|fake|not_builtin_array" \
    "arg_is_fn_________;not_builtin_fn;MOCK_REQUIRES_BUILTIN|fake|not_builtin_fn"
}

test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc fake.mock.object.method _mock.__internal.security.assert.is_builtin "${args[@]}" 2> /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary

test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary__logs_an_invalid_argument_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  _capture.rc fake.mock.object.method _mock.__internal.security.assert.is_builtin "${args[@]}"

  _testing.error.mock.assert_called_once_with \
    "1(_mock.__internal.security.assert.is_builtin: $(stdlib.message.get "${message_args[@]}"))"
}

@parametrize_with_invalid_arguments \
  test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary__logs_an_invalid_argument_error

test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary__logs_an_assertion_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  fake.mock.object.method _mock.__internal.security.assert.is_builtin "${args[@]}"

  _testing.error.mock.assert_called_once_with \
    "1(fake.mock.object.method: $(_testing.mock.message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_testing_mock_internal_security_assert_is_builtin__@vary__logs_an_assertion_error
