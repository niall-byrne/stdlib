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

  if [[ -s "${1}" ]]; then
    fail "Concurrent Execution Detected!"
  fi

  echo "working" >> "${1}"

  sleep 0.3

  : > "${1}"

  stdlib.io.lock.release 'testlock'
}

test_stdlib_io_lock_acquire__concurrent_processes__concurrency_is_limited_to_one_process() {
  command1 &
  command2 &
  command3 &

  wait
}
