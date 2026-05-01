#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args______________returns_status_code_127;;127" \
    "extra_arg____________returns_status_code_127;AA|extra_arg;127" \
    "empty_string_________returns_status_code_126;|;126" \
    "symbol_______________returns_status_code___1;@#!.1.1.1;1" \
    "digit________________returns_status_code___1;9;1" \
    "alpha________________returns_status_code___1;a.b.c.d;1" \
    "too_many_octets______returns_status_code___1;1.2.3.4.5;1" \
    "octet_out_of_range___returns_status_code___1;1.2.3.300;1" \
    "leading_zero_________returns_status_code___0;1.2.3.001;1" \
    "valid________________returns_status_code___0;1.2.3.255;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args____________;;ARGUMENTS_INVALID" \
    "extra_arg__________;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string_______;|;IS_NOT_IPV4||" \
    "too_many_octets____;1.2.3.4.5;IS_NOT_IPV4|1.2.3.4.5"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_ipv4__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.net.is_ipv4 "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_ipv4__@vary

test_stdlib_string_assert_is_ipv4__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.net.is_ipv4 "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_ipv4__@vary__logs_an_error
