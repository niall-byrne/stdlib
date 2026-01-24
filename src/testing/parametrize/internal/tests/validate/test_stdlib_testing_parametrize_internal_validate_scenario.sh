#!/bin/bash

setup() {
  _mock.create _testing.error
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__not_enough_values__generates_error_message() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  _testing.error.mock.assert_called_once_with \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)) 2($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): scenario_name) 3($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ENV_VAR1 ENV_VAR2 = 2 variables) 4($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): value1 = 1 values) 5($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): 'echo fixture1' )"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__not_enough_values__generates_stderr_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  assert_output $"$(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES)
  ENV_VAR1 = value1
  ENV_VAR2 = "$'\n'"$(_testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES)"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__too_many_values____generates_error_message() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2" "value3")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  _testing.error.mock.assert_called_once_with \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)) 2($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): scenario_name) 3($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ENV_VAR1 ENV_VAR2 = 2 variables) 4($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): value1 value2 value3 = 3 values) 5($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): 'echo fixture1' )"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__too_many_values____generates_stderr_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2" "value3")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  assert_output "$(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES)
  ENV_VAR1 = value1
  ENV_VAR2 = value2
$(_testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES)"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__correct_values_____does_not_generate_an_error_message() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  _testing.error.mock.assert_not_called
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__correct_values_____does_not_generate_stderr_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  assert_output_null
}
