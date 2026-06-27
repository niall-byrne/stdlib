#!/bin/bash

# stdlib logger extensions to bash_unit assertions

builtin set -eo pipefail

# @description Asserts that the stdlib.logger.error function was mocked and called with specific arguments, or alternatively, not called at all.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @arg $@ array A list of message strings the logger is expected to have been called with.  An empty list asserts that the logger was not called.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if the logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_logger_error_matches() {
  builtin local -a message_args

  assert_is_mock stdlib.logger.error || builtin return "$?"

  # stdlib _mock.create: stdlib.logger.error

  message_args=("${@}")
  _testing.__protected stdlib.array.mutate.filter "$(_testing.__protected_name stdlib.string.query.not_empty)" message_args

  if ! _testing.__protected stdlib.array.query.is_empty message_args; then
    if _testing.__protected stdlib.string.query.has_substring STDLIB_LOGGING_MESSAGE_PREFIX "$(stdlib.logger.error.mock.get.keywords)"; then
      # clean STDLIB_LOGGING_MESSAGE_PREFIX

      _testing.__protected stdlib.array.mutate.format "1(%s) STDLIB_LOGGING_MESSAGE_PREFIX(${STDLIB_LOGGING_MESSAGE_PREFIX})" message_args
    else
      _testing.__protected stdlib.array.mutate.format "1(%s)" message_args
    fi

    stdlib.logger.error.mock.assert_calls_are "${message_args[@]}"
  else

    stdlib.logger.error.mock.assert_not_called
  fi

  # stdlib _mock.delete: stdlib.logger.error
}

# @description Asserts that the stdlib.logger.info function was mocked and called with specific arguments, or alternatively, not called at all.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @arg $@ array A list of message strings the logger is expected to have been called with.  An empty list asserts that the logger was not called.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if the logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_logger_info_matches() {
  builtin local -a message_args

  assert_is_mock stdlib.logger.info || builtin return "$?" # noqa

  # stdlib _mock.create: stdlib.logger.info

  message_args=("${@}")
  _testing.__protected stdlib.array.mutate.filter "$(_testing.__protected_name stdlib.string.query.not_empty)" message_args

  if ! _testing.__protected stdlib.array.query.is_empty message_args; then
    if _testing.__protected stdlib.string.query.has_substring STDLIB_LOGGING_MESSAGE_PREFIX "$(stdlib.logger.info.mock.get.keywords)"; then
      # clean STDLIB_LOGGING_MESSAGE_PREFIX

      _testing.__protected stdlib.array.mutate.format "1(%s) STDLIB_LOGGING_MESSAGE_PREFIX(${STDLIB_LOGGING_MESSAGE_PREFIX})" message_args
    else
      _testing.__protected stdlib.array.mutate.format "1(%s)" message_args
    fi

    stdlib.logger.info.mock.assert_calls_are "${message_args[@]}"
  else

    stdlib.logger.info.mock.assert_not_called
  fi

  # stdlib _mock.delete: stdlib.logger.info
}

# @description Asserts that the stdlib.logger.notice function was mocked and called with specific arguments, or alternatively, not called at all.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @arg $@ array A list of message strings the logger is expected to have been called with.  An empty list asserts that the logger was not called.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if the logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_logger_notice_matches() {
  builtin local -a message_args

  assert_is_mock stdlib.logger.notice || builtin return "$?" # noqa

  # stdlib _mock.create: stdlib.logger.notice

  message_args=("${@}")
  _testing.__protected stdlib.array.mutate.filter "$(_testing.__protected_name stdlib.string.query.not_empty)" message_args

  if ! _testing.__protected stdlib.array.query.is_empty message_args; then
    if _testing.__protected stdlib.string.query.has_substring STDLIB_LOGGING_MESSAGE_PREFIX "$(stdlib.logger.notice.mock.get.keywords)"; then
      # clean STDLIB_LOGGING_MESSAGE_PREFIX

      _testing.__protected stdlib.array.mutate.format "1(%s) STDLIB_LOGGING_MESSAGE_PREFIX(${STDLIB_LOGGING_MESSAGE_PREFIX})" message_args
    else
      _testing.__protected stdlib.array.mutate.format "1(%s)" message_args
    fi

    stdlib.logger.notice.mock.assert_calls_are "${message_args[@]}"
  else

    stdlib.logger.notice.mock.assert_not_called
  fi

  # stdlib _mock.create: stdlib.logger.notice
}

# @description Asserts that the stdlib.logger.success function was mocked and called with specific arguments, or alternatively, not called at all.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @arg $@ array A list of message strings the logger is expected to have been called with.  An empty list asserts that the logger was not called.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if the logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_logger_success_matches() {
  builtin local -a message_args

  assert_is_mock stdlib.logger.success || builtin return "$?" # noqa

  # stdlib _mock.create: stdlib.logger.success

  message_args=("${@}")
  _testing.__protected stdlib.array.mutate.filter stdlib.string.query.not_empty message_args

  if ! _testing.__protected stdlib.array.query.is_empty message_args; then
    if _testing.__protected stdlib.string.query.has_substring STDLIB_LOGGING_MESSAGE_PREFIX "$(stdlib.logger.success.mock.get.keywords)"; then
      # clean STDLIB_LOGGING_MESSAGE_PREFIX

      _testing.__protected stdlib.array.mutate.format "1(%s) STDLIB_LOGGING_MESSAGE_PREFIX(${STDLIB_LOGGING_MESSAGE_PREFIX})" message_args
    else
      _testing.__protected stdlib.array.mutate.format "1(%s)" message_args
    fi

    stdlib.logger.success.mock.assert_calls_are "${message_args[@]}"
  else

    stdlib.logger.success.mock.assert_not_called
  fi

  # stdlib _mock.create: stdlib.logger.success
}

# @description Asserts that the stdlib.logger.warning function was mocked and called with specific arguments, or alternatively, not called at all.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @arg $@ array A list of message strings the logger is expected to have been called with.  An empty list asserts that the logger was not called.
# @exitcode 0 If the assertion passed.
# @exitcode 1 If the assertion fails, or if the logger has not been mocked.
# @stderr The error message if the assertion fails.
assert_logger_warning_matches() {
  builtin local -a message_args

  assert_is_mock stdlib.logger.warning || builtin return "$?"

  # stdlib _mock.create: stdlib.logger.warning

  message_args=("${@}")
  _testing.__protected stdlib.array.mutate.filter "$(_testing.__protected_name stdlib.string.query.not_empty)" message_args

  if ! _testing.__protected stdlib.array.query.is_empty message_args; then
    if _testing.__protected stdlib.string.query.has_substring STDLIB_LOGGING_MESSAGE_PREFIX "$(stdlib.logger.warning.mock.get.keywords)"; then
      # clean STDLIB_LOGGING_MESSAGE_PREFIX

      _testing.__protected stdlib.array.mutate.format "1(%s) STDLIB_LOGGING_MESSAGE_PREFIX(${STDLIB_LOGGING_MESSAGE_PREFIX})" message_args
    else
      _testing.__protected stdlib.array.mutate.format "1(%s)" message_args
    fi

    stdlib.logger.warning.mock.assert_calls_are "${message_args[@]}"
  else

    stdlib.logger.warning.mock.assert_not_called
  fi

  # stdlib _mock.create: stdlib.logger.warning
}
