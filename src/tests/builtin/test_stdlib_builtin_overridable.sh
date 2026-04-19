#!/bin/bash

# shellcheck disable=SC2034
_fixture_secure_distribution() {

  local __STDLIB_SECURE_DISTRIBUTION=1

  _testing.load "${STDLIB_DIRECTORY}/builtin.sh" > /dev/null
}

# shellcheck disable=SC2034
_fixture_testable_distribution() {

  local __STDLIB_SECURE_DISTRIBUTION=0

  _testing.load "${STDLIB_DIRECTORY}/builtin.sh" > /dev/null
}

test_stdlib_builtin_overridable__secure_distribution____default_behaviour______________does_not_allow_override() {
  _fixture_secure_distribution
  _mock.create echo

  stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}

test_stdlib_builtin_overridable__secure_distribution____environment_variable_set_to_1__does_not_allow_override() {
  _fixture_secure_distribution
  _mock.create echo

  STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 \
    stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}

test_stdlib_builtin_overridable__secure_distribution____environment_variable_set_to_0__does_not_allow_override() {
  _fixture_secure_distribution
  _mock.create echo

  STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=0 \
    stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}

test_stdlib_builtin_overridable__testable_distribution__default_behaviour______________does_not_allow_override() {
  _fixture_testable_distribution
  _mock.create echo

  stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}

test_stdlib_builtin_overridable__testable_distribution__environment_variable_set_to_1__allows_override() {
  _fixture_testable_distribution
  _mock.create echo

  STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 \
    stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_called_once_with "1(hello)"

  _mock.delete echo
}

test_stdlib_builtin_overridable__testable_distribution__environment_variable_set_to_0__does_not_allow_override() {
  _fixture_testable_distribution
  _mock.create echo

  STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=0 \
    stdlib.__builtin.overridable echo "hello" > /dev/null

  echo.mock.assert_not_called

  _mock.delete echo
}
