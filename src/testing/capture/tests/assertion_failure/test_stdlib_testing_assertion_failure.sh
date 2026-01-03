#!/bin/bash

test_stdlib_testing_capture_assertion_failure__does_not_fail__generates_correct_error() {
  _mock.create fail

  _capture.assertion_failure assert_equals 1 1

  assert_equals fail.mock.get.count "1"
  fail.mock.assert_call_n_is 1 "1($(_testing.assert.message.get ASSERT_ERROR_DID_NOT_FAIL "assert_equals")"

  _mock.delete fail
}

test_stdlib_testing_capture_assertion_failure__fails__________generates_correct_output() {
  _capture.assertion_failure assert_equals 1 2

  assert_output " expected [1] but was [2]"
}
