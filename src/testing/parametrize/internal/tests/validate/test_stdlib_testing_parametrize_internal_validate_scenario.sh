#!/bin/bash

setup() {
  _mock.create stdlib.testing.internal.logger.error
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__not_enough_values__generates_error_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1")

  @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES))" \
    "1(  ENV_VAR1 = value1)" \
    "1(  ENV_VAR2 = )" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): scenario_name)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ENV_VAR1 ENV_VAR2 = 2 variables)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): value1 = 1 values)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): 'echo fixture1' )"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__too_many_values____generates_error_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2" "value3")

  @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  stdlib.testing.internal.logger.error.mock.assert_calls_are \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES))" \
    "1(  ENV_VAR1 = value1)" \
    "1(  ENV_VAR2 = value2)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR))" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): scenario_name)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ENV_VAR1 ENV_VAR2 = 2 variables)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): value1 value2 value3 = 3 values)" \
    "1($(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): 'echo fixture1' )"
}

# shellcheck disable=SC2034
test_parametrize_internal_validate_scenario__correct_values_____does_not_generate_error_messages() {
  local env_vars=("ENV_VAR1" "ENV_VAR2")
  local fixtures=("echo fixture1")
  local scenarios=("scenario_name" "value1" "value2")

  _capture.stderr @parametrize.__internal.validate.scenario \
    env_vars \
    fixtures \
    scenarios

  stdlib.testing.internal.logger.error.mock.assert_not_called
}
