#!/bin/bash

# stdlib testing parametrize compose library

builtin set -eo pipefail

# @description Composes multiple parametrizer functions to create a product of scenarios.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN string keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string keyword: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string keyword: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The required prefix for parametrizer functions (default="@parametrize_with_").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN string keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
# @arg $1 string The name of the test function to parametrize.
# @arg $@ array A series of parametrizer functions to compose.
# @exitcode 0 If the parametrizer functions were composed successfully.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
@parametrize.compose() {
  builtin local -a __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY # defaults __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY
  builtin local original_test_function_name="${1}"
  builtin local parametrizer_fn
  builtin local -a parametrizer_fn_array
  builtin local parametrizer_fn_target
  builtin local -a parametrizer_fn_targets
  builtin local parametrizer_index=0

  # shellcheck disable=SC2034
  {
    builtin local setting_debug_boolean
    builtin local setting_field_separator_char
    builtin local setting_fixture_command_prefix
    builtin local setting_original_test_names_boolean
    builtin local setting_variant_tag
    builtin local setting_fn_prefix

    @parametrize.__internal.default.keywords
    @parametrize.__internal.default.keywords_aggregation
  }

  @parametrize.__internal.validate.keywords || builtin return 125             # validates STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
  @parametrize.__internal.validate.keywords_aggregation || builtin return 125 # validates STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX
  @parametrize.__internal.validate.reserved_variables || builtin return 123   # validates __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY

  parametrizer_fn_array=("${@:2}")

  [[ "${#@}" -gt "1" ]] || {
    _testing.__protected stdlib.logger.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126

  parametrizer_fn_targets=("${original_test_function_name}")
  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    @parametrize.__internal.validate.fn_name.parametrizer "${parametrizer_fn}" || builtin return 126
    __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY=()
    for parametrizer_fn_target in "${parametrizer_fn_targets[@]}"; do
      "${parametrizer_fn}" "${parametrizer_fn_target}" || builtin return "$?"
    done
    parametrizer_fn_targets=("${__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY[@]}")
  done

  builtin unset -f "${original_test_function_name}"
}
