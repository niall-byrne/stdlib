#!/bin/bash

setup() {
  _mock.create command1
  _mock.create command2
  _mock.create command3

  CONCURRENCY_TRACKER="$(mktemp)"

  command1.mock.set.subcommand "_fixture_fail_if_concurrent '${CONCURRENCY_TRACKER}'"
  command2.mock.set.subcommand "_fixture_fail_if_concurrent '${CONCURRENCY_TRACKER}'"
  command3.mock.set.subcommand "_fixture_fail_if_concurrent '${CONCURRENCY_TRACKER}'"

  stdlib.io.lock.workspace_allocate
}

teardown() {
  rm "${CONCURRENCY_TRACKER}"
}

_fixture_fail_if_concurrent() {
  # $1: concurrency tracking file

  stdlib.io.lock.acquire 'testlock' || echo $?

  if ! stdlib.io.path.query.is_file_empty "${1}"; then
    fail "Concurrent Execution Detected!"
  fi

  echo "working" >> "${1}"

  sleep 0.3

  : > "${1}"

  stdlib.io.lock.release 'testlock'
}

# shellcheck disable=SC2034
test_stdlib_io_lock_acquire__concurrent_processes__concurrency_is_limited_to_one_process() {
  local STDLIB_LOCK_WAIT_SECONDS=1

  command1 &
  command2 &
  command3 &

  wait
}
