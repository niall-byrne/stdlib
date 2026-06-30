#!/bin/bash

setup() {
  _mock.create stdlib.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC;TEST_INVALID_KW_EXPECTED_RC" \
    "null_padding_____arg___returns_status_code_126;|80|input_string;126;126" \
    "invalid_padding__arg___returns_status_code_126;aa|80|input_string;126;126" \
    "null_limit_______arg___returns_status_code_126;20||input_string;126;126" \
    "invalid_limit____arg___returns_status_code_126;20|aa|input_string;126;126" \
    "extra_arg________arg___returns_status_code_127;20|80|input_string|extra_arg;127;127" \
    "null_input_______arg___returns_status_code___0;20|80||;0;125" \
    "valid_args_______arg___returns_status_code___0;20|80|input_string;0;125"
}

@parametrize_with_logging_messages() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_VALID_KW_MESSAGE_DEFINITION;TEST_INVALID_KW_MESSAGE_DEFINITION" \
    "null_padding_____arg_;|80|input_string;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|1" \
    "invalid_padding__arg_;aa|80|input_string;IS_NOT_DIGIT|aa;IS_NOT_DIGIT|aa" \
    "null_limit_______arg_;20||input_string;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|2;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_NULL|2" \
    "invalid_limit____arg_;20|aa|input_string;IS_NOT_DIGIT|aa;IS_NOT_DIGIT|aa" \
    "extra_arg________arg_;20|80|input_string|extra_arg;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4;ARGUMENT_REQUIREMENTS_VIOLATION|3|0 ARGUMENT_REQUIREMENTS_VIOLATION_DETAIL|4" \
    "null_input_______arg_;20|80||;;IS_NOT_CHAR|not_a_char ARGUMENTS_KEYWORD_INVALID_DETAIL|STDLIB_WRAP_LINE_BREAK_FORCE_CHAR" \
    "valid_args_______arg_;20|80|input_string;;IS_NOT_CHAR|not_a_char ARGUMENTS_KEYWORD_INVALID_DETAIL|STDLIB_WRAP_LINE_BREAK_FORCE_CHAR"
}

@parametrize_with_wrap_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED;TEST_LINE_BREAK_CHAR;TEST_PREFIX_STRING" \
    "short_string____pad_width_10__wrap_20__auto_wrap____no_indent____;10|20|don't wrap;don't wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__auto_wrap____no_indent____;10|20|this is a string of text that i would like to wrap;this is a<br>          string of<br>          text that<br>          i would<br>          like to<br>          wrap;;;" \
    "wrapped_string__pad_width_05__wrap_20__auto_wrap____no_indent____;5|20|this is a string of text that i would like to wrap;this is a<br>     string of text<br>     that i would<br>     like to wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__forced_wrap__no_indent____;10|20|this is a string of text *that i would like to wrap;this is a<br>          string of<br>          text<br>          that i<br>          would like<br>          to wrap;;;" \
    "wrapped_string__pad_width_10__wrap_20__custom_wrap__no_indent____;10|20|this is a string of text !that i would like to wrap;this is a<br>          string of<br>          text<br>          that i<br>          would like<br>          to wrap;!;;" \
    "wrapped_string__pad_width_10__wrap_30__auto_wrap____custom_indent;10|30|this is a string of text that i would like to wrap;this is a string<br>          ***of text that i<br>          ***would like to<br>          ***wrap;;***" \
    "wrapped_string__pad_width_10__wrap_30__forced_wrap__custom_indent;10|30|this is a string of text *that i would like to wrap;this is a string<br>          ***of text<br>          ***that i would like<br>          ***to wrap;;***" \
    "wrapped_string__pad_width_10__wrap_30__custom_wrap__custom_indent;10|30|this is a string of text !that i would like to wrap;this is a string<br>          ***of text<br>          ***that i would like<br>          ***to wrap;!;***"
}

_fixture_unpack_message_args() {
  local message_args=()

  stdlib.array.make.from_string message_args "|" "${1}"
  messages+=("$(stdlib.__message.get "${message_args[@]}")")
}

# shellcheck disable=SC2034
test_stdlib_string_wrap__valid_kw____@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.string.wrap "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_wrap__valid_kw____@vary

# shellcheck disable=SC2034
test_stdlib_string_wrap__valid_kw____@vary__logs_expected_error_message() {
  local args=()
  local messages=()
  local message_args_sets=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args_sets " " "${TEST_VALID_KW_MESSAGE_DEFINITION}"
  stdlib.array.map.fn _fixture_unpack_message_args message_args_sets

  stdlib.string.wrap "${args[@]}" > /dev/null

  assert_logger_error_matches "${messages[@]}"
}

@parametrize_with_logging_messages \
  test_stdlib_string_wrap__valid_kw____@vary__logs_expected_error_message

# shellcheck disable=SC2034
test_stdlib_string_wrap__invalid_kw__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  STDLIB_WRAP_LINE_BREAK_FORCE_CHAR="not_a_char" \
    _capture.rc stdlib.string.wrap "${args[@]}" > /dev/null

  assert_rc "${TEST_INVALID_KW_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_string_wrap__invalid_kw__@vary

# shellcheck disable=SC2034
test_stdlib_string_wrap__invalid_kw__@vary__logs_expected_error_message() {
  local args=()
  local messages=()
  local message_args_sets=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string message_args_sets " " "${TEST_INVALID_KW_MESSAGE_DEFINITION}"
  stdlib.array.map.fn _fixture_unpack_message_args message_args_sets

  STDLIB_WRAP_LINE_BREAK_FORCE_CHAR="not_a_char" \
    stdlib.string.wrap "${args[@]}" > /dev/null

  assert_logger_error_matches "${messages[@]}"
}

@parametrize_with_logging_messages \
  test_stdlib_string_wrap__invalid_kw__@vary__logs_expected_error_message

# shellcheck disable=SC2034
test_stdlib_string_wrap__valid_kw____valid_args_______arg___@vary__correct_output() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  TEST_EXPECTED="${TEST_EXPECTED//'<br>'/$'\n'}"

  STDLIB_WRAP_LINE_BREAK_FORCE_CHAR="${TEST_LINE_BREAK_CHAR}" \
    STDLIB_WRAP_PREFIX="${TEST_PREFIX_STRING}" \
    _capture.output stdlib.string.wrap "${args[@]}"

  assert_output "${TEST_EXPECTED}"
}

@parametrize_with_wrap_content \
  test_stdlib_string_wrap__valid_kw____valid_args_______arg___@vary__correct_output

test_stdlib_string_wrap__valid_kw____null_input_______arg___wrapped_string__pad_width_10__wrap_20__auto_wrap____no_indent______correct_output() {
  TEST_INPUT=""

  _capture.output stdlib.string.wrap "10" "20" "${TEST_INPUT}"

  assert_output_null
}
