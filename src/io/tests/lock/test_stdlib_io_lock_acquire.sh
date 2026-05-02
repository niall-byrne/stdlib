#!/bin/bash

setup() {
  _mock.create mkdir
  _mock.create sleep
  _mock.create stdlib.logger.error
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
    "TEST_RMDIR_STATUS" \
    "time_exceed____________;1" \
    "acquired_______________;0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____@vary() {
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.acquire "${args[@]}" > /dev/null

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_acquire__allocated_workspace_____@vary

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____invalid_interval___returns_status_code_126() {
  local STDLIB_LOCK_POLLING_INTERVAL="aa"
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKDIR="mkdir"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____invalid_verbosity__returns_status_code_126() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN="aa"
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKDIR="mkdir"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____invalid_wait_time__returns_status_code_126() {
  local STDLIB_LOCK_WAIT_SECONDS="aa"
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKDIR="mkdir"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "126"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__no_allocated_workspace__valid_args_________returns_status_code___1() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKDIR="mkdir"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__no_allocated_workspace__valid_args_________logs_error_message() {
  local STDLIB_LOCK_WORKSPACE=""
  local _STDLIB_BINARY_MKDIR="mkdir"

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_WORKSPACE_DOES_NOT_EXIST "lockname"))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________@vary__calls_mkdir_with_correct_args() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 0

  _capture.rc stdlib.io.lock.acquire "lockname" > /dev/null

  mkdir.mock.assert_called_once_with \
    "1(${STDLIB_LOCK_WORKSPACE}/lockname)"
}

@parametrize_with_mkdir_status \
  test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________@vary__calls_mkdir_with_correct_args

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________quiet_flag_set______returns_status_code__1() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN=1
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________quiet_flag_not_set__returns_status_code__1() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "1"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________quiet_flag_set______does_not_log_error() {
  local STDLIB_LOCK_QUIET_FAILURE_BOOLEAN=1
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_not_called
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________quiet_flag_not_set__logs_error_message() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  stdlib.logger.error.mock.assert_called_once_with \
    "1($(stdlib.__message.get LOCK_COULD_NOT_BE_ACQUIRED "lockname"))"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________default_polling_____polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.1)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________time_exceed______________custom_polling______polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=0
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.2)"
}

# shellcheck disable=SC2034,SC2016
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________unbounded________________default_polling_____polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_WAIT_SECONDS=-1
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"
  local expected_mock_calls=()

  mkdir.mock.set.rc 1

  sleep.mock.set.subcommand '"$(which sleep)" "${1}"'
  stdlib.array.make.from_string_n expected_mock_calls "10" "1(0.1)"

  stdlib.io.lock.acquire "lockname" &
  "$(which sleep)" 1
  kill %1

  sleep.mock.assert_calls_are "${expected_mock_calls[@]}"
}

# shellcheck disable=SC2034,SC2016
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________unbounded________________custom_polling______polls_at_correct_interval() {
  local SECONDS=0
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=-1
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.rc 1

  sleep.mock.set.subcommand '"$(which sleep)" "${1}"'
  stdlib.array.make.from_string_n expected_mock_calls "10" "1(0.2)"

  stdlib.io.lock.acquire "lockname" &
  "$(which sleep)" 1
  kill %1

  sleep.mock.assert_calls_are "${expected_mock_calls[@]}"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________acquired_________________returns_status_code__0() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  _capture.rc stdlib.io.lock.acquire "lockname"

  assert_rc "0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________acquired_________________default_polling_____polls_at_correct_interval() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.1)" \
    "1(0.1)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________acquired_________________custom_polling______polls_at_correct_interval() {
  local STDLIB_LOCK_POLLING_INTERVAL="0.2"
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"

  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  sleep.mock.assert_calls_are \
    "1(0.2)" \
    "1(0.2)"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__allocated_workspace_____valid_args_________acquired_________________registers_cleanup_function() {
  local STDLIB_LOCK_WAIT_SECONDS=10
  local STDLIB_LOCK_WORKSPACE="mocked_workspace"
  local _STDLIB_BINARY_MKDIR="mkdir"
  local _STDLIB_BINARY_SLEEP="sleep"
  local expected_array=("stdlib.io.lock.__workspace_cleanup")

  mkdir.mock.set.side_effects "return 1" "return 1" "return 0"

  stdlib.io.lock.acquire "lockname"

  assert_is_array_containing \
    "stdlib.io.lock.__workspace_cleanup" \
    STDLIB_HANDLER_EXIT_FN_ARRAY
}
