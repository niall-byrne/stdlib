#!/bin/bash

setup() {
  _mock.create stdlib.__gettext.call
}

@parametrize_with_messages() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_MESSAGE" \
    "simple_message____;just a simple message" \
    "whitespace_message;a message \t \n with special whitespace characters"
}

test_stdlib_gettext__@vary__calls_underlying_gettext_function() {
  stdlib.__gettext "${TEST_MESSAGE}"

  stdlib.__gettext.call.mock.assert_called_once_with \
    "1(stdlib) 2(${TEST_MESSAGE})"
}

@parametrize_with_messages \
  test_stdlib_gettext__@vary__calls_underlying_gettext_function
