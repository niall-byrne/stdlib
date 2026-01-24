#!/bin/bash

test_stdlib_testing_assert_null__when_not_null__fails_as_expected() {
  _capture.assertion_failure assert_null "not_null"

  assert_equals \
    " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NOT_NULL "not_null")"$'\n'" expected [] but was [not_null]" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_null__when_is_null___succeeds_as_expected() {
  assert_null ""
}
