#!/bin/bash

test_stdlib_testing_assert_logger_error_matches__no_logger_mock__fails() {
  _capture.assertion_failure assert_logger_error_matches "message1" "message2"

  assert_equals \
    " $(_testing.assert.__message.get ASSERT_ERROR_IS_NOT_MOCK "stdlib.logger.error")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____no_match__no_keywords__fails() {
  _mock.create stdlib.logger.error

  _capture.assertion_failure assert_logger_error_matches "message1" "message2"

  assert_output \
    "$(_testing.mock.__message.get MOCK_NOT_CALLED "stdlib.logger.error")"
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____no_match__keywords_____fails() {
  _mock.create stdlib.logger.error

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    _capture.assertion_failure assert_logger_error_matches "message1" "message2"

  assert_output \
    "$(_testing.mock.__message.get MOCK_NOT_CALLED "stdlib.logger.error")"
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____match_____no_keywords__call_____succeeds() {
  _mock.create stdlib.logger.error

  stdlib.logger.error "message1"
  stdlib.logger.error "message2"

  assert_logger_error_matches \
    "message1" \
    "message2"
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____match_____no_keywords__no_call__succeeds() {
  _mock.create stdlib.logger.error

  assert_logger_error_matches ""
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____match_____keyword______call_____succeeds() {
  _mock.create stdlib.logger.error
  stdlib.logger.error.mock.set.keywords STDLIB_LOGGING_MESSAGE_PREFIX

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    stdlib.logger.error "message1"
  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    stdlib.logger.error "message2"

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    assert_logger_error_matches \
    "message1" \
    "message2"
}

test_stdlib_testing_assert_logger_error_matches__logger_mock_____match_____keyword______no_call__succeeds() {
  _mock.create stdlib.logger.error
  stdlib.logger.error.mock.set.keywords STDLIB_LOGGING_MESSAGE_PREFIX

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    assert_logger_error_matches ""
}
