#!/bin/bash

setup() {
  _mock.create eval_gettext

  eval_gettext.mock.set.keywords "TEXTDOMAIN" "TEXTDOMAINDIR"
}

@parametrize_with_locales() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_LOCALE" \
    "locale1;/path1/locale1" \
    "locale2;/path2/locale2"
}

@parametrize_with_domains() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_DOMAIN" \
    "domain1;domain1" \
    "domain2;domain2"
}

@parametrize_with_messages() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_MESSAGE" \
    "simple_message____;just a simple message" \
    "whitespace_message;a message \t \n with special whitespace characters"
}

# shellcheck disable=SC2034
test_stdlib_gettext_call__@vary__@vary__@vary__calls_underlying_eval_gettext_function() {
  local STDLIB_TEXTDOMAINDIR="${TEST_LOCALE}"
  local TEXTDOMAIN="mock_domain"
  local TEXTDOMAINDIR="mock_domain_dir"

  # shellcheck disable=SC2153
  stdlib.__gettext.call "${TEST_DOMAIN}" "${TEST_MESSAGE}"

  eval_gettext.mock.assert_called_once_with \
    "1(${TEST_MESSAGE}) TEXTDOMAIN(${TEST_DOMAIN}) TEXTDOMAINDIR(${TEST_LOCALE})"
}

@parametrize.compose \
  test_stdlib_gettext_call__@vary__@vary__@vary__calls_underlying_eval_gettext_function \
  @parametrize_with_locales \
  @parametrize_with_domains \
  @parametrize_with_messages

# shellcheck disable=SC2034
test_stdlib_gettext_call__@vary__@vary__@vary__restores_original_gettext_env_vars() {
  local STDLIB_TEXTDOMAINDIR="${TEST_LOCALE}"
  local TEXTDOMAIN="mock_domain"
  local TEXTDOMAINDIR="mock_domain_dir"

  stdlib.__gettext.call "${TEST_DOMAIN}" "${TEST_MESSAGE}"

  assert_equals "mock_domain" "${TEXTDOMAIN}"
  assert_equals "mock_domain_dir" "${TEXTDOMAINDIR}"
}

@parametrize.compose \
  test_stdlib_gettext_call__@vary__@vary__@vary__restores_original_gettext_env_vars \
  @parametrize_with_locales \
  @parametrize_with_domains \
  @parametrize_with_messages
