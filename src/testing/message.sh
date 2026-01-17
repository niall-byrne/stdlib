#!/bin/bash

# stdlib testing messages library

builtin set -eo pipefail

_testing.message.get() {
  # $1: the message key to retrieve
  # $2: interpolation option 1

  builtin local key="${1}"
  builtin local message

  # shellcheck disable=SC2034
  builtin local option1="${2}"

  builtin local required_options=0
  builtin local return_status=0

  case "${key}" in
    DEBUG_DIFF_FOOTER)
      required_options=0
      message="$(_testing.gettext "== End Debug Diff ==")"
      ;;
    DEBUG_DIFF_HEADER)
      required_options=0
      message="$(_testing.gettext "== Start Debug Diff ==")"
      ;;
    DEBUG_DIFF_PREFIX)
      required_options=0
      message="$(_testing.gettext "Diff")"
      ;;
    DEBUG_DIFF_PREFIX_ACTUAL)
      required_options=0
      message="$(_testing.gettext "ACTUAL")"
      ;;
    DEBUG_DIFF_PREFIX_EXPECTED)
      required_options=0
      message="$(_testing.gettext "EXPECTED")"
      ;;
    LOAD_MODULE_NOT_FOUND)
      required_options=1
      message="$(_testing.gettext "The module '\${option1}' could not be found!")"
      ;;
    LOAD_MODULE_NOTIFICATION)
      required_options=1
      message="$(_testing.gettext "Loading module '\${option1}' ...")"
      ;;
    MOCK_TARGET_INVALID)
      required_options=1
      message="$(_testing.gettext "The object identified by '\${option1}' cannot be mocked!")"
      ;;
    PARAMETRIZE_CONFIGURATION_ERROR)
      required_options=0
      message="$(_testing.gettext "Misconfigured parametrize parameters!")"
      ;;
    PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)
      required_options=0
      message="$(_testing.gettext "This test variant was created twice, please check your parametrize configuration for this test.")" # noqa
      ;;
    PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)
      required_options=0
      message="$(_testing.gettext "Duplicate test variant name!")" # noqa
      ;;
    PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)
      required_options=0
      message="$(_testing.gettext "It does not exist!")"
      ;;
    PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID)
      required_options=1
      message="$(_testing.gettext "The function '\${option1}' cannot be used in a parametrize series!")"
      ;;
    PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)
      required_options=0
      message="$(_testing.gettext "It's name must be prefixed with \${_PARAMETRIZE_PARAMETRIZER_PREFIX}' !")"
      ;;
    PARAMETRIZE_ERROR_TEST_FN_INVALID)
      required_options=1
      message="$(_testing.gettext "The function '\${option1}' cannot be parametrized.")"
      ;;
    PARAMETRIZE_ERROR_TEST_FN_NAME)
      required_options=0
      message="$(_testing.gettext "It's name must start with 'test' and contain a '\${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!")"
      ;;
    PARAMETRIZE_FOOTER_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.gettext "== End Scenario Values ==")"
      ;;
    PARAMETRIZE_HEADER_SCENARIO)
      required_options=0
      message="$(_testing.gettext "Parametrize Scenario")"
      ;;
    PARAMETRIZE_HEADER_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.gettext "== Begin Scenario Values ==")"
      ;;
    PARAMETRIZE_PREFIX_FIXTURE_COMMAND)
      required_options=0
      message="$(_testing.gettext "Fixture Command")"
      ;;
    PARAMETRIZE_PREFIX_FIXTURE_COMMANDS)
      required_options=0
      message="$(_testing.gettext "Fixture Commands")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_NAME)
      required_options=0
      message="$(_testing.gettext "Scenario Name")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_VALUES)
      required_options=0
      message="$(_testing.gettext "Value Set")"
      ;;
    PARAMETRIZE_PREFIX_SCENARIO_VARIABLE)
      required_options=0
      message="$(_testing.gettext "Variables")"
      ;;
    PARAMETRIZE_PREFIX_TEST_NAME)
      required_options=0
      message="$(_testing.gettext "Test Name")"
      ;;
    PARAMETRIZE_PREFIX_VARIANT_NAME)
      required_options=0
      message="$(_testing.gettext "Variant name")"
      ;;
    "")
      required_options=0
      return_status=126
      message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
      ;;
    *)
      required_options=0
      return_status=126
      message="$(_testing.gettext "Unknown message key '\${key}'")"
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
