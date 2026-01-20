#!/bin/bash

_testing.load "${STDLIB_DIRECTORY}/security/shell/shell.snippet"

setup() {
  _mock.create type
  _mock.create declare
  _mock.create unset
}

_fixture_declare_returns_builtin() {
  declare.mock.set.rc 1
}

_fixture_declare_returns_function() {
  declare.mock.set.rc 0
}

_fixture_type_returns_builtin() {
  type.mock.set.stdout "builtin"
}

_fixture_type_returns_function() {
  type.mock.set.stdout "function"
}

_fixture_unset_returns_0() {
  unset.mock.set.rc 0
}

_fixture_unset_returns_1() {
  unset.mock.set.rc 1
}

@parametrize_with_failure_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FIXTURE_LIST" \
    "declare_builtin___type_function__unset_0;_fixture_declare_returns_builtin|_fixture_declare_returns_function|_fixture_unset_returns_0" \
    "declare_function__type_builtin___unset_0;_fixture_declare_returns_function|_fixture_type_returns_builtin|_fixture_unset_returns_0" \
    "declare_function__type_function__unset_0;_fixture_declare_returns_function|_fixture_declare_returns_function|_fixture_unset_returns_0" \
    "declare_builtin___type_function__unset_1;_fixture_declare_returns_builtin|_fixture_declare_returns_function|_fixture_unset_returns_1" \
    "declare_function__type_builtin___unset_1;_fixture_declare_returns_function|_fixture_type_returns_builtin|_fixture_unset_returns_1" \
    "declare_function__type_function__unset_1;_fixture_declare_returns_function|_fixture_declare_returns_function|_fixture_unset_returns_1" \
    "declare_builtin___type_builtin___unset_1;_fixture_declare_returns_builtin|_fixture_type_returns_builtin|_fixture_unset_returns_1"
}

@parametrize_with_success_combos() {
  # $1: the test function to parametrize

  @parametrize \
    "${1}" \
    "TEST_FIXTURE_LIST" \
    "declare_builtin___type_builtin___unset_0;_fixture_declare_returns_builtin|_fixture_type_returns_builtin|_fixture_unset_returns_0"
}

test_stdlib_security_snippet_builtin_query_is_safe__@vary__emits_1() {
  local fixtures=()
  local fixture

  stdlib.array.make.from_string fixtures "|" "${TEST_FIXTURE_LIST}"
  for fixture in "${fixtures[@]}"; do
    "${fixture}"
  done

  _capture.stdout stdlib.security.__shell.query.is_safe

  assert_output "1"
}

@parametrize_with_failure_combos \
  test_stdlib_security_snippet_builtin_query_is_safe__@vary__emits_1

test_stdlib_security_snippet_builtin_query_is_safe__@vary__emits_0() {
  local fixtures=()
  local fixture

  stdlib.array.make.from_string fixtures "|" "${TEST_FIXTURE_LIST}"
  for fixture in "${fixtures[@]}"; do
    "${fixture}"
  done

  _capture.stdout stdlib.security.__shell.query.is_safe

  assert_output "0"
}

@parametrize_with_success_combos \
  test_stdlib_security_snippet_builtin_query_is_safe__@vary__emits_0
