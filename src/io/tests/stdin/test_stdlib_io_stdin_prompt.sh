#!/bin/bash

setup() {
  _mock.create stdlib.logger.error

  # shellcheck disable=SC2034
  __STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1
}

teardown() {
  unset __STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____________________________________returns_status_code_127;;127" \
    "extra_arg___________________________________returns_status_code_127;input_var|Enter a value:|extra_arg;127" \
    "null_variable_name__________________________returns_status_code_126;|Enter a value:;126" \
    "null_prompt_________________________________returns_status_code___0;input_var|;0" \
    "prompt_and_variable_name____________________returns_status_code___0;input_var|Enter a value:;0"
}

@parametrize_with_args_and_read_flags() {
  # $1: the function to parametrize

  local default_prompt_value

  default_prompt_value="$(stdlib.__message.get STDIN_DEFAULT_VALUE_PROMPT)"

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_PASSWORD_BOOLEAN;TEST_READ_ARGS;TEST_EXPECTED_ECHO_CALL_COUNT" \
    "variable_name_____________________________;input_var;;1(-rp) 2(${default_prompt_value}) 3(input_var);0" \
    "prompt_and_variable_name_as_default_input_;input_var|Enter a custom value: ;;1(-rp) 2(Enter a custom value: ) 3(input_var);0" \
    "prompt_and_variable_name_as_regular_input_;input_var|Enter a custom value: ;0;1(-rp) 2(Enter a custom value: ) 3(input_var);0" \
    "prompt_and_variable_name_as_password_input;input_var|Enter a custom value: ;1;1(-rsp) 2(Enter a custom value: ) 3(input_var);1"
}

test_stdlib_io_stdin_prompt__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin" > /dev/null

  assert_equals "${TEST_EXPECTED_RC}" "$?"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_stdin_prompt__@vary

test_stdlib_io_stdin_prompt__@vary__calls_read_as_expected() {
  local args=()
  local expected_read_args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"
  stdlib.array.make.from_string expected_read_args "|" "${TEST_READ_ARGS}"
  _mock.create read
  read.mock.set.subcommand "input_var='value'"

  STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="${TEST_PASSWORD_BOOLEAN}" \
    stdlib.io.stdin.prompt "${args[@]}" > /dev/null

  read.mock.assert_called_once_with "${expected_read_args[*]}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__calls_read_as_expected

test_stdlib_io_stdin_prompt__@vary__stores_the_stdin() {
  local args=()
  local input_var

  STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="${TEST_PASSWORD_BOOLEAN}" \
    stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin" > /dev/null

  # shellcheck disable=SC2154
  assert_equals "mocked stdin" "${input_var}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__stores_the_stdin

test_stdlib_io_stdin_prompt__@vary__appends_extra_carriage_return() {
  local args=()
  local input_var
  local mock_echo_call_count
  local STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="${TEST_PASSWORD_BOOLEAN}"

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _mock.create echo

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin"

  mock_echo_call_count=$(echo.mock.get.count)

  _mock.delete echo

  assert_equals "${TEST_EXPECTED_ECHO_CALL_COUNT}" "${mock_echo_call_count}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__appends_extra_carriage_return

test_stdlib_io_stdin_prompt__@vary__stops_keyword_propagation() {
  local args=()
  local input_var
  local mock_echo_call_count
  local STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="${TEST_PASSWORD_BOOLEAN}"

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  stdlib.io.stdin.prompt "${args[@]}" <<< "mocked stdin" > /dev/null

  assert_null "${STDLIB_STDIN_PASSWORD_MASK_BOOLEAN}"
}

@parametrize_with_args_and_read_flags \
  test_stdlib_io_stdin_prompt__@vary__stops_keyword_propagation

test_stdlib_io_stdin_prompt__invalid_mask_boolean________________________returns_status_code_125() {
  local STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="non_boolean_value"
  local input_var

  stdlib.io.stdin.prompt input_var <<< "mocked stdin"

  assert_equals "125" "$?"
}

test_stdlib_io_stdin_prompt__invalid_mask_boolean________________________logs_error_message() {
  local STDLIB_STDIN_PASSWORD_MASK_BOOLEAN="non_boolean_value"
  local input_var

  stdlib.io.stdin.prompt input_var <<< "mocked stdin"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_BOOLEAN "non_boolean_value"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_STDIN_PASSWORD_MASK_BOOLEAN))"
}
