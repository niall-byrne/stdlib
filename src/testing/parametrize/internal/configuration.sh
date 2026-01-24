#!/bin/bash

# stdlib testing parametrize configuration component

builtin set -eo pipefail

# @description Parses the parametrization configuration.
# @arg $1 string The name of the array containing the configuration.
# @arg $2 string The name of the variable to store the scenario start index.
# @arg $3 string The name of the array to store environment variables.
# @arg $4 string The name of the array to store fixture commands.
# @arg $5 string The name of the variable to store the variant padding value.
# @exitcode 0 If the operation succeeded.
# @internal
@parametrize.__internal.configuration.parse() {
  builtin local parse_configuration_array_indirect_reference
  builtin local -a parse_configuration_array
  builtin local parse_configuration_array_index=0
  builtin local parse_env_var_array_name
  builtin local parse_fixture_commands_array_indirect_reference
  builtin local -a parse_fixture_commands_array
  builtin local parse_variant_padding_value=0

  parse_configuration_array_indirect_reference="${1}[@]"
  parse_configuration_array=("${!parse_configuration_array_indirect_reference}")
  parse_env_var_array_name="${3}"
  parse_fixture_commands_array_indirect_reference="${4}[@]"
  parse_fixture_commands_array=("${!parse_fixture_commands_array_indirect_reference}")

  @parametrize.__internal.configuration.parse_header "${parse_configuration_array[@]}" || builtin return "$?"
  builtin printf -v "${2}" "%s" "${parse_configuration_array_index}"
  @parametrize.__internal.configuration.parse_scenarios "${parse_configuration_array[@]:"${parse_configuration_array_index}"}" || builtin return "$?"

  if [[ "${#parse_fixture_commands_array[@]}" == "0" ]]; then
    builtin eval "${4}=()"
  else
    builtin eval "${4}=($(builtin printf '%q ' "${parse_fixture_commands_array[@]}"))"
  fi

  builtin printf -v "${5}" "%s" "${parse_variant_padding_value}"
}

# @description Parses the header of the parametrization configuration.
# @arg $@ array The configuration lines.
# @exitcode 0 If the operation succeeded.
# @internal
@parametrize.__internal.configuration.parse_header() {
  # consumes and modifies the local variables from @parametrize.__internal.configuration.parse

  while [[ -n "${1}" ]]; do
    ((parse_configuration_array_index = parse_configuration_array_index + 1))
    if stdlib.string.query.starts_with "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX}" "${1}"; then
      parse_fixture_commands_array+=("${1/"${STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX}"/}")
      builtin shift
      builtin continue
    else
      _testing.__protected stdlib.array.make.from_string \
        "${parse_env_var_array_name?}" \
        "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR}" \
        "${1}"
      builtin shift
      builtin break
    fi
  done
}

# @description Parses the scenarios of the parametrization configuration.
# @arg $@ array The configuration lines.
# @exitcode 0 If the operation succeeded.
# @internal
@parametrize.__internal.configuration.parse_scenarios() {
  # consumes and modifies the local variables from @parametrize.__internal.configuration.parse

  builtin local -a parse_scenario_array

  while [[ -n "${1}" ]]; do
    ((parse_configuration_array_index++))

    _testing.__protected stdlib.array.make.from_string \
      parse_scenario_array \
      "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR}" \
      "${1}"

    @parametrize.__internal.validate.scenario \
      "${parse_env_var_array_name}" \
      parse_fixture_commands_array \
      parse_scenario_array || builtin return "$?"

    if [[ "${#parse_scenario_array[0]}" -gt "${parse_variant_padding_value}" ]]; then
      parse_variant_padding_value="${#parse_scenario_array[0]}"
    fi
    builtin shift
  done
}
