#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

@parametrize_with_arg_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_______________________returns_status_code_127;;127" \
    "extra_args____________________returns_status_code_127;DEBUG_DIFF_FOOTER|two|three|four|five;127" \
    "invalid_arguments_____________returns_status_code_126;INVALID_KEY;126" \
    "valid_argument________________returns_status_code___0;DEBUG_DIFF_FOOTER;0" \
    "valid_arguments_with_options__returns_status_code___0;DEBUG_DIFF_FOOTER;0"
}

@parametrize_with_message_content() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_STDOUT" \
    "debug_diff_footer;DEBUG_DIFF_FOOTER;== End Debug Diff ==" \
    "debug_diff_header;DEBUG_DIFF_HEADER;== Start Debug Diff ==" \
    "debug_diff_prefix;DEBUG_DIFF_PREFIX;Diff" \
    "debug_diff_prefix_actual;DEBUG_DIFF_PREFIX_ACTUAL;ACTUAL" \
    "debug_diff_prefix_expected;DEBUG_DIFF_PREFIX_EXPECTED;EXPECTED" \
    "load_module_not_found;LOAD_MODULE_NOT_FOUND|module_name;The module 'module_name' could not be found!" \
    "load_module_notification;LOAD_MODULE_NOTIFICATION|module_name;Loading module 'module_name' ..."
}

@parametrize_with_incorrect_arg_counts() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION" \
    "debug_diff_footer________________________________too_many_args;DEBUG_DIFF_FOOTER|1" \
    "debug_diff_header________________________________too_many_args;DEBUG_DIFF_HEADER|1" \
    "debug_diff_prefix________________________________too_many_args;DEBUG_DIFF_PREFIX|1" \
    "debug_diff_prefix_actual_________________________too_many_args;DEBUG_DIFF_PREFIX_ACTUAL|1" \
    "debug_diff_prefix_expected_______________________too_many_args;DEBUG_DIFF_PREFIX_EXPECTED|1" \
    "load_module_not_found____________________________no_args;LOAD_MODULE_NOT_FOUND" \
    "load_module_not_found____________________________too_many_args;LOAD_MODULE_NOT_FOUND|1|2" \
    "load_module_notification_________________________no_args;LOAD_MODULE_NOTIFICATION" \
    "load_module_notification_________________________too_many_args;LOAD_MODULE_NOTIFICATION|1|2"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc _testing.__message.get "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_arg_combos \
  test_stdlib_testing_message_get__@vary

# shellcheck disable=SC2034
test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _testing.__message.get "${args[@]}"

  assert_equals "${TEST_EXPECTED_STDOUT}" "${TEST_OUTPUT}"
}

@parametrize_with_message_content \
  test_stdlib_testing_message_get__valid_argument________________@vary_____returns_correct_message

test_stdlib_testing_message_get__invalid_arguments_____________returns_error_message() {
  _capture.stdout _testing.__message.get "NON_EXISTENT_KEY"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Unknown message key 'NON_EXISTENT_KEY')"
}

# shellcheck disable=SC2034
test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.stdout _testing.__message.get "${args[@]}"

  stdlib.testing.internal.logger.error.mock.assert_called_once_with \
    "1(Invalid arguments provided!)"
}

@parametrize_with_incorrect_arg_counts \
  test_stdlib_testing_message_get__invalid_arg_count_____________@vary__returns_correct_message
