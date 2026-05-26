#!/bin/bash

test_stdlib_testing_assert_logger_warning_matches__no_logger_mock__fails() {
  _capture.assertion_failure assert_logger_warning_matches "message1" "message2"

  assert_equals \
    " $(_testing.assert.__message.get ASSERT_ERROR_IS_NOT_MOCK "stdlib.logger.warning")" \
    "${TEST_OUTPUT}"
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____no_match__no_keywords__fails() {
  _mock.create stdlib.logger.warning

  _capture.assertion_failure assert_logger_warning_matches "message1" "message2"

  assert_output \
    "$(_testing.mock.__message.get MOCK_NOT_CALLED "stdlib.logger.warning")"
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____no_match__keywords_____fails() {
  _mock.create stdlib.logger.warning

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    _capture.assertion_failure assert_logger_warning_matches "message1" "message2"

  assert_output \
    "$(_testing.mock.__message.get MOCK_NOT_CALLED "stdlib.logger.warning")"
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____match_____no_keywords__call_____succeeds() {
  _mock.create stdlib.logger.warning

  stdlib.logger.warning "message1"
  stdlib.logger.warning "message2"

  assert_logger_warning_matches \
    "message1" \
    "message2"
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____match_____no_keywords__no_call__succeeds() {
  _mock.create stdlib.logger.warning

  assert_logger_warning_matches ""
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____match_____keyword______call_____succeeds() {
  _mock.create stdlib.logger.warning
  stdlib.logger.warning.mock.set.keywords STDLIB_LOGGING_MESSAGE_PREFIX

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    stdlib.logger.warning "message1"
  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    stdlib.logger.warning "message2"

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    assert_logger_warning_matches \
    "message1" \
    "message2"
}

test_stdlib_testing_assert_logger_warning_matches__logger_mock_____match_____keyword______no_call__succeeds() {
  _mock.create stdlib.logger.warning
  stdlib.logger.warning.mock.set.keywords STDLIB_LOGGING_MESSAGE_PREFIX

  STDLIB_LOGGING_MESSAGE_PREFIX="prefix" \
    assert_logger_warning_matches ""
}
