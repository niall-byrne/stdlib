#!/bin/bash

# shellcheck disable=SC2034
setup() {
  _mock.create test_mock

  TESTING_LOCK_ACQUIRE=""
  TESTING_LOCK_RELEASE=""

  # shellcheck disable=SC2317,SC2329
  stdlib.testing.internal.io.lock.acquire() {
    TESTING_LOCK_ACQUIRE="${1}"
  }

  # shellcheck disable=SC2317,SC2329
  stdlib.testing.internal.io.lock.release() {
    TESTING_LOCK_RELEASE="${1}"
  }
}

test_stdlib_testing_mock_object_call_locking__sequence_recording_____lock_is_acquired() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN=1

  test_mock

  assert_equals \
    "${__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME}" \
    "${TESTING_LOCK_ACQUIRE}"
}

test_stdlib_testing_mock_object_call_locking__sequence_recording_____lock_is_released() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN=1

  test_mock

  assert_equals \
    "${__STDLIB_TESTING_MOCK_SEQUENCE_LOCK_NAME}" \
    "${TESTING_LOCK_RELEASE}"
}

test_stdlib_testing_mock_object_call_locking__no_sequence_recording__lock_is_not_acquired() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN=0

  test_mock

  assert_null "${TESTING_LOCK_ACQUIRE}"
}

test_stdlib_testing_mock_object_call_locking__no_sequence_recording__lock_is_not_released() {
  local __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN=0

  test_mock

  assert_null "${TESTING_LOCK_RELEASE}"
}
