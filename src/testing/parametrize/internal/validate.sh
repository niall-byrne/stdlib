#!/bin/bash

# stdlib testing parametrize validate component

builtin set -eo pipefail

# @description Validates that a function name refers to a valid parametrizer function.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The required prefix for parametrizer functions (default="@parametrize_with_").
# @arg $1 string The parametrizer function name to validate.
# @exitcode 0 If the parametrizer function name is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.fn_name.parametrizer() {
  # clean STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    builtin return 126
  fi

  if ! stdlib.string.query.starts_with "${STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX}" "${1}"; then
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)"
    builtin return 126
  fi
}

# @description Validates that a function name refers to a valid test function for parametrization.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The required tag in the test function name (default="@vary").
# @arg $1 string The test function name to validate.
# @exitcode 0 If the test function name is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.fn_name.test() {
  # clean STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG

  if ! stdlib.fn.query.is_fn "${1}"; then
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    builtin return 126
  fi

  if ! stdlib.string.query.has_substring "${STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG}" "${1}" ||
    ! stdlib.string.query.starts_with "test" "${1}"; then
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_NAME)"
    builtin return 126
  fi
}

# @description Validates the keywords used by the exposed parametrization commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN boolean keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string keyword: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string keyword: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN boolean keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The tag in the test function name to replace (default="@vary").
# @noargs
# @exitcode 0 If the keywords are all valid.
# @exitcode 125 If an invalid keyword has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.keywords() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  { # KCOV_EXCLUDE_LINE # validates STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_boolean)" STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_char)" STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_boolean)" STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG
  } 2>&1 | _testing.error_pipe "125"
}

# @description Validates the keywords used by the parametrization aggregation commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The prefix for parametrizer functions (default="@parametrize_with_").
# @noargs
# @exitcode 0 If the keywords are all valid.
# @exitcode 125 If an invalid keyword has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.keywords_aggregation() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  { # KCOV_EXCLUDE_LINE # validates STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX
    _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX
  } 2>&1 | _testing.error_pipe "125"
}

# @description Validates the reserved variables used during test parametrization.
#   * __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY array global: An array that stores the name of each generated test function (default=()).
# @noargs
# @exitcode 0 If the reservered variables are all valid.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.reserved_variables() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  { # KCOV_EXCLUDE_LINE # validates __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY
    _testing.__protected stdlib.var.reserved.assert.__is_valid_with "$(_testing.__protected_name stdlib.array.assert.is_array)" __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY name
  } 2>&1 | _testing.error_pipe "123"
}

# @description Validates a single parametrize scenario.
# @arg $1 string The name of the array containing environment variable names.
# @arg $2 string The name of the array containing fixture commands.
# @arg $3 string The name of the array containing the scenario configuration.
# @exitcode 0 If the scenario configuration is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stdout The informational messages.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.scenario() {
  builtin local validate_env_var_indirect_array_reference
  builtin local -a validate_env_var_indirect_array
  builtin local validate_fixture_indirect_command_array_reference
  builtin local -a validate_fixture_indirect_command_array
  builtin local validate_scenario_indirect_array_reference
  builtin local -a validate_scenario_indirect_array

  validate_env_var_indirect_array_reference="${1}[@]"
  validate_env_var_indirect_array=("${!validate_env_var_indirect_array_reference}")
  validate_fixture_indirect_command_array_reference="${2}[@]"
  validate_fixture_indirect_command_array=("${!validate_fixture_indirect_command_array_reference}")
  validate_scenario_indirect_array_reference="${3}[@]"
  validate_scenario_indirect_array=("${!validate_scenario_indirect_array_reference}")

  builtin local validation_index

  if (("${#validate_scenario_indirect_array[@]}" != "${#validate_env_var_indirect_array[@]}" + 1)); then
    {
      _testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES
      builtin echo
      for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++)); do
        builtin echo "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}"
      done
      _testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES
      builtin echo
    } >&2 # KCOV_EXCLUDE_LINE

    _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")"

    builtin return 126
  fi
}
