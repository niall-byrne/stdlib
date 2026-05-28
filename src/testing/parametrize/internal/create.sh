#!/bin/bash

# stdlib testing parametrize create component

builtin set -eo pipefail

# @description Generates an array of variant tags for multiple parametrizers.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX string keyword: The required prefix for parametrizer functions (default="@parametrize_with_").
# @arg $1 string The name of the variable to store the calculated variant tag padding in.
# @arg $2 string The name of the array to store the variant tags in.
# @arg $@ array An array of parametrizer function names.
# @exitcode 0 If the variant tags were generated.
# @exitcode 126 If an invalid argument has been provided.
# @internal
@parametrize.__internal.create.array.fn_variant_tags() {
  builtin local arg_name_for_padding_value="${1}"
  builtin local arg_name_for_variant_array="${2}"

  builtin local padding_value="${!1}"
  builtin local parametrizer_function_name=""
  builtin local variant_index=""
  builtin local variant_tag=""
  builtin local -a variants

  builtin shift 2

  builtin local setting_fn_prefix="${setting_fn_prefix}" # clean STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX

  for ((variant_index = 1; variant_index <= "${#@}"; variant_index++)); do
    parametrizer_function_name="${!variant_index}"
    @parametrize.__internal.validate.fn_name.parametrizer "${parametrizer_function_name}" || builtin return 126
    variant_tag="${parametrizer_function_name/${setting_fn_prefix}/}"
    variants+=("${variant_tag}")
    if [[ "${#variant_tag}" -gt "${padding_value}" ]]; then
      padding_value="${#variant_tag}"
    fi
  done

  builtin printf -v "${arg_name_for_padding_value}" "%s" "${padding_value}"
  builtin eval "${arg_name_for_variant_array}=($(builtin printf '%q ' "${variants[@]}"))"
}

# @description Creates a test function variant for a specific scenario.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN string keyword: Whether to show debug information (default="0").
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN string keyword: Whether to show original test names (default="0").
#   * STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES string global: The colour for original test names (default="GREY").
# @arg $1 string The test function variant name to create.
# @arg $2 string The original test function name.
# @arg $3 string The original test function reference.
# @arg $4 string The name of the array containing environment variable names.
# @arg $5 string The name of the array containing fixture commands.
# @arg $6 string The name of the array containing scenario values.
# @exitcode 0 If the test function variant was created.
# @stdout The informational messages.
# @internal
@parametrize.__internal.create.fn.test_variant() {
  builtin local -a array_indirect_environment_variables
  builtin local array_indirect_environment_variables_reference
  builtin local -a array_indirect_fixture_commands
  builtin local array_indirect_fixture_commands_reference
  builtin local -a array_indirect_scenario_definition
  builtin local array_indirect_scenario_definition_reference
  builtin local original_test_function_name="${2}"
  builtin local original_test_function_reference="${3}"
  builtin local scenario_debug_message=""
  builtin local scenario_index
  builtin local test_function_variant_name="${1}"

  builtin local setting_debug_boolean="${setting_debug_boolean}"                             # clean STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN
  builtin local setting_original_test_names_boolean="${setting_original_test_names_boolean}" # clean STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN

  array_indirect_environment_variables_reference="${4}[@]"
  array_indirect_environment_variables=("${!array_indirect_environment_variables_reference}")
  array_indirect_fixture_commands_reference="${5}[@]"
  array_indirect_fixture_commands=("${!array_indirect_fixture_commands_reference}")
  array_indirect_scenario_definition_reference="${6}[@]"
  array_indirect_scenario_definition=("${!array_indirect_scenario_definition_reference}")

  # KCOV_EXCLUDE_BEGIN
  builtin eval "
  ${test_function_variant_name}(){
  $(
    if [[ "${setting_original_test_names_boolean}" == "1" ]]; then
      builtin echo -e "builtin echo -ne '\n                $(
        # defaults STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES
        _testing.__protected stdlib.string.colour \
          "${STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES}" \
          "${original_test_function_name} ..."
      )'"
    fi

    builtin echo "  builtin printf -v \"PARAMETRIZE_SCENARIO_NAME\" \"%s\" \"${array_indirect_scenario_definition[0]}\""

    scenario_debug_message+=$'\n'
    scenario_debug_message+="$(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO): "
    scenario_debug_message+="\"${array_indirect_scenario_definition[0]}\""
    scenario_debug_message+=$'\n'

    for ((scenario_index = 0; scenario_index < "${#array_indirect_environment_variables[@]}"; scenario_index++)); do
      scenario_debug_message+="${array_indirect_environment_variables[scenario_index]}: \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""$'\n'
      builtin echo "  builtin printf -v \"${array_indirect_environment_variables[scenario_index]}\" \"%s\" \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""
    done

    for ((scenario_index = 0; scenario_index < "${#array_indirect_fixture_commands[@]}"; scenario_index++)); do
      scenario_debug_message+="$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): "
      scenario_debug_message+="\"${array_indirect_fixture_commands[scenario_index]}\""
      scenario_debug_message+=$'\n'
      builtin printf "%s\n" "${array_indirect_fixture_commands[scenario_index]}"
    done

    if [[ "${setting_debug_boolean}" == "1" ]]; then
      @parametrize.__internal.debug.message "${scenario_debug_message}"
    fi
  )
    ${original_test_function_reference};
  }
  "
  # KCOV_EXCLUDE_END
}

# @description Generates a padded test function variant name.
#   * STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG string keyword: The parameter tag in the test function name (default="@vary").
# @arg $1 string The function name to parametrize.
# @arg $2 string The function variant's description.
# @arg $3 integer The length of the longest variant description for padding.
# @exitcode 0 If the padded test function variant name was generated.
# @stdout The padded test function variant name.
# @internal
@parametrize.__internal.create.string.padded_test_fn_variant_name() {
  builtin local padded_variant_name

  builtin local setting_variant_tag="${setting_variant_tag}" # clean STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG

  padded_variant_name="${2// /_}"

  if (("${3}" > "${#2}")); then
    padded_variant_name="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${padded_variant_name}")"
    padded_variant_name="${padded_variant_name// /_}"
  fi

  builtin echo "${1/"${setting_variant_tag}"/"${padded_variant_name}"}"
}
