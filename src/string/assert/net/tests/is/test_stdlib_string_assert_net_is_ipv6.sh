#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________returns_status_code_127;;127" \
    "extra_arg_____________returns_status_code_127;2001:db8::1|extra_arg;127" \
    "empty_string__________returns_status_code_126;|;126" \
    "symbol________________returns_status_code___1;200@:db8!::1;1" \
    "digit_________________returns_status_code___1;9;1" \
    "invalid_compression___returns_status_code___1;2001::85a3::8a2e;1" \
    "compression_overflow__returns_status_code___1;1:2:3:4:5:6:7::8;1" \
    "too_many_segments_____returns_status_code___1;1:2:3:4:5:6:7:8:9;1" \
    "too_few_segments______returns_status_code___1;1:2:3:4:5:6:7;1" \
    "invalid_hexadecimal___returns_status_code___1;2001:db8:85a3:gggg::1;1" \
    "segment_too_long______returns_status_code___1;2001:12345::1;1" \
    "triple_colon__________returns_status_code___1;fe80:::1;1" \
    "leading_colon_________returns_status_code___1;:2001:db8::1;1" \
    "trailing_colon________returns_status_code___1;2001:db8::1:;1" \
    "full_address__________returns_status_code___0;2001:0db8:85a3:0000:0000:8a2e:0370:7334;0" \
    "mixed_case_hex________returns_status_code___0;2001:0dB8:0000:0000:0000:Ff00:0042:8329;0" \
    "compressed_address____returns_status_code___0;2001:db8::1;0" \
    "compressed_end________returns_status_code___0;2001:db8::;0" \
    "loopback______________returns_status_code___0;::1;0" \
    "leading_zeros_________returns_status_code___0;2001:db8:0:0:0:0:2:1;0"
}

@parametrize_with_error_messages() {

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_MESSAGE_ARG_DEFINITION" \
    "no_args_____________;;ARGUMENTS_INVALID" \
    "extra_arg___________;1|extra_arg;ARGUMENTS_INVALID" \
    "empty_string________;|;IS_NOT_IPV6||" \
    "compression_overflow;1:2:3:4:5:6:7::8;IS_NOT_IPV6|1:2:3:4:5:6:7::8"
}

# shellcheck disable=SC2034
test_stdlib_string_assert_is_ipv6__@vary() {
  local args=()
  _mock.create stdlib.logger.error

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.assert.net.is_ipv6 "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_assert_is_ipv6__@vary

test_stdlib_string_assert_is_ipv6__@vary__logs_an_error() {
  local args=()
  local message_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args "|" "${TEST_MESSAGE_ARG_DEFINITION}"

  stdlib.string.assert.net.is_ipv6 "${args[@]}"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get "${message_args[@]}"))"
}

@parametrize_with_error_messages \
  test_stdlib_string_assert_is_ipv6__@vary__logs_an_error
