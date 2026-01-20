#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/security/shell/shell.snippet"

setup() {
  _mock.create exit
  _mock.create stdlib.security.__shell.query.is_safe
}

@parametrize_with_keywords() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_KEYWORD" \
    "mock_keyword1;keyword1" \
    "mock_keyword2;keyword2"
}

@parametrize_with_return() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_KEYWORD" \
    "return_______;return"
}

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__calls_unset() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "1"

  _capture.rc stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}" 2> /dev/null

  stdlib.security.__shell.query.is_safe.mock.assert_called_once_with "1(${TEST_KEYWORD})"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__calls_unset \
  @parametrize_with_return \
  @parametrize_with_keywords

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__returns_status_code_1() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "1"

  _capture.rc stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}" 2> /dev/null

  assert_rc "1"
  exit.mock.assert_not_called
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__returns_status_code_1 \
  @parametrize_with_keywords

test_stdlib_security_shell_snippet_assert_is_safe__@vary____@vary__is_unsafe__exits_with_status_code_1() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "1"

  stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}" 2> /dev/null

  exit.mock.assert_called_once_with "1(1)"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary____@vary__is_unsafe__exits_with_status_code_1 \
  @parametrize_with_return

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__generates_stderr() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "1"

  _capture.stderr stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}"

  assert_output "FATAL ERROR: The 'builtin' keyword could not be verified!  Cannot safely load stdlib!"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_unsafe__generates_stderr \
  @parametrize_with_return \
  @parametrize_with_keywords

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____calls_unset() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "0"

  _capture.rc stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}" 2> /dev/null

  stdlib.security.__shell.query.is_safe.mock.assert_called_once_with "1(${TEST_KEYWORD})"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____calls_unset \
  @parametrize_with_return \
  @parametrize_with_keywords

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____returns_status_code_0() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "0"

  _capture.rc stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}" 2> /dev/null

  assert_rc "0"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____returns_status_code_0 \
  @parametrize_with_return \
  @parametrize_with_keywords

test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____generates_no_stderr() {
  stdlib.security.__shell.query.is_safe.mock.set.stdout "0"

  _capture.output stdlib.security.__shell.assert.is_safe "${TEST_KEYWORD}"

  assert_null "${TEST_OUTPUT}"
}

@parametrize.apply \
  test_stdlib_security_shell_snippet_assert_is_safe__@vary__@vary__is_safe____generates_no_stderr \
  @parametrize_with_return \
  @parametrize_with_keywords
