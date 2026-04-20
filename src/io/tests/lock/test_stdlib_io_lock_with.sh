#!/bin/bash

setup() {
  _mock.create stdlib.io.lock.workspace_allocate
  _mock.create stdlib.io.lock.acquire
  _mock.create stdlib.io.lock.release
  _mock.create command_to_run
  _mock.create stdlib.logger.error

  mock_lock_name="lockname"
}

@parametrize_with_args_and_status_codes() {
  # $1: the function to parametrize

  @parametrize \
    "${1}" \
    "TEST_ARGS_DEFINITION;TEST_EXPECTED_RC" \
    "no_args_____returns_status_code_127;;127" \
    "valid_args__returns_status_code___0;lockname|command_to_run;0"
}

# shellcheck disable=SC2034
test_stdlib_io_lock_with__@vary() {
  local args=()

  stdlib.array.make.from_string args "|" "${TEST_ARGS_DEFINITION}"

  _capture.rc stdlib.io.lock.with "${args[@]}"

  assert_rc "${TEST_EXPECTED_RC}"
}

@parametrize_with_args_and_status_codes \
  test_stdlib_io_lock_with__@vary

test_stdlib_io_lock_with__valid_args__allocates_workspace() {
  stdlib.io.lock.with "${mock_lock_name}" command_to_run

  stdlib.io.lock.workspace_allocate.mock.assert_called_once_with ""
}

test_stdlib_io_lock_with__valid_args__allocates_workspace__fails__returns_correct_status_code() {
  stdlib.io.lock.acquire.mock.set.rc 99

  _capture.rc stdlib.io.lock.with "${mock_lock_name}" command_to_run

  assert_rc 99
}

test_stdlib_io_lock_with__valid_args__acquires_lock() {
  stdlib.io.lock.with "${mock_lock_name}" command_to_run

  stdlib.io.lock.acquire.mock.assert_called_once_with "1(${mock_lock_name})"
}

test_stdlib_io_lock_with__valid_args__acquires_lock________fails__returns_correct_status_code() {
  stdlib.io.lock.acquire.mock.set.rc 99

  _capture.rc stdlib.io.lock.with "${mock_lock_name}" command_to_run

  assert_rc 99
}

test_stdlib_io_lock_with__valid_args__calls_command() {
  stdlib.io.lock.with "${mock_lock_name}" command_to_run arg1 arg2

  command_to_run.mock.assert_called_once_with \
    "1(arg1) 2(arg2)"
}

test_stdlib_io_lock_with__valid_args__calls_command________fails__returns_correct_status_code() {
 command_to_run.mock.set.rc 99

  _capture.rc stdlib.io.lock.with "${mock_lock_name}" command_to_run

  assert_rc 99
}

test_stdlib_io_lock_with__valid_args__calls_command________fails__releases_lock() {
 command_to_run.mock.set.rc 99

 stdlib.io.lock.with "${mock_lock_name}" command_to_run

 stdlib.io.lock.release.mock.assert_called_once_with "1(${mock_lock_name})"
}


test_stdlib_io_lock_with__valid_args__releases_lock() {
  _capture.rc stdlib.io.lock.with "${mock_lock_name}" command_to_run

  stdlib.io.lock.release.mock.assert_called_once_with "1(${mock_lock_name})"
}

test_stdlib_io_lock_with__valid_args__releases_lock________fails__returns_correct_status_code() {
  stdlib.io.lock.release.mock.set.rc 99

  _capture.rc stdlib.io.lock.with "${mock_lock_name}" command_to_run

  assert_rc 99
}

test_stdlib_io_lock_with__valid_args__sequence_____________correct_sequence() {
  _mock.sequence.record.start

  stdlib.io.lock.with "lockname" command_to_run arg1

  _mock.sequence.assert_is \
    "stdlib.io.lock.workspace_allocate" \
    "stdlib.io.lock.acquire" \
    "command_to_run" \
    "stdlib.io.lock.release"
}