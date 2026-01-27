#!/bin/bash

# stdlib testing parametrize validate component

builtin set -eo pipefail

# @description Validates that a function name refers to a valid parametrizer function.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX: The required prefix for parametrizer functions (default="@parametrize_with_").
# @arg $1 string The parametrizer function name to validate.
# @exitcode 0 If the parametrizer function name is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.fn_name.parametrizer() {
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
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG: The required tag in the test function name (default="@vary").
# @arg $1 string The test function name to validate.
# @exitcode 0 If the test function name is valid.
# @exitcode 126 If an invalid argument has been provided.
# @stderr The error message if validation fails.
# @internal
@parametrize.__internal.validate.fn_name.test() {
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
    _testing.error \
      "$(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values" \
      "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")"
    builtin return 126
  fi
}
