#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create eval_gettext

  stdlib.__gettext.fallback

  variable1="value1"
  variable2="value2"
}

@parametrize_with_domains() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DOMAIN" \
    "domain1;domain1" \
    "domain2;domain2"
}

@parametrize_with_messages() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_MESSAGE;TEST_EXPECTED_STDOUT" \
    "simple_message_______;just a simple message;just a simple message" \
    "single_interpolated_variable;a message with \${variable1};a message with value1" \
    "single_quoted_interpolated_variable;a message with '\$variable1';a message with 'value1'" \
    "multiple_interpolated_variables;a message with \$variable1 and \$variable2;a message with value1 and value2" \
    "multiple_quoted_interpolated_variables;a message with '\${variable1}' and '\${variable2}';a message with 'value1' and 'value2'"
}

# shellcheck disable=SC2034
test_stdlib_gettext_fallback__@vary__@vary__does_not_call_eval_gettext_function() {
  stdlib.__gettext.call "${TEST_DOMAIN}" "${TEST_MESSAGE}" > /dev/null

  eval_gettext.mock.assert_not_called
}

@parametrize.compose \
  test_stdlib_gettext_fallback__@vary__@vary__does_not_call_eval_gettext_function \
  @parametrize_with_domains \
  @parametrize_with_messages

# shellcheck disable=SC2034
test_stdlib_gettext_fallback__@vary__@vary__emits_correct_stdout() {
  _capture.stdout stdlib.__gettext.call "${TEST_DOMAIN}" "${TEST_MESSAGE}"

  assert_output "${TEST_EXPECTED_STDOUT}"
}

@parametrize.compose \
  test_stdlib_gettext_fallback__@vary__@vary__emits_correct_stdout \
  @parametrize_with_domains \
  @parametrize_with_messages

# shellcheck disable=SC2034
test_stdlib_gettext_fallback__@vary__nasty_subshell_attack___________________does_not_evaluate_subshell() {
  _capture.stdout stdlib.__gettext.call "${TEST_DOMAIN}" "\$(echo eval subshell)"

  assert_output "\$(echo eval subshell)"
}

@parametrize.compose \
  test_stdlib_gettext_fallback__@vary__nasty_subshell_attack___________________does_not_evaluate_subshell \
  @parametrize_with_domains

# shellcheck disable=SC2034
test_stdlib_gettext_fallback__@vary__nasty_backticks_attack__________________does_not_evaluate_backticks() {
  _capture.stdout stdlib.__gettext.call "${TEST_DOMAIN}" "\`echo eval subshell\`"

  assert_output "\`echo eval subshell\`"
}

@parametrize.compose \
  test_stdlib_gettext_fallback__@vary__nasty_backticks_attack__________________does_not_evaluate_backticks \
  @parametrize_with_domains
