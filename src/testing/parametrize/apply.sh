#!/bin/bash

# stdlib testing parametrize apply library

builtin set -eo pipefail

# @description Applies multiple parametrizer functions to a test function.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN boolean global: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string global: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string global: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string global: The prefix for parametrizer functions (default="@parametrize_with_").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN boolean global: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string global: The tag in the test function name to replace (default="@vary").
# @arg $1 string The name of the test function to parametrize.
# @arg $@ array A series of parametrizer functions to apply.
# @exitcode 0 If the parametrizer functions were applied successfully.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
@parametrize.apply() {
  builtin local original_test_function_name=""
  builtin local parametrized_test_function_name=""
  builtin local parametrizer_index=0
  builtin local parametrizer_fn
  builtin local -a parametrizer_fn_array
  builtin local -a parametrizer_variant_array
  builtin local parametrizer_variant_tag_padding

  @parametrize.__internal.validate.keywords || builtin return 125             # validates STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
  @parametrize.__internal.validate.keywords_aggregation || builtin return 125 # validates STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX

  original_test_function_name="${1}"
  parametrizer_fn_array=("${@:2}")

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126

  @parametrize.__internal.create.array.fn_variant_tags parametrizer_variant_tag_padding \
    parametrizer_variant_array \
    "${@:2}" || builtin return 126

  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    parametrized_test_function_name="$(
      @parametrize.__internal.create.string.padded_test_fn_variant_name \
        "${original_test_function_name}" \
        "${parametrizer_variant_array[parametrizer_index]}" \
        "${parametrizer_variant_tag_padding}"
    )"
    stdlib.fn.derive.clone "${original_test_function_name}" \
      "${parametrized_test_function_name}"

    "${parametrizer_fn}" "${parametrized_test_function_name}" || builtin return "$?"
  done

  builtin unset -f "${original_test_function_name}"
}
