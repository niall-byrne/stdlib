#!/bin/bash

# stdlib testing parametrize messages library

builtin set -eo pipefail

_testing.parametrize.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1

  builtin local key="${1}"
  builtin local message
  builtin local option1="${2}"
  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    PARAMETRIZE_CONFIGURATION_ERROR)
      required_options=0
      message="$(_testing.__gettext "Misconfigured parametrize parameters!")"
      ;;
    PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)
      required_options=0
      message="$(_testing.__gettext "This test variant was created twice, please check your parametrize configuration for this test.")" # noqa
      ;;
    PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)
      required_options=0
      message="$(_testing.__gettext "Duplicate test variant name!")" # noqa
      ;;
    PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)
      required_options=0
      message="$(_testing.__gettext "It does not exist!")"
      ;;
    PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID)
      required_options=1
      message="$(_testing.__gettext "The function '${option1}' cannot be used in a parametrize series!")"
      ;;
    PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)
      required_options=0
      message="$(_testing.__gettext "It's name must be prefixed with '${_PARAMETRIZE_PARAMETRIZER_PREFIX}' !")"
      ;;
    PARAMETRIZE_ERROR_TEST_FN_INVALID)
      required_options=1
      message="$(_testing.__gettext "The function '${option1}' cannot be parametrized.")"
      ;;
    PARAMETRIZE_ERROR_TEST_FN_NAME)
      required_options=0
      message="$(_testing.__gettext "It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!")"
      ;;
    PARAMETRIZE_FOOTER_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.__gettext "== End Scenario Values ==")"
      ;;
    PARAMETRIZE_HEADER_SCENARIO)
      required_options=0
      message="$(_testing.__gettext "Parametrize Scenario")"
      ;;
    PARAMETRIZE_HEADER_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.__gettext "== Begin Scenario Values ==")"
      ;;
    PARAMETRIZE_PREFIX_FIXTURE_COMMAND)
      required_options=0
      message="$(_testing.__gettext "Fixture Command")"
      ;;
    PARAMETRIZE_PREFIX_FIXTURE_COMMANDS)
      required_options=0
      message="$(_testing.__gettext "Fixture Commands")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_NAME)
      required_options=0
      message="$(_testing.__gettext "Scenario Name")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.__gettext "Value Set")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_VARIABLE)
      required_options=0
      message="$(_testing.__gettext "Variables")"
      ;;
    PARAMETRIZE_PREFIX_TEST_NAME)
      required_options=0
      message="$(_testing.__gettext "Test Name")"
      ;;
    PARAMETRIZE_PREFIX_VARIANT_NAME)
      required_options=0
      message="$(_testing.__gettext "Variant name")"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="$(_testing.__gettext "Unknown message key '${key}'")"
      ;;
  esac

  (("${#@}" == 1 + required_options)) || {
    message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    return_status=127
  }

  ((return_status == 0)) || {
    __testing.protected stdlib.logger.error "${message}"
    builtin return ${return_status}
  }

  builtin echo -n "${message}"
}
