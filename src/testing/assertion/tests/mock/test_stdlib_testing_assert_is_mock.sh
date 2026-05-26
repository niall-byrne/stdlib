#!/bin/bash

_fixture_test_fn() { :; }

test_stdlib_testing_assert_is_mock__object_is_mock_________succeeds() {
  _mock.create test_mock

  assert_is_mock "test_mock"
}

test_stdlib_testing_assert_is_mock__object_is_fn___________fails() {
  _capture.assertion_failure assert_is_mock "_fixture_test_fn"

  assert_equals \
    " $(_testing.assert.__message.get ASSERT_ERROR_IS_NOT_MOCK "_fixture_test_fn")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_is_mock__object_does_not_exist__fails() {
  _capture.assertion_failure assert_is_mock "_non_existent"

  assert_equals \
    " $(_testing.assert.__message.get ASSERT_ERROR_IS_NOT_MOCK "_non_existent")" \
    "${TEST_OUTPUT}"
}
