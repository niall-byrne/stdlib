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
  builtin local setting_fn_prefix="${setting_fn_prefix}" # clean STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX

  if ! _testing.__protected stdlib.fn.query.is_fn "${1}"; then
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    builtin return 126
  fi

  if ! _testing.__protected stdlib.string.query.starts_with "${setting_fn_prefix}" "${1}"; then
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME "${setting_fn_prefix}")"
    builtin return 126
  fi
}

# @description Validates that a function name refers to a valid test function for parametrization.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
# @arg $1 string The test function name to validate.
# @exitcode 0 If the test function name is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.fn_name.test() {
  builtin local setting_variant_tag="${setting_variant_tag}" # clean STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG

  if ! _testing.__protected stdlib.fn.query.is_fn "${1}"; then
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)"
    builtin return 126
  fi

  if ! _testing.__protected stdlib.string.query.has_substring "${setting_variant_tag}" "${1}" ||
    ! _testing.__protected stdlib.string.query.starts_with "test" "${1}"; then
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_NAME "${setting_variant_tag}")"
    builtin return 126
  fi
}

# @description Validates the keywords used by the exposed parametrization commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN string keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR string keyword: The field separator for scenarios (default=";").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX string keyword: The prefix for fixture commands (default="@fixture ").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN string keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
# @noargs
# @exitcode 0 If the keywords are all valid.
# @exitcode 125 If an invalid keyword has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.keywords() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"
  builtin local setting_debug_boolean="${setting_debug_boolean}" # contains STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN

  { # KCOV_EXCLUDE_LINE # validates STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR,STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX,STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN,STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG

    STDLIB_KW_SOURCE_VAR="setting_debug_boolean" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_boolean)" STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN || builtin return 125

    STDLIB_KW_SOURCE_VAR="setting_field_separator_char" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_char)" STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR || builtin return 125

    STDLIB_KW_SOURCE_VAR="setting_fixture_command_prefix" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX || builtin return 125

    STDLIB_KW_SOURCE_VAR="setting_original_test_names_boolean" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.is_boolean)" STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN || builtin return 125

    STDLIB_KW_SOURCE_VAR="setting_variant_tag" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG || builtin return 125
  }
}

# @description Validates the keywords used by the parametrization aggregation commands.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The required prefix for parametrizer functions (default="@parametrize_with_").
# @noargs
# @exitcode 0 If the keywords are all valid.
# @exitcode 125 If an invalid keyword has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.keywords_aggregation() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  { # KCOV_EXCLUDE_LINE # validates STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX
    STDLIB_KW_SOURCE_VAR="setting_fn_prefix" \
      _testing.__protected stdlib.fn.keyword.assert.is_valid_with "$(_testing.__protected_name stdlib.string.assert.not_empty)" STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX || builtin return 125
  }
}

# @description Validates the reserved variables used during test parametrization.
#   * __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY array reserved: An array that stores the name of each generated test function (default=()).
# @noargs
# @exitcode 0 If the reservered variables are all valid.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.reserved_variables() {
  # shellcheck disable=SC2034
  builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${STDLIB_LOGGING_MESSAGE_PREFIX:-"${FUNCNAME[2]}"}"

  { # KCOV_EXCLUDE_LINE # validates __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY
    _testing.__protected stdlib.var.reserved.assert.__is_valid_with "$(_testing.__protected_name stdlib.array.assert.is_array)" __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY name || builtin return 123
  }
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
    builtin local STDLIB_LOGGING_MESSAGE_PREFIX="${FUNCNAME[3]}"

    {
      _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES)"
      for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++)); do
        _testing.__protected stdlib.logger.error "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}"
      done
      _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES)"
    } >&2 # KCOV_EXCLUDE_LINE

    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values"
    _testing.__protected stdlib.logger.error "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")"

    builtin return 126
  fi
}
