#!/bin/bash

# stdlib testing parametrize library

builtin set -eo pipefail


# @description Parametrizes a test function with multiple scenarios.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN string keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string keyword: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string keyword: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN string keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
#   * STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT string global: A theme colour used to highlight informational messages (default="LIGHT_BLUE").
# @arg $1 string The name of the test function to parametrize.
# @arg $@ array Optional fixture commands (prefixed with '@fixture '), followed by a semicolon-separated list of variable names, and then one or more semicolon-separated scenarios (scenario name followed by values).
# @exitcode 0 If the test function was parametrized successfully.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @exitcode 125 If an invalid keyword has been provided.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The informational messages.
# @stderr The error message if the operation fails.
@parametrize() {
  # shellcheck disable=SC2034
  {
    builtin local -a array_environment_variables
    builtin local -a array_fixture_commands
    builtin local -a array_scenario_values
  }
  builtin local original_test_function_name=""
  builtin local original_test_function_reference=""
  builtin local -a parametrize_configuration
  builtin local parametrize_configuration_index=0
  builtin local parametrize_configuration_line=""
  builtin local parametrize_configuration_scenario_start_index
  builtin local test_function_variant_name=""
  builtin local test_function_variant_padding_value=0

  # shellcheck disable=SC2034
  builtin local PARAMETRIZE_SCENARIO_NAME

  # shellcheck disable=SC2034
  {
    builtin local setting_debug_boolean
    builtin local setting_field_separator_char
    builtin local setting_fixture_command_prefix
    builtin local setting_original_test_names_boolean
    builtin local setting_variant_tag

    #setting_debug_boolean="$(stdlib.fn.keyword.consume STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN "0")"
    #setting_field_separator_char="$(stdlib.fn.keyword.consume STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR ";")"
    #setting_fixture_command_prefix="$(stdlib.fn.keyword.consume STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX "@fixture ")"
    #setting_original_test_names_boolean="$(stdlib.fn.keyword.consume STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN "0")"
    #setting_variant_tag="$(stdlib.fn.keyword.consume STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG "@vary")"

    @parametrize.__internal.default.keywords

    STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN=""
    STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR=""
    STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX=""
    STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN=""
    STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG=""
  }

  @parametrize.__internal.validate.keywords || builtin return 125           # validates STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
  @parametrize.__internal.validate.reserved_variables || builtin return 123 # validates __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY

  original_test_function_name="${1}"
  original_test_function_reference="__parametrized_original_function_definition_${1}"

  [[ "${#@}" -gt "1" ]] || {
    _testing.__protected stdlib.logger.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return "$?"

  stdlib.fn.derive.clone "${original_test_function_name}" \
    "${original_test_function_reference}"

  builtin unset -f "${1}"

  builtin shift

  parametrize_configuration=("${@}")

  @parametrize.__internal.configuration.parse parametrize_configuration \
    parametrize_configuration_scenario_start_index \
    array_environment_variables \
    array_fixture_commands \
    test_function_variant_padding_value || builtin return "$?"

  parametrize_configuration=("${parametrize_configuration[@]:parametrize_configuration_scenario_start_index}")

  for ((parametrize_configuration_index = 0; "${parametrize_configuration_index}" < "${#parametrize_configuration[@]}"; parametrize_configuration_index++)); do
    parametrize_configuration_line="${parametrize_configuration[parametrize_configuration_index]}"
    IFS="${setting_field_separator_char}" builtin read -ra array_scenario_values <<< "${parametrize_configuration_line}"

    test_function_variant_name="$(
      @parametrize.__internal.create.string.padded_test_fn_variant_name \
        "${original_test_function_name}" \
        "${array_scenario_values[0]}" \
        "${test_function_variant_padding_value}"
    )"

    if stdlib.fn.query.is_fn "${test_function_variant_name}"; then
      _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)"
      {
        _testing.parametrize.__message.get PARAMETRIZE_PREFIX_TEST_NAME
        # KCOV_EXCLUDE_BEGIN
        builtin echo ": '$( # validates STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT
          _testing.__protected stdlib.string.colour \
            "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" \
            "${original_test_function_name}"
        )'"
        # KCOV_EXCLUDE_END

        _testing.parametrize.__message.get PARAMETRIZE_PREFIX_VARIANT_NAME
        # KCOV_EXCLUDE_BEGIN
        builtin echo ": '$( # validates STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT
          _testing.__protected stdlib.string.colour \
            "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" \
            "${test_function_variant_name}"
        )'"
        # KCOV_EXCLUDE_END

      } >&2 # KCOV_EXCLUDE_LINE
      _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)"
      builtin return 126
    fi

    @parametrize.__internal.create.fn.test_variant "${test_function_variant_name}" \
      "${original_test_function_name}" \
      "${original_test_function_reference}" \
      array_environment_variables \
      array_fixture_commands \
      array_scenario_values

    # Usage of this array is not documented on the public API.
    __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY+=("${test_function_variant_name}") # noqa

  done
}
