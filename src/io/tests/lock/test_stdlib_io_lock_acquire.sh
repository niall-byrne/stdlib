#!/bin/bash

setup() {
  _mock.create mkdir
  _mock.create sleep
  _mock.create stdlib.logger.error
  _mock.create stdlib.io.lock.__workspace_is_valid
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args____________returns_status_code_127;;127" \
    "extra_arg__________returns_status_code_127;lockname|extra_arg;127" \
    "null_lock_name_____returns_status_code_126;|;126" \
    "invalid_lock_name__returns_status_code_126;lock name|;126" \
    "valid_args_________returns_status_code___0;lockname;0"
}

@parametrize_with_mkdir_status() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_MKDIR_RC" \
    "time_exceed____________;1" \
    "acquired_______________;0"
}

@parametrize_with_workpace_allocation() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_IS_VALID_RC" \
    "valid_workspace__;1" \
    "invalid_workspace;0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____@vary() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local args=()

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.acquire "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_acquire__valid_workspace____@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_interval___returns_status_code_125() {
  local STDLIB_LOCK_POLLING_INTERVAL="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "125"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_interval___returns_status_code_125

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_interval___logs_error_message() {
  local STDLIB_LOCK_POLLING_INTERVAL="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_DECIMAL_POSITIVE "aa"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LOCK_POLLING_INTERVAL))"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_interval___logs_error_message

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_verbosity__returns_status_code_125() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "125"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_verbosity__returns_status_code_125

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_verbosity__logs_error_message() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_BOOLEAN "aa"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LOCK_QUIET_FAILURE_BOOLEAN))"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_verbosity__logs_error_message

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_wait_time__returns_status_code_125() {
  local STDLIB_LOCK_WAIT_SECONDS="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "125"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_wait_time__returns_status_code_125

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__invalid_wait_time__logs_error_message() {
  local STDLIB_LOCK_WAIT_SECONDS="aa"
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_calls_are \
    "1($(stdlib.__message.get IS_NOT_INTEGER "aa"))" \
    "1($(stdlib.__message.get ARGUMENTS_KEYWORD_INVALID_DETAIL STDLIB_LOCK_WAIT_SECONDS))"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__invalid_wait_time__logs_error_message

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__@vary__valid_args_________stops_keyword_propagation() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  _mock.create stdlib.fn.keyword.consume
  # shellcheck disable=SC2016
  stdlib.fn.keyword.consume.mock.set.subcommand 'printf -v "$1" "%s" "${!2}"'
  stdlib.io.lock.__workspace_is_valid.mock.set.rc "${TEST_IS_VALID_RC}"

  stdlib.io.lock.acquire "lockname"

  stdlib.fn.keyword.consume.mock.assert_calls_are \
    "1(polling_interval) 2(STDLIB_LOCK_POLLING_INTERVAL) 3(0.1)" \
    "1(quiet_acquisition_failure_boolean) 2(STDLIB_LOCK_QUIET_FAILURE_BOOLEAN) 3(0)" \
    "1(wait_time) 2(STDLIB_LOCK_WAIT_SECONDS) 3(30)"
}

@parametrize_with_workpace_allocation \
  test_stdlib_io_lock_acquire__@vary__valid_args_________stops_keyword_propagation

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0

  stdlib.io.lock.acquire "lockname"

  stdlib.io.lock.__workspace_is_valid.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________@vary__calls_mkdir_with_correct_args() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc "${TEST_MKDIR_RC}"

  _capture.rc stdlib.io.lock.acquire "lockname" > /dev/null

  mkdir.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE}/lockname)"
}

@parametrize_with_mkdir_status \
  test_stdlib_io_lock_acquire__valid_workspace____valid_args_________@vary__calls_mkdir_with_correct_args

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________quiet_flag_set______returns_status_code__1() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN=1
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________quiet_flag_not_set__returns_status_code__1() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________quiet_flag_set______does_not_log_error() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN=1
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________quiet_flag_not_set__logs_error_message() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_COULD_NOT_BE_ACQUIRED "lockname"))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________default_polling_____polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.1)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________time_exceed______________custom_polling______polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.2)"
}

# shellcheck disable=SC2034,SC2016
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________unbounded________________default_polling_____polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=-1
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"
  local expected_mock_calls=()

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  sleep.mock.set.subcommand '"$(which sleep)" "${1}"'
  stdlib.array.make.from_string_n expected_mock_calls "10" "1(0.1)"

  stdlib.io.lock.acquire "lockname" &
  "$(which sleep)" 1
  kill %1

  sleep.mock.assert_calls_are "${expected_mock_calls[@]}"
}

# shellcheck disable=SC2034,SC2016
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________unbounded________________custom_polling______polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=-1
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.rc 1

  sleep.mock.set.subcommand '"$(which sleep)" "${1}"'
  stdlib.array.make.from_string_n expected_mock_calls "10" "1(0.2)"

  stdlib.io.lock.acquire "lockname" &
  "$(which sleep)" 1
  kill %1

  sleep.mock.assert_calls_are "${expected_mock_calls[@]}"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________acquired_________________returns_status_code__0() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________acquired_________________default_polling_____polls_at_correct_interval() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.1)" \
    "1(0.1)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________acquired_________________custom_polling______polls_at_correct_interval() {
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.2)" \
    "1(0.2)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__valid_workspace____valid_args_________acquired_________________registers_cleanup_function() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"
  local expected_array=("stdlib.io.lock.__workspace_cleanup")

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 0
  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  assert_is_array_containing \
    "stdlib.io.lock.__workspace_cleanup" \
    STDLIB_HANDLER_EXIT_FN_ARRAY
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__invalid_workspace__valid_args_________validates_workspace() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.io.lock.__workspace_is_valid.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE})"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__invalid_workspace__valid_args_________returns_status_code_123() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "123"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__invalid_workspace__valid_args_________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.__workspace_is_valid.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get VAR_VALUE_INVALID_RESERVED_DETAIL STDLIB_LOCK_WORKSPACE))"
}
