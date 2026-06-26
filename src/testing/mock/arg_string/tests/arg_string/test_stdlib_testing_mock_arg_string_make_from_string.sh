#!/bin/bash

# shellcheck disable=SC2034
setup_suite() {
  kw1="value1"
  kw2="value2"
  empty_array=()
  keywords=("kw1" "kw2")
}

@parametrize_with_invalid_args() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_SEPERATOR;TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________________________________________127;;;127" \
    "extra_arg___________________________________________127; ;test string|empty_array|extra_arg;127" \
    "null_string___no_array___________valid_separator____127; ;|;127" \
    "null_string___invalid_array______valid_separator____127; ;|invalid_array;127" \
    "null_string___valid_array________valid_separator____127; ;|empty_array;127" \
    "null_string___no_array___________invalid_separator__127;--;|;127" \
    "null_string___invalid_array______invalid_separator__127;--;|invalid_array;127" \
    "null_string___valid_array________invalid_separator__127;--;|empty_array;127" \
    "valid_string__no_array___________null_separator_______0;;test string;0" \
    "valid_string__invalid_array______null_separator_____126;;test string|invalid_array;126" \
    "valid_string__valid_array________null_separator_______0;;test string|empty_array;0" \
    "valid_string__no_array___________valid_separator______0; ;test string;0" \
    "valid_string__invalid_array______valid_separator____126; ;test string|invalid_array;126" \
    "valid_string__valid_array________valid_separator______0; ;test string|empty_array;0" \
    "valid_string__no_array___________invalid_separator__125;--;test string;125" \
    "valid_string__invalid_array______invalid_separator__125;--;test string|invalid_array;125" \
    "valid_string__valid_array________invalid_separator__125;--;test string|empty_array;125"
}

@parametrize_with_valid_strings() {
  #$1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_SEPERATOR;TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "no_args_______default_separator__no_keywords___________;;arg1|;1(arg1)" \
    "no_args_______default_separator__keywords______________;;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "single_arg____default_separator__no_keywords___________;;arg1|;1(arg1)" \
    "single_arg____default_separator__keywords______________;;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "dual_args_____default_separator__no_keywords___________;;arg1 arg2|;1(arg1) 2(arg2)" \
    "dual_args_____default_separator__keywords______________;;arg1 arg2|keywords;1(arg1) 2(arg2) kw1(value1) kw2(value2)" \
    "three_args____default_separator__no_keywords___________;;arg1 arg2 arg3|;1(arg1) 2(arg2) 3(arg3)" \
    "three_args____default_separator__keywords______________;;arg1 arg2 arg3|keywords;1(arg1) 2(arg2) 3(arg3) kw1(value1) kw2(value2)" \
    "no_args_______custom_separator___no_keywords___________;!;arg1;1(arg1)" \
    "no_args_______custom_separator___keywords______________;!;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "single_arg____custom_separator___no_keywords___________;!;arg1;1(arg1)" \
    "single_arg____custom_separator___keywords______________;!;arg1|keywords;1(arg1) kw1(value1) kw2(value2)" \
    "dual_args_____custom_separator___no_keywords___________;!;arg1!arg2;1(arg1) 2(arg2)" \
    "dual_args_____custom_separator___keywords______________;!;arg1!arg2|keywords;1(arg1) 2(arg2) kw1(value1) kw2(value2)" \
    "three_args____custom_separator___no_keywords___________;!;arg1!arg2!arg3;1(arg1) 2(arg2) 3(arg3)" \
    "three_args____custom_separator___keywords_____________;!;arg1!arg2!arg3|keywords;1(arg1) 2(arg2) 3(arg3) kw1(value1) kw2(value2)"
}

test_stdlib_testing_mock_arg_string_make_from_string__@vary__returns_expected_status_code() {
  local args=()
  [[ "${TEST_SEPERATOR}" != "" ]] && local STDLIB_LINE_BREAK_DELIMITER_CHAR="${TEST_SEPERATOR}"

  _mock.create stdlib.testing.internal.logger.error
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _mock.arg_string.make.from_string "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_invalid_args \
  test_stdlib_testing_mock_arg_string_make_from_string__@vary__returns_expected_status_code

test_stdlib_testing_mock_arg_string_make_from_string__@vary__generates_correct_arg_string() {
  local STDLIB_LINE_BREAK_DELIMITER_CHAR
  local args=()

  STDLIB_LINE_BREAK_DELIMITER_CHAR="${TEST_SEPERATOR}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _mock.arg_string.make.from_string "${args[@]}"

  assert_output "${TEST_EXPECTED_STDOUT}"
}

@parametrize_with_valid_strings \
  test_stdlib_testing_mock_arg_string_make_from_string__@vary__generates_correct_arg_string

test_stdlib_testing_mock_arg_string_make_from_string__@vary__stops_keyword_propagation() {
  local STDLIB_LINE_BREAK_DELIMITER_CHAR
  local args=()

  _mock.create stdlib.testing.internal.fn.keyword.consume
  # shellcheck disable=SC2016
  stdlib.testing.internal.fn.keyword.consume.mock.set.subcommand 'printf -v "$1" "%s" "${!2}"'
  STDLIB_LINE_BREAK_DELIMITER_CHAR="${TEST_SEPERATOR}"
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _mock.arg_string.make.from_string "${args[@]}"

  stdlib.testing.internal.fn.keyword.consume.mock.assert_called_once_with \
    "1(_mock_separator) 2(STDLIB_LINE_BREAK_DELIMITER_CHAR) 3( )"
}

@parametrize_with_valid_strings \
  test_stdlib_testing_mock_arg_string_make_from_string__@vary__stops_keyword_propagation

test_stdlib_testing_mock_arg_string_make_from_string__valid_string__no_array___________invalid_keyword_________logs_expected_error() {
  _mock.create stdlib.testing.internal.logger.error

  STDLIB_LINE_BREAK_DELIMITER_CHAR="invalid value" \
    _mock.arg_string.make.from_string "123"

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "invalid value"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LINE_BREAK_DELIMITER_CHAR))"
}

test_stdlib_testing_mock_arg_string_make_from_string__valid_string__valid_array________invalid_keyword_________logs_expected_error() {
  _mock.create stdlib.testing.internal.logger.error

  STDLIB_LINE_BREAK_DELIMITER_CHAR="invalid value" \
    _mock.arg_string.make.from_string "123" empty_array

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "invalid value"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LINE_BREAK_DELIMITER_CHAR))"
}

test_stdlib_testing_mock_arg_string_make_from_string__valid_string__invalid_array______invalid_keyword_________logs_expected_error() {
  _mock.create stdlib.testing.internal.logger.error

  STDLIB_LINE_BREAK_DELIMITER_CHAR="invalid value" \
    _mock.arg_string.make.from_string "123" _non_existent_array

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_CHAR "invalid value"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LINE_BREAK_DELIMITER_CHAR))"
}

test_stdlib_testing_mock_arg_string_make_from_string__new_lines_____no_keywords________________________________generates_correct_arg_string() {
  _capture.stdout _mock.arg_string.make.from_string "arg"$'\n'"1 arg2"

  assert_output "1(arg
1) 2(arg2)"
}
