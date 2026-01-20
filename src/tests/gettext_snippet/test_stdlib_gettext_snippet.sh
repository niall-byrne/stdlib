#!/bin/bash

setup() {
  _mock.create stdlib.__gettext.fallback
  _mock.create source
}

_fixture_load_module() {
  _STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 \
    _testing.load "${STDLIB_DIRECTORY}/gettext.snippet" > /dev/null
}

@parametrize_with_gettext_vars() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_NAME" \
    "textdomain___;TEXTDOMAIN" \
    "textdomaindir;TEXTDOMAINDIR"
}

@parametrize_with_source_rc() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_SOURCE_RC" \
    "source_fails___;0" \
    "source_succeeds;1"
}

test_stdlib_gettext_snippet__sourced__@vary__@vary__is_exported() {
  source.mock.set.rc "${TEST_SOURCE_RC}"

  _fixture_load_module

  assert_equals \
    "declare -x ${TEST_VARIABLE_NAME}" \
    "$(declare -p "${TEST_VARIABLE_NAME}")"
}

@parametrize.compose \
  test_stdlib_gettext_snippet__sourced__@vary__@vary__is_exported \
  @parametrize_with_source_rc \
  @parametrize_with_gettext_vars

test_stdlib_gettext_snippet__sourced__@vary__calls_sources_correct_file() {
  source.mock.set.rc "${TEST_SOURCE_RC}"

  _fixture_load_module

  source.mock.assert_called_once_with "1(gettext.sh)"
}

@parametrize_with_source_rc \
  test_stdlib_gettext_snippet__sourced__@vary__calls_sources_correct_file

test_stdlib_gettext_snippet__sourced__source_fails_____loads_fallback() {
  source.mock.set.rc 1

  _fixture_load_module

  stdlib.__gettext.fallback.mock.assert_called_once_with ""
}

test_stdlib_gettext_snippet__sourced__source_succeeds__does_not_load_fallback() {
  source.mock.set.rc 0

  _fixture_load_module

  stdlib.__gettext.fallback.mock.assert_not_called
}
