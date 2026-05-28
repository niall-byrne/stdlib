#!/bin/bash

# stdlib testing parametrize default component

builtin set -eo pipefail

# @description Defaults the keywords used by the exposed parametrization commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN string keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string keyword: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string keyword: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN string keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
# @noargs
# @exitcode 0 If the defaults are set correctly.
# @internal
@parametrize.__internal.default.keywords() {
  # shellcheck disable=SC2034
  { # KCOV_EXCLUDE_LINE # defaults STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
    setting_debug_boolean="${STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN:-"0"}"
    setting_field_separator_char="${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR:-";"}"
    setting_fixture_command_prefix="${STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX:-"@fixture "}"
    setting_original_test_names_boolean="${STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN:-"0"}"
    setting_variant_tag="${STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG:-"@vary"}"
  }
}

# @description Defaults the keywords used by the parametrization aggregation commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The required prefix for parametrizer functions (default="@parametrize_with_").
# @noargs
# @exitcode 0 If the keywords are all valid.
# @internal
@parametrize.__internal.default.keywords_aggregation() {
  # shellcheck disable=SC2034
  { # KCOV_EXCLUDE_LINE # defaults STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX
    setting_fn_prefix="${STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX:-"@parametrize_with_"}"
  }
}
