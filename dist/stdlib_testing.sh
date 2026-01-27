#!/bin/bash

# stdlib testing distributable for bash

set -eo pipefail

# stdlib testing variable definitions

declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN="0"
declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR=";"
declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX="@fixture "
declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX="@parametrize_with_"
declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN="0"
declare -- STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG="@vary"
declare -- STDLIB_TESTING_PROTECT_PREFIX=""
declare -- STDLIB_TESTING_THEME_DEBUG_FIXTURE="GREY"
declare -- STDLIB_TESTING_THEME_ERROR="LIGHT_RED"
declare -- STDLIB_TESTING_THEME_LOAD="GREY"
declare -- STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT="LIGHT_BLUE"
declare -- STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES="GREY"
declare -- STDLIB_TESTING_TRACEBACK_REGEX="^([^:]+:[0-9]+|environment:[0-9]+):.+\$"
declare -a __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()
declare -- __STDLIB_TESTING_MOCK_REGISTRY_FILENAME=""
declare -a __STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES=([0]="builtin" [1]="case" [2]="do" [3]="done" [4]="elif" [5]="else" [6]="esac" [7]="fi" [8]="for" [9]="if" [10]="while")
declare -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
declare -- __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""
declare -- __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"
declare -a __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY=()

# stdlib testing function definitions

@parametrize ()
{
    {
        builtin local -a array_environment_variables;
        builtin local -a array_fixture_commands;
        builtin local -a array_scenario_values
    };
    builtin local original_test_function_name="";
    builtin local original_test_function_reference="";
    builtin local -a parametrize_configuration;
    builtin local parametrize_configuration_index=0;
    builtin local parametrize_configuration_line="";
    builtin local parametrize_configuration_scenario_start_index;
    builtin local test_function_variant_name="";
    builtin local test_function_variant_padding_value=0;
    builtin local PARAMETRIZE_SCENARIO_NAME;
    original_test_function_name="${1}";
    original_test_function_reference="__parametrized_original_function_definition_${1}";
    [[ "${#@}" -gt "1" ]] || {
        _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return "$?";
    stdlib.fn.derive.clone "${original_test_function_name}" "${original_test_function_reference}";
    builtin unset -f "${1}";
    builtin shift;
    parametrize_configuration=("${@}");
    @parametrize.__internal.configuration.parse parametrize_configuration parametrize_configuration_scenario_start_index array_environment_variables array_fixture_commands test_function_variant_padding_value || builtin return "$?";
    parametrize_configuration=("${parametrize_configuration[@]:parametrize_configuration_scenario_start_index}");
    for ((parametrize_configuration_index = 0; "${parametrize_configuration_index}" < "${#parametrize_configuration[@]}"; parametrize_configuration_index++))
    do
        parametrize_configuration_line="${parametrize_configuration[parametrize_configuration_index]}";
        IFS="${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR}" builtin read -ra array_scenario_values <<< "${parametrize_configuration_line}";
        test_function_variant_name="$(@parametrize.__internal.create.string.padded_test_fn_variant_name "${original_test_function_name}" "${array_scenario_values[0]}" "${test_function_variant_padding_value}")";
        if stdlib.fn.query.is_fn "${test_function_variant_name}"; then
            _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)";
            {
                _testing.parametrize.__message.get PARAMETRIZE_PREFIX_TEST_NAME;
                builtin echo ": '$(_testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "${original_test_function_name}")'";
                _testing.parametrize.__message.get PARAMETRIZE_PREFIX_VARIANT_NAME;
                builtin echo ": '$(_testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "${test_function_variant_name}")'"
            } 1>&2;
            _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)";
            builtin return 126;
        fi;
        @parametrize.__internal.create.fn.test_variant "${test_function_variant_name}" "${original_test_function_name}" "${original_test_function_reference}" array_environment_variables array_fixture_commands array_scenario_values;
        __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY+=("${test_function_variant_name}");
    done
}

@parametrize.__internal.configuration.parse ()
{
    builtin local parse_configuration_array_indirect_reference;
    builtin local -a parse_configuration_array;
    builtin local parse_configuration_array_index=0;
    builtin local parse_env_var_array_name;
    builtin local parse_fixture_commands_array_indirect_reference;
    builtin local -a parse_fixture_commands_array;
    builtin local parse_variant_padding_value=0;
    parse_configuration_array_indirect_reference="${1}[@]";
    parse_configuration_array=("${!parse_configuration_array_indirect_reference}");
    parse_env_var_array_name="${3}";
    parse_fixture_commands_array_indirect_reference="${4}[@]";
    parse_fixture_commands_array=("${!parse_fixture_commands_array_indirect_reference}");
    @parametrize.__internal.configuration.parse_header "${parse_configuration_array[@]}" || builtin return "$?";
    builtin printf -v "${2}" "%s" "${parse_configuration_array_index}";
    @parametrize.__internal.configuration.parse_scenarios "${parse_configuration_array[@]:"${parse_configuration_array_index}"}" || builtin return "$?";
    if [[ "${#parse_fixture_commands_array[@]}" == "0" ]]; then
        builtin eval "${4}=()";
    else
        builtin eval "${4}=($(builtin printf '%q ' "${parse_fixture_commands_array[@]}"))";
    fi;
    builtin printf -v "${5}" "%s" "${parse_variant_padding_value}"
}

@parametrize.__internal.configuration.parse_header ()
{
    while [[ -n "${1}" ]]; do
        ((parse_configuration_array_index = parse_configuration_array_index + 1));
        if stdlib.string.query.starts_with "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX}" "${1}"; then
            parse_fixture_commands_array+=("${1/"${STDLIB_TESTING_PARAMETRIZE_SETTING_FIXTURE_COMMAND_PREFIX}"/}");
            builtin shift;
            builtin continue;
        else
            _testing.__protected stdlib.array.make.from_string "${parse_env_var_array_name?}" "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR}" "${1}";
            builtin shift;
            builtin break;
        fi;
    done
}

@parametrize.__internal.configuration.parse_scenarios ()
{
    builtin local -a parse_scenario_array;
    while [[ -n "${1}" ]]; do
        ((parse_configuration_array_index++));
        _testing.__protected stdlib.array.make.from_string parse_scenario_array "${STDLIB_TESTING_PARAMETRIZE_SETTING_FIELD_SEPARATOR}" "${1}";
        @parametrize.__internal.validate.scenario "${parse_env_var_array_name}" parse_fixture_commands_array parse_scenario_array || builtin return "$?";
        if [[ "${#parse_scenario_array[0]}" -gt "${parse_variant_padding_value}" ]]; then
            parse_variant_padding_value="${#parse_scenario_array[0]}";
        fi;
        builtin shift;
    done
}

@parametrize.__internal.create.array.fn_variant_tags ()
{
    builtin local arg_name_for_padding_value="${1}";
    builtin local arg_name_for_variant_array="${2}";
    builtin local padding_value="${!1}";
    builtin local parametrizer_function_name="";
    builtin local variant_index="";
    builtin local variant_tag="";
    builtin local -a variants;
    builtin shift 2;
    for ((variant_index = 1; variant_index <= "${#@}"; variant_index++))
    do
        parametrizer_function_name="${!variant_index}";
        @parametrize.__internal.validate.fn_name.parametrizer "${parametrizer_function_name}" || builtin return 126;
        variant_tag="${parametrizer_function_name/${STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX}/}";
        variants+=("${variant_tag}");
        if [[ "${#variant_tag}" -gt "${padding_value}" ]]; then
            padding_value="${#variant_tag}";
        fi;
    done;
    builtin printf -v "${arg_name_for_padding_value}" "%s" "${padding_value}";
    builtin eval "${arg_name_for_variant_array}=($(builtin printf '%q ' "${variants[@]}"))"
}

@parametrize.__internal.create.fn.test_variant ()
{
    builtin local -a array_indirect_environment_variables;
    builtin local array_indirect_environment_variables_reference;
    builtin local -a array_indirect_fixture_commands;
    builtin local array_indirect_fixture_commands_reference;
    builtin local -a array_indirect_scenario_definition;
    builtin local array_indirect_scenario_definition_reference;
    builtin local original_test_function_name="${2}";
    builtin local original_test_function_reference="${3}";
    builtin local scenario_debug_message="";
    builtin local scenario_index;
    builtin local test_function_variant_name="${1}";
    array_indirect_environment_variables_reference="${4}[@]";
    array_indirect_environment_variables=("${!array_indirect_environment_variables_reference}");
    array_indirect_fixture_commands_reference="${5}[@]";
    array_indirect_fixture_commands=("${!array_indirect_fixture_commands_reference}");
    array_indirect_scenario_definition_reference="${6}[@]";
    array_indirect_scenario_definition=("${!array_indirect_scenario_definition_reference}");
    builtin eval "
  ${test_function_variant_name}(){
  $(if [[ "${STDLIB_TESTING_PARAMETRIZE_SETTING_SHOW_ORIGINAL_TEST_NAMES_BOOLEAN}" == "1" ]]; then
    builtin echo -e "builtin echo -ne '\n                $(_testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES}" "${original_test_function_name} ...")'";
fi
builtin echo "  builtin printf -v \"PARAMETRIZE_SCENARIO_NAME\" \"%s\" \"${array_indirect_scenario_definition[0]}\""
scenario_debug_message+='
'
scenario_debug_message+="$(_testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO): "
scenario_debug_message+="\"${array_indirect_scenario_definition[0]}\""
scenario_debug_message+='
'
for ((scenario_index = 0; scenario_index < "${#array_indirect_environment_variables[@]}"; scenario_index++))
do
    scenario_debug_message+="${array_indirect_environment_variables[scenario_index]}: \"${array_indirect_scenario_definition[((scenario_index + 1))]}\""'
'
builtin echo "  builtin printf -v \"${array_indirect_environment_variables[scenario_index]}\" \"%s\" \"${array_indirect_scenario_definition[((scenario_index + 1))]}\"";
done
for ((scenario_index = 0; scenario_index < "${#array_indirect_fixture_commands[@]}"; scenario_index++))
do
    scenario_debug_message+="$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): "
scenario_debug_message+="\"${array_indirect_fixture_commands[scenario_index]}\""
scenario_debug_message+='
'
builtin printf "%s\n" "${array_indirect_fixture_commands[scenario_index]}";
done
if [[ "${STDLIB_TESTING_PARAMETRIZE_SETTING_DEBUG_BOOLEAN}" == "1" ]]; then
    @parametrize.__internal.debug.message "${scenario_debug_message}";
fi)
    ${original_test_function_reference};
  }
  "
}

@parametrize.__internal.create.string.padded_test_fn_variant_name ()
{
    builtin local padded_variant_name;
    padded_variant_name="${2// /_}";
    if (("${3}" > "${#2}")); then
        padded_variant_name="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${padded_variant_name}")";
        padded_variant_name="${padded_variant_name// /_}";
    fi;
    builtin echo "${1/"${STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG}"/"${padded_variant_name}"}"
}

@parametrize.__internal.debug.message ()
{
    builtin echo "builtin echo '${1}'"
}

@parametrize.__internal.validate.fn_name.parametrizer ()
{
    if ! stdlib.fn.query.is_fn "${1}"; then
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")";
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)";
        builtin return 126;
    fi;
    if ! stdlib.string.query.starts_with "${STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX}" "${1}"; then
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")";
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)";
        builtin return 126;
    fi
}

@parametrize.__internal.validate.fn_name.test ()
{
    if ! stdlib.fn.query.is_fn "${1}"; then
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")";
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)";
        builtin return 126;
    fi;
    if ! stdlib.string.query.has_substring "${STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG}" "${1}" || ! stdlib.string.query.starts_with "test" "${1}"; then
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")";
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_ERROR_TEST_FN_NAME)";
        builtin return 126;
    fi
}

@parametrize.__internal.validate.scenario ()
{
    builtin local validate_env_var_indirect_array_reference;
    builtin local -a validate_env_var_indirect_array;
    builtin local validate_fixture_indirect_command_array_reference;
    builtin local -a validate_fixture_indirect_command_array;
    builtin local validate_scenario_indirect_array_reference;
    builtin local -a validate_scenario_indirect_array;
    validate_env_var_indirect_array_reference="${1}[@]";
    validate_env_var_indirect_array=("${!validate_env_var_indirect_array_reference}");
    validate_fixture_indirect_command_array_reference="${2}[@]";
    validate_fixture_indirect_command_array=("${!validate_fixture_indirect_command_array_reference}");
    validate_scenario_indirect_array_reference="${3}[@]";
    validate_scenario_indirect_array=("${!validate_scenario_indirect_array_reference}");
    builtin local validation_index;
    if (("${#validate_scenario_indirect_array[@]}" != "${#validate_env_var_indirect_array[@]}" + 1)); then
        {
            _testing.parametrize.__message.get PARAMETRIZE_HEADER_SCENARIO_VALUES;
            builtin echo;
            for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++))
            do
                builtin echo "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}";
            done;
            _testing.parametrize.__message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES;
            builtin echo
        } 1>&2;
        _testing.error "$(_testing.parametrize.__message.get PARAMETRIZE_CONFIGURATION_ERROR)" "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}" "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables" "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values" "$(_testing.parametrize.__message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")";
        builtin return 126;
    fi
}

@parametrize.apply ()
{
    builtin local original_test_function_name="";
    builtin local parametrized_test_function_name="";
    builtin local parametrizer_index=0;
    builtin local parametrizer_fn;
    builtin local -a parametrizer_fn_array;
    builtin local -a parametrizer_variant_array;
    builtin local parametrizer_variant_tag_padding;
    original_test_function_name="${1}";
    parametrizer_fn_array=("${@:2}");
    [[ "${#@}" -gt "1" ]] || {
        _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126;
    @parametrize.__internal.create.array.fn_variant_tags parametrizer_variant_tag_padding parametrizer_variant_array "${@:2}" || builtin return 126;
    for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++))
    do
        parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}";
        parametrized_test_function_name="$(@parametrize.__internal.create.string.padded_test_fn_variant_name "${original_test_function_name}" "${parametrizer_variant_array[parametrizer_index]}" "${parametrizer_variant_tag_padding}")";
        stdlib.fn.derive.clone "${original_test_function_name}" "${parametrized_test_function_name}";
        "${parametrizer_fn}" "${parametrized_test_function_name}";
    done;
    builtin unset -f "${original_test_function_name}"
}

@parametrize.compose ()
{
    builtin local -a __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY;
    builtin local original_test_function_name="${1}";
    builtin local parametrizer_fn;
    builtin local -a parametrizer_fn_array;
    builtin local parametrizer_fn_target;
    builtin local -a parametrizer_fn_targets;
    builtin local parametrizer_index=0;
    parametrizer_fn_array=("${@:2}");
    [[ "${#@}" -gt "1" ]] || {
        _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126;
    parametrizer_fn_targets=("${original_test_function_name}");
    for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++))
    do
        parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}";
        @parametrize.__internal.validate.fn_name.parametrizer "${parametrizer_fn}" || builtin return 126;
        __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY=();
        for parametrizer_fn_target in "${parametrizer_fn_targets[@]}";
        do
            "${parametrizer_fn}" "${parametrizer_fn_target}";
        done;
        parametrizer_fn_targets=("${__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY[@]}");
    done;
    builtin unset -f "${original_test_function_name}"
}

_capture.assertion_failure ()
{
    builtin local output;
    builtin local rc;
    builtin set +e;
    LC_ALL=C IFS= builtin read -rd '' output < <("$@" 2>&1);
    builtin set -e;
    builtin wait "$!";
    rc="$?";
    if [[ ${rc} -eq 0 ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_DID_NOT_FAIL "${1}")";
    fi;
    TEST_OUTPUT="$(builtin echo "${output}" | "${_STDLIB_BINARY_SED}" -E '/^FAILURE/d' | "${_STDLIB_BINARY_SED}" -E "/${STDLIB_TESTING_TRACEBACK_REGEX}/d")"
}

_capture.output ()
{
    TEST_OUTPUT="$("$@" 2>&1)"
}

_capture.output_raw ()
{
    LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1);
    builtin wait "$!";
    builtin return "$?"
}

_capture.rc ()
{
    "$@";
    TEST_RC="$?"
}

_capture.stderr ()
{
    builtin local captured_rc;
    builtin exec 3>&1;
    TEST_OUTPUT="$("$@" 2>&1 > /dev/null)";
    captured_rc="$?";
    builtin exec 3>&-;
    builtin return "${captured_rc}"
}

_capture.stderr_raw ()
{
    builtin exec 3>&1;
    LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2>&1 > /dev/null);
    builtin exec 3>&-;
    builtin wait "$!";
    builtin return "$?"
}

_capture.stdout ()
{
    TEST_OUTPUT="$("$@" 2> /dev/null)"
}

_capture.stdout_raw ()
{
    LC_ALL=C IFS= builtin read -rd '' TEST_OUTPUT < <("$@" 2> /dev/null);
    builtin wait "$!";
    builtin return "$?"
}

_mock.__generate_mock ()
{
    _mock.__internal.persistence.registry.add_mock "${1}" "${2}";
    builtin eval "$("/usr/bin/cat" <<EOF


# === component start ==========================

# Global variables associated with this mock

__${2}_mock_keywords=()
__${2}_mock_pipeable=0
__${2}_mock_rc=""
__${2}_mock_side_effects_boolean=0
__${2}_mock_stderr=""
__${2}_mock_stdout=""
# === component end ============================




# === component start ==========================

# @description A placeholder function that takes the place of a specific function or binary during testing.
#   * __${2}_mock_pipeable: This boolean determines if the mock should read from stdin (default="0").
#   * __${2}_mock_rc: This is the exit code the mock is configured to return (default="0").
# @arg $@ array These are the arguments that are passed to the original function or binary.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the mock is configured to it can emit 1 or any exit code (default="0").
# @stdin The mock can be configured to receive arguments from stdin.
# @stdout The mock can be configured to emit stdout.
# @stderr The mock can be configured to emit stderr.
${1}() {
  builtin local _mock_object_pipe_input=""
  builtin local _mock_object_rc=0
  builtin local -a _mock_object_side_effects

  if [[ "\${__${2}_mock_pipeable}" -eq "1" ]]; then
    ${1}.mock.__controller pipeable
    builtin set -- "\${@}" "\${_mock_object_pipe_input}"
  fi

  ${1}.mock.__call "\${@}"

  ${1}.mock.__controller update_rc "\${__${2}_mock_rc}"
  ${1}.mock.__controller subcommand "\${@}"
  ${1}.mock.__controller update_rc "\$?"
  ${1}.mock.__controller side_effects
  ${1}.mock.__controller update_rc "\$?"

  ${1}.mock.__controller stderr
  ${1}.mock.__controller stdout

  builtin return "\${_mock_object_rc}"
}


# @description Clears the mock's call history and configured side effects.
# @noargs
# @exitcode 0 If the operation is successful.
${1}.mock.clear() {
  builtin local -a _mock_object_side_effects
  builtin echo -n "" > "\${__${2}_mock_calls_file}"  # noqa
  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
}

# @description Clears the mock's call history and configured side effects as well as it's configured exit code, stdout, stderr and subcommand properties.
# @noargs
# @exitcode 0 If the operation is successful.
${1}.mock.reset() {
  ${1}.mock.clear
  __${2}_mock_rc=""
  __${2}_mock_stderr=""
  __${2}_mock_stdout=""
  builtin unset -f __${1}_mock_subcommand || builtin true
}
# === component end ============================




# === component start ==========================

# @description Persists a mock call, storing it's arguments as an arg string in the correct persistence file.  If sequence tracking is enabled, the mock will also be added to the sequence persistence file.
#   * __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN: This boolean determines whether sequence information will be persisted for this call (default="0").
# @arg $@ string The arguments the mock was called with.
# @exitcode 0 If the operation is successful.
# @internal
${1}.mock.__call() {
  builtin local -a _mock_object_args
  builtin local -a _mock_object_call_array

  _mock_object_args=("\${@}")

  _mock.__internal.arg_array.make.from_array     _mock_object_call_array     _mock_object_args     "__${2}_mock_keywords"

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"

  if [[ "\${__STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN}" == "1" ]]; then
    _mock.__internal.persistence.sequence.retrieve
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY+=("${1}")
    _mock.__internal.persistence.sequence.update
  fi
}
# === component end ============================




# === component start ==========================

# @description This function is the central controller of the mock's behaviour.  It dispatches according to the command string it receives.
#   * __${2}_mock_side_effects_boolean: This boolean determines if side effects have been configured on this mock (default="0").
#   * __${2}_mock_stderr: If this variable contains a value, it will be emitted to stderr (default="").
#   * __${2}_mock_stdout: If this variable contains a value, it will be emitted to stdout (default="").
# @arg $1 string The controller command to dispatch (pipeable|side_effects|stderr|stdout|subcommand|update_rc).
# @arg $@ array Additional arguments to pass to the specified controller command.
# @exitcode 0 If the operation is successful.
# @stdout If the controller is instructed, it will emit the contents of the __${2}_mock_stdout variable to stdout.
# @stderr If the controller is instructed, it will emit the contents of the __${2}_mock_stderr variable to stderr.
# @internal
${1}.mock.__controller() {
  # $1: the mock component to execute
  # $@: additional arguments to pass

  builtin local _mock_object_pipe_input_line
  builtin local _mock_object_side_effect
  builtin local -a _mock_object_side_effects

  case "\${1}" in
    pipeable)
      while IFS= builtin read -r _mock_object_pipe_input_line; do
        _mock_object_pipe_input+="\${_mock_object_pipe_input_line}"
        _mock_object_pipe_input+=$'\n'
      done
      _mock_object_pipe_input="\${_mock_object_pipe_input%?}"
      ;;
    side_effects)
      if [[ "\${__${2}_mock_side_effects_boolean}" == "1" ]]; then
        builtin eval "\$(<"\${__${2}_mock_side_effects_file}")"
        if [[ "\${#_mock_object_side_effects[@]}" -gt 0 ]]; then
          _mock_object_side_effect="\${_mock_object_side_effects[0]}"
          _mock_object_side_effects=("\${_mock_object_side_effects[@]:1}")
          builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
          builtin eval "\${_mock_object_side_effect}"
        fi
      fi
      ;;
    stderr)
      if [[ -n "\${__${2}_mock_stderr}" ]]; then
        builtin echo "\${__${2}_mock_stderr}" >&2
      fi
      ;;
    stdout)
      if [[ -n "\${__${2}_mock_stdout}" ]]; then
        builtin echo "\${__${2}_mock_stdout}"
      fi
      ;;
    subcommand)
      if builtin declare -F __${1}_mock_subcommand > /dev/null 2>&1; then
        __${1}_mock_subcommand "\${@:2}"
      fi
      ;;
    update_rc)
      # if passed a valid return code, and we're not set to 0 then update to the newest code
      if [[ -n "\${2}" ]] && [[ "\${_mock_object_rc}" == "0" ]]; then
        _mock_object_rc="\${2}"
      fi
      ;;
  esac
}
# === component end ============================




# === component start ==========================

# @description This function will iterate through each call made with this mock, and evaluate a given conditional command.  If this command passes, then the subsequent given commands are then executed.
# @arg $1 string An escaped bash command that can be safely evaluated as the function iterates through each mock call.
# @arg $@ array Additional bash commands that will be evaluated and executed if the comparison succeeds.
# @exitcode 0 If the operation is successful.
# @internal
${1}.mock.__get_apply_to_matching_mock_calls() {
  builtin local _mock_object_call_file_index=1
  builtin local _mock_object_call_file_line

  while builtin read -r _mock_object_call_file_line; do
    builtin eval "\${_mock_object_call_file_line}"
    builtin printf -v _mock_object_escaped_args "%q" "\${_mock_object_call_array[*]}"
    if builtin eval "\${1}"; then
      builtin eval "\${@:2}"
    fi
    ((_mock_object_call_file_index++))
  done < "\${__${2}_mock_calls_file}"
}

# @description This function will retrieve the call at the specified index from the mock's call history.
# @arg $1 integer An index (from 1) in the mock's call history to retrieve.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The specified mock call as an arg string.
# @stderr The error message if the operation fails.
${1}.mock.get.call() {
  # $1: the call to retrieve

  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  _testing.__protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  builtin printf -v _mock_object_escaped_args "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls     "[[ "\\\${_mock_object_call_file_index}" == "\${_mock_object_escaped_args}" ]]"     builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

# @description This function will retrieve all calls from the mock's call history.
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout All calls made by this mock as new line separated arg strings.
# @stderr The error message if the operation fails.
${1}.mock.get.calls() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  ${1}.mock.__get_apply_to_matching_mock_calls     "true"     builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

# @description This function will retrieve a count of the number of times this mock has been called.
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout A count of the the number of times this mock has been called.
# @stderr The error message if the operation fails.
${1}.mock.get.count() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  < "\${__${2}_mock_calls_file}" wc -l
}

# @description This function will retrieve the keywords assigned to this mock.  (These keywords are variables who's value is recorded during each mock call).
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The keywords currently assigned to this mock.
# @stderr The error message if the operation fails.
${1}.mock.get.keywords() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  builtin echo "\${__${2}_mock_keywords[*]}"
}
# === component end ============================




# === component start ==========================

# @description This function will set the keywords assigned to this mock.  (These keywords are variables who's value is recorded during each mock call).
# @arg $@ array These are the keywords, or variables, that the mock will record each time it's called. (Call this function without any arguments to disable this feature).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @set __${2}_mock_keywords array These are the keywords, or variables, that the mock will record each time it's called.
# @stderr The error message if the operation fails.
${1}.mock.set.keywords() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _mock_object_keywords

  _mock_object_keywords=("\${@}")

  _testing.__protected stdlib.array.assert.not_contains "" _mock_object_keywords || builtin return 126
  _testing.__protected stdlib.array.map.fn "$(_testing.__protected_name stdlib.var.assert.is_valid_name)" _mock_object_keywords || builtin return 126

  builtin eval "__${2}_mock_keywords=(\$(builtin printf '%q ' "\${@}"))"
}

# @description This function will toggle the 'pipeable' behaviour of the mock.  Turning this on allows the mock to receive stdin.
# @arg $1 boolean This enables or disables the 'pipeable' behaviour of the mock, (default="0").
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_pipeable boolean This enables or disables the 'pipeable' behaviour of the mock.
# @stderr The error message if the operation fails.
${1}.mock.set.pipeable() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_boolean "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

# @description This function will set the return code (exit code) of the mock.  This behaviour can be overridden by configuring side effects or a subcommand.
# @arg $1 integer This is the return code (or exit code) you wish the mock to emit.  (Please note that any non-zero number emitted by the side effects or subcommand configured on this mock will be override this value and be returned instead).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_rc integer This is the exit code the mock is configured to return.
# @stderr The error message if the operation fails.
${1}.mock.set.rc() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_integer_with_range "0" "255" "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_rc" "%s" "\${1}"
}

# @description This function will set the side effects of the mock.  These are a series of one or more commands the mock will execute each time it's called.
# @arg $@ array This is a series commands the mock will execute each time it's called. (Call this function without any arguments to disable this feature).
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @set __${2}_mock_side_effects_boolean boolean This is a boolean indicating the mock has been configured with at least one side effect.
# @stderr The error message if the operation fails.
${1}.mock.set.side_effects() {
  builtin local -a _mock_object_side_effects

  _mock_object_side_effects=("\${@}")
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
  builtin printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

# @description This function will set the stderr this mock will emit when called.
# @arg $1 string This is the string that will be emitted to stderr when the mock is called.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_stderr string This is the string that will be emitted to stderr when the mock is called.
# @stderr The error message if the operation fails.
${1}.mock.set.stderr() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

# @description This function will set the stdout this mock will emit when called.
# @arg $1 string This is the string that will be emitted to stdout when the mock is called.
# @exitcode 0 If the operation is successful.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @set __${2}_mock_stdout string This is the string that will be emitted to stdout when the mock is called.
# @stdout The error message if the operation fails.
${1}.mock.set.stdout() {
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

# @description This function will set the subcommand this mock will call when the mock is called.  All arguments passed to the mock are also passed to the subcommand.
# @arg $@ array This is a series commands the mock will execute each time it's called.  This is distinct from side effects in that the subcommand will receive all arguments sent to the mock itself.
# @exitcode 0 If the operation is successful.
${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  builtin eval "__${1}_mock_subcommand() {  # noqa
      \${@}
  }"
}
# === component end ============================




# === component start ==========================

# @description Counts the number of times a mock has been called with a given arg string.
# @arg $1 string The arg string to compare against the mock's call history.
# @exitcode 0 If the operation is successful.
# @stdout The count of matches identified.
# @internal
${1}.mock.__count_matches() {
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_arg_string_expected
  builtin local _mock_object_call_definition
  builtin local _mock_object_match_count=0

  _mock_object_arg_string_expected="\$(builtin printf "%q" "\${1}")"

  while IFS= builtin read -r _mock_object_call_definition; do
    builtin eval "\${_mock_object_call_definition}"
    builtin printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_call_array[*]}"
    if [[ "\${_mock_object_arg_string_expected}" == "\${_mock_object_arg_string_actual}" ]]; then
      ((_mock_object_match_count++))
    fi
  done < "\${__${2}_mock_calls_file}"

  builtin echo "\${_mock_object_match_count}"
}

# @description Asserts any call in the mock's call history matches the given arg string.
# @arg $1 string The arg string to compare against the mock's call history.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
${1}.mock.assert_any_call_is() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local _mock_object_match_count

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  assert_not_equals     "0"     "\${_mock_object_match_count}"     "\$(_testing.mock.__message.get "MOCK_NOT_CALLED_WITH" "${1}" "\${1}")"
}

# @description Asserts a call at a specific index in the mock's call history matches the given arg string.
# @arg $1 integer An index (from 1) in the mock's call history to compare against.
# @arg $2 string The arg string to compare against the mock's call history.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
${1}.mock.assert_call_n_is() {
  # $1: the call count to assert
  # $2: a set of call args as a string

  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_call_count

  STDLIB_ARGS_NULL_SAFE_ARRAY=("2")

  _testing.__protected stdlib.fn.args.require "2" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  _testing.__protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  _mock_object_call_count="\$(${1}.mock.get.count)"

  if [[ "\${_mock_object_call_count}" -lt "\${1}" ]]; then
    fail       "\$(_testing.mock.__message.get MOCK_CALLED_N_TIMES "${1}" "\${_mock_object_call_count}")"
  fi

  _mock_object_arg_string_actual="\$("${1}.mock.get.call" "\${1}")"

  assert_equals     "\${2}"     "\${_mock_object_arg_string_actual}"     "\$(_testing.mock.__message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\${1}")"
}

# @description Asserts the mock was called once with a call matching the given arg string.
# @arg $1 string The arg string to compare against the mock's call history.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdout The actual first arg string this mock was called with, if the assertion fails.
# @stderr The error message if the assertion fails.
${1}.mock.assert_called_once_with() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_match_count

  STDLIB_ARGS_NULL_SAFE_ARRAY=("1")

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  ${1}.mock.assert_count_is "1"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  if [[ "\${_mock_object_match_count}" != "1" ]]; then
    _mock_object_arg_string_actual="\$(${1}.mock.get.call "1")"
    builtin echo       "\$(_testing.mock.__message.get MOCK_CALL_ACTUAL_PREFIX): [\${_mock_object_arg_string_actual}]"
  fi

  assert_equals     "1"     "\${_mock_object_match_count}"     "\$(_testing.mock.__message.get MOCK_NOT_CALLED_ONCE_WITH "${1}" "\${1}")"
}

# @description Asserts the mock's call history matches the given arg strings.  (Call this function without args to assert this mock was not called at all).
# @arg $@ array An array of arg strings that is expected to match the mock's call history.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @stderr The error message if the assertion fails.
${1}.mock.assert_calls_are() {
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_arg_string_expected
  builtin local _mock_object_call_definition=""
  builtin local _mock_object_call_index=0
  builtin local -a _mock_object_expected_mock_calls

  _mock_object_expected_mock_calls=("\${@}")
  _mock.__internal.security.assert.is_builtin "declare" || builtin return "\$?"

  while IFS= builtin read -r _mock_object_call_definition; do
    builtin eval "\${_mock_object_call_definition}"
    builtin printf -v _mock_object_arg_string_expected "%q" "\${_mock_object_expected_mock_calls[_mock_object_call_index]}"
    builtin printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_call_array[*]}"

    assert_equals       "\${_mock_object_arg_string_expected}"       "\${_mock_object_arg_string_actual}"       "\$(_testing.mock.__message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\$((_mock_object_call_index + 1))")"
    ((_mock_object_call_index++))
  done < "\${__${2}_mock_calls_file}" || builtin true

  if [[ "\${_mock_object_call_index}" == 0 ]] && [[ "\${#@}" != 0 ]]; then
    fail "\$(_testing.mock.__message.get "MOCK_NOT_CALLED" "${1}")"
  fi

  if [[ "\${_mock_object_call_index}" < "\${#_mock_object_expected_mock_calls[@]}" ]]; then
    fail "\$(_testing.mock.__message.get MOCK_CALLED_N_TIMES "${1}" "\$((_mock_object_call_index))")"
  fi
}

# @description Asserts the mock was called the number of times specified by the given count.
# @arg $1 integer A positive integer representing the expected number of times this mock was called.
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
${1}.mock.assert_count_is() {
  # $1: the call count to assert

  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  _testing.__protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  _testing.__protected stdlib.string.assert.is_digit "\${1}" || builtin return 126

  _mock_object_call_count="\$("${1}.mock.get.count")"

  assert_equals     "\${1}"     "\${_mock_object_call_count}"     "\$(_testing.mock.__message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}

# @description Asserts the mock was not called.
# @noargs
# @exitcode 0 If the operation is successful.
# @exitcode 1 If the assertion failed.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the assertion fails.
${1}.mock.assert_not_called() {
  builtin local STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  _testing.__protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  _mock_object_call_count="\$(${1}.mock.get.count)"

  assert_equals     "0"     "\${_mock_object_call_count}"     "\$(_testing.mock.__message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}
# === component end ============================


EOF
)"
}

_mock.__internal.arg_array.make.element.from_array ()
{
    builtin local _mock_keyword_array_arg_indirect_reference;
    builtin local -a _mock_keyword_array_arg;
    builtin local _mock_keyword_array_arg_as_string;
    _mock_keyword_array_arg_indirect_reference="${_mock_keyword_arg}[@]";
    _mock_keyword_array_arg=("${!_mock_keyword_array_arg_indirect_reference}");
    if [[ "${#_mock_keyword_array_arg[@]}" -eq 0 ]]; then
        _mock_keyword_array_arg_as_string=" ";
    else
        _mock_keyword_array_arg_as_string="$(builtin printf "'%q' " "${_mock_keyword_array_arg[@]}")";
    fi;
    builtin echo "${_mock_keyword_array_arg_as_string%?}"
}

_mock.__internal.arg_array.make.from_array ()
{
    builtin local -a _mock_arg_array;
    builtin local _mock_array_index;
    builtin local _mock_arg_element;
    builtin local -a _mock_keyword_args_array;
    builtin local _mock_keyword_args_array_indirect_reference;
    builtin local -a _mock_position_args_array;
    builtin local _mock_positional_args_array_indirect_reference;
    _mock_positional_args_array_indirect_reference="${2}[@]";
    _mock_position_args_array=("${!_mock_positional_args_array_indirect_reference}");
    if [[ -n "${3}" ]]; then
        _mock_keyword_args_array_indirect_reference="${3}[@]";
        _mock_keyword_args_array=("${!_mock_keyword_args_array_indirect_reference}");
    fi;
    for ((_mock_array_index = 0; _mock_array_index < "${#_mock_position_args_array[@]}"; _mock_array_index++))
    do
        _mock_arg_array+=("$((_mock_array_index + 1))(${_mock_position_args_array[_mock_array_index]})");
    done;
    for ((_mock_array_index = 0; _mock_array_index < "${#_mock_keyword_args_array[@]}"; _mock_array_index++))
    do
        _mock_keyword_arg="${_mock_keyword_args_array[_mock_array_index]}";
        if [[ -n "${_mock_keyword_arg}" ]]; then
            if _testing.__protected stdlib.array.query.is_array "${_mock_keyword_arg}"; then
                _mock_arg_array+=("${_mock_keyword_arg}($(_mock.__internal.arg_array.make.element.from_array))");
            else
                _mock_arg_array+=("${_mock_keyword_arg}(${!_mock_keyword_arg})");
            fi;
        fi;
    done;
    if [[ ${#_mock_arg_array[@]} == "0" ]]; then
        builtin eval "${1}=()";
    else
        builtin eval "${1}=($(builtin printf '%q ' "${_mock_arg_array[@]}"))";
    fi
}

_mock.__internal.persistence.registry.add_mock ()
{
    __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY+=("${1}");
    builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")";
    builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
}

_mock.__internal.persistence.registry.apply_to_all ()
{
    builtin local mock_instance;
    for mock_instance in "${__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY[@]}";
    do
        "${mock_instance}".mock."${1}";
    done
}

_mock.__internal.persistence.registry.cleanup ()
{
    if [[ -n "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
        "${_STDLIB_BINARY_RM}" -rf "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}";
    fi
}

_mock.__internal.persistence.registry.create ()
{
    if [[ -z "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
        __STDLIB_TESTING_MOCK_REGISTRY_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -d)";
    fi
}

_mock.__internal.persistence.sequence.clear ()
{
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=();
    _mock.__internal.persistence.sequence.update
}

_mock.__internal.persistence.sequence.initialize ()
{
    if [[ -z "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}" ]]; then
        __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")";
        _mock.__internal.persistence.sequence.update;
    fi
}

_mock.__internal.persistence.sequence.retrieve ()
{
    builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY;
    builtin eval "$(${_STDLIB_BINARY_CAT} "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}")";
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY[@]}")
}

_mock.__internal.persistence.sequence.update ()
{
    builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY;
    __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}");
    builtin declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"
}

_mock.__internal.security.assert.is_builtin ()
{
    builtin local return_code=0;
    builtin local requesting_mock="${FUNCNAME[1]%.mock*}";
    _testing.__protected stdlib.fn.query.is_builtin "${@}" || return_code="$?";
    case "${return_code}" in
        0)

        ;;
        127)
            _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            _testing.error "${FUNCNAME[1]}: $(_testing.mock.__message.get MOCK_REQUIRES_BUILTIN "${requesting_mock}" "${1}")"
        ;;
    esac;
    builtin return "${return_code}"
}

_mock.__internal.security.sanitize.fn_name ()
{
    builtin local _fn_name_sanitized;
    builtin local _fn_name_original="${1}";
    _fn_name_sanitized="${_fn_name_original//@/____at_sign____}";
    _fn_name_sanitized="${_fn_name_sanitized//-/____dash____}";
    _fn_name_sanitized="${_fn_name_sanitized//./____dot____}";
    builtin echo "${_fn_name_sanitized}_sanitized"
}

_mock.arg_string.make.from_array ()
{
    builtin local _mock_arg_string="";
    builtin local _mock_arg_string_spacer="";
    builtin local _mock_array_index;
    builtin local -a _mock_generated_mock_arg_array;
    builtin local _mock_keyword_arg;
    builtin local -a _mock_keyword_args_array;
    builtin local _mock_keyword_args_array_indirect_reference;
    builtin local -a _mock_position_args_array;
    builtin local _mock_positional_args_array_indirect_reference;
    _testing.__protected stdlib.fn.args.require "1" "1" "$@" || builtin return 127;
    _testing.__protected stdlib.array.assert.is_array "${1}" || builtin return 126;
    if [[ "${#@}" == 2 ]]; then
        _testing.__protected stdlib.array.assert.is_array "${2}" || builtin return 126;
    fi;
    _mock.__internal.arg_array.make.from_array _mock_generated_mock_arg_array "${@}";
    builtin echo "${_mock_generated_mock_arg_array[*]}"
}

_mock.arg_string.make.from_string ()
{
    builtin local -a STDLIB_ARGS_NULL_SAFE_ARRAY;
    builtin local -a _mock_args_array;
    builtin local -a _mock_arg_string_args;
    builtin local _mock_separator="${STDLIB_LINE_BREAK_DELIMITER:- }";
    STDLIB_ARGS_NULL_SAFE_ARRAY=("2");
    _mock_arg_string_args=("_mock_args_array");
    _testing.__protected stdlib.fn.args.require "1" "1" "${@}" || builtin return 127;
    if [[ -n "${2}" ]]; then
        _mock_arg_string_args+=("${2}");
    fi;
    _testing.__protected stdlib.array.make.from_string _mock_args_array "${_mock_separator}" "${1}" || builtin return "$?";
    _mock.arg_string.make.from_array "${_mock_arg_string_args[@]}"
}

_mock.clear_all ()
{
    _mock.__internal.persistence.registry.apply_to_all "clear"
}

_mock.create ()
{
    builtin local _mock_sanitized_fn_name;
    builtin local _mock_escaped_fn_name;
    builtin local _mock_attribute;
    builtin local _mock_restricted_attribute_boolean=0;
    if [[ "${#@}" != 1 ]] || [[ -z "${1}" ]]; then
        _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127;
    fi;
    if ! _testing.__protected stdlib.fn.query.is_valid_name "${1}" || _testing.__protected stdlib.array.query.is_contains "${1}" __STDLIB_TESTING_MOCK_RESTRICTED_ATTRIBUTES; then
        _testing.error "${FUNCNAME[0]}: $(_testing.mock.__message.get MOCK_TARGET_INVALID "${1}")";
        builtin return 126;
    fi;
    builtin printf -v "_mock_escaped_fn_name" "%q" "${1}";
    _mock_sanitized_fn_name="$(_mock.__internal.security.sanitize.fn_name "${_mock_escaped_fn_name}")";
    if _testing.__protected stdlib.fn.query.is_fn "${_mock_escaped_fn_name}"; then
        _testing.__protected stdlib.fn.derive.clone "${_mock_escaped_fn_name}" "${_mock_escaped_fn_name}____copy_of_original_implementation";
    fi;
    _mock.__generate_mock "${_mock_escaped_fn_name}" "${_mock_sanitized_fn_name}"
}

_mock.delete ()
{
    _testing.__protected stdlib.fn.assert.is_fn "${1}" || builtin return 127;
    _testing.__protected stdlib.fn.assert.is_fn "${1}.mock.set.subcommand" || builtin return 127;
    builtin unset -f "${1}";
    while IFS= builtin read -r mocked_function; do
        mocked_function="${mocked_function/"declare -f "/}";
        mocked_function="${mocked_function%?}";
        builtin unset -f "${mocked_function/"declare -f "/}";
    done <<< "$(builtin declare -F | ${_STDLIB_BINARY_GREP} -E "^declare -f ${1}.mock.*")";
    if _testing.__protected stdlib.fn.query.is_fn "${1}____copy_of_original_implementation"; then
        _testing.__protected stdlib.fn.derive.clone "${1}____copy_of_original_implementation" "${1}";
    fi
}

_mock.register_cleanup ()
{
    if builtin declare -F stdlib.trap.handler.exit.fn.register > /dev/null; then
        stdlib.trap.handler.exit.fn.register _mock.__internal.persistence.registry.cleanup;
    fi
}

_mock.reset_all ()
{
    _mock.__internal.persistence.registry.apply_to_all "reset"
}

_mock.sequence.assert_is ()
{
    builtin local -a mock_sequence;
    builtin local -a expected_mock_sequence;
    expected_mock_sequence=("$@");
    _testing.__assertion.value.check "${@}";
    _mock.sequence.record.stop;
    _mock.__internal.persistence.sequence.retrieve;
    mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}");
    assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.assert_is_empty ()
{
    builtin local -a mock_sequence;
    builtin local -a expected_mock_sequence;
    _mock.sequence.record.stop;
    _mock.__internal.persistence.sequence.retrieve;
    mock_sequence=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}");
    assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.clear ()
{
    _mock.__internal.persistence.sequence.clear
}

_mock.sequence.record.resume ()
{
    __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}

_mock.sequence.record.start ()
{
    _mock.__internal.persistence.sequence.clear;
    __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="1"
}

_mock.sequence.record.stop ()
{
    __STDLIB_TESTING_MOCK_SEQUENCE_TRACKING_BOOLEAN="0"
}

_testing.__assertion.value.check ()
{
    builtin local value_name="${1}";
    builtin local assertion_name="${FUNCNAME[1]}";
    if [[ -z "${value_name}" ]]; then
        fail " '${assertion_name}' $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
    fi
}

_testing.__gettext ()
{
    stdlib.__gettext.call "stdlib_testing" "${1}"
}

_testing.__message.get ()
{
    builtin local key="${1}";
    builtin local message;
    builtin local option1="${2}";
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        DEBUG_DIFF_FOOTER)
            required_options=0;
            message="$(_testing.__gettext "== End Debug Diff ==")"
        ;;
        DEBUG_DIFF_HEADER)
            required_options=0;
            message="$(_testing.__gettext "== Start Debug Diff ==")"
        ;;
        DEBUG_DIFF_PREFIX)
            required_options=0;
            message="$(_testing.__gettext "Diff")"
        ;;
        DEBUG_DIFF_PREFIX_ACTUAL)
            required_options=0;
            message="$(_testing.__gettext "ACTUAL")"
        ;;
        DEBUG_DIFF_PREFIX_EXPECTED)
            required_options=0;
            message="$(_testing.__gettext "EXPECTED")"
        ;;
        LOAD_MODULE_NOT_FOUND)
            required_options=1;
            message="$(_testing.__gettext "The module '\${option1}' could not be found!")"
        ;;
        LOAD_MODULE_NOTIFICATION)
            required_options=1;
            message="$(_testing.__gettext "Loading module '\${option1}' ...")"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="$(_testing.__gettext "Unknown message key '\${key}'")"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        _testing.__protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

_testing.__protect_stdlib ()
{
    builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}";
    builtin local stdlib_function_regex="${stdlib_library_prefix}\\..*";
    while IFS= builtin read -r stdlib_fn_name; do
        stdlib_fn_definition="$(builtin declare -f "${stdlib_fn_name/"declare -f "/}")";
        builtin eval "${stdlib_fn_definition//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}";
    done <<< "$(builtin declare -F | "${_STDLIB_BINARY_GREP}" -E "^declare -f ${stdlib_function_regex}")"
}

_testing.__protected ()
{
    STDLIB_BUILTIN_ALLOW_OVERRIDE_BOOLEAN=1 "$(_testing.__protected_name "${1}")" "${@:2}"
}

_testing.__protected_name ()
{
    builtin local stdlib_library_prefix="${STDLIB_TESTING_PROTECT_PREFIX:-"stdlib"}";
    builtin echo "${1//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}"
}

_testing.assert.__message.get ()
{
    builtin local key="${1}";
    builtin local message;
    {
        builtin local option1="${2}";
        builtin local option2="${3}"
    };
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        ASSERT_ERROR_DID_NOT_FAIL)
            required_options=1;
            message="$(_testing.__gettext "The assertion '\${option1}' was expected to fail, but it succeeded instead.")"
        ;;
        ASSERT_ERROR_FILE_NOT_FOUND)
            required_options=1;
            message="$(_testing.__gettext "the file '\${option1}' does not exist")"
        ;;
        ASSERT_ERROR_OUTPUT_NON_MATCHING)
            required_options=0;
            message="$(_testing.__gettext "the expected output string was not generated")"
        ;;
        ASSERT_ERROR_OUTPUT_NULL)
            required_options=0;
            message="$(_testing.__gettext "the 'TEST_OUTPUT' value is empty, consider using '_capture.output'")"
        ;;
        ASSERT_ERROR_RC_NON_MATCHING)
            required_options=0;
            message="$(_testing.__gettext "the expected status code was not returned")"
        ;;
        ASSERT_ERROR_RC_NULL)
            required_options=0;
            message="$(_testing.__gettext "the 'TEST_RC' value is empty, consider using '_capture.rc'")"
        ;;
        ASSERT_ERROR_SNAPSHOT_NON_MATCHING)
            required_options=1;
            message="$(_testing.__gettext "the contents of '\${option1}' does not match the received output")"
        ;;
        ASSERT_ERROR_VALUE_NOT_NULL)
            required_options=1;
            message="$(_testing.__gettext "The value '\${option1}' is not null!")"
        ;;
        ASSERT_ERROR_VALUE_NULL)
            required_options=0;
            message="$(_testing.__gettext "The value is null!")"
        ;;
        ASSERT_ERROR_INSUFFICIENT_ARGS)
            required_options=1;
            message="$(_testing.__gettext "'\${option1}' was not given sufficient arguments")"
        ;;
        ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING)
            required_options=2;
            message="$(_testing.__gettext "expected [\${option1}] but was [\${option2}]")"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="$(_testing.__gettext "Unknown message key '${key}'")"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        _testing.__protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

_testing.error ()
{
    {
        ( while [[ -n "${1}" ]]; do
            _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_ERROR}" "${1}";
            builtin shift;
        done )
    } 1>&2
}

_testing.fixtures.debug.diff ()
{
    builtin local debug_colour;
    debug_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")";
    builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_HEADER)";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_EXPECTED):" "${1}";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX_ACTUAL):" "${2}";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n" "$(_testing.__message.get DEBUG_DIFF_PREFIX):";
    diff <(builtin printf "%s" "${1}") <(builtin printf "%s" "${2}");
    builtin printf "%s\n" "$(_testing.__message.get DEBUG_DIFF_FOOTER)"
}

_testing.fixtures.random.name ()
{
    builtin local random_name_length="${1:-50}";
    "${_STDLIB_BINARY_TR}" -dc A-Za-z0-9 < /dev/urandom | "${_STDLIB_BINARY_HEAD}" -c "${random_name_length}";
    builtin echo
}

_testing.load ()
{
    [[ "${#@}" == 1 ]] || {
        _testing.error "_testing.load: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    _testing.__protected stdlib.string.colour "${STDLIB_TESTING_THEME_LOAD}" "    $(_testing.__message.get LOAD_MODULE_NOTIFICATION "${1}")";
    . "${1}" 2> /dev/null || {
        _testing.error "$(_testing.__message.get LOAD_MODULE_NOT_FOUND "${1}")";
        builtin return 126
    }
}

_testing.mock.__message.get ()
{
    builtin local key="${1}";
    builtin local message;
    {
        builtin local option1="${2}";
        builtin local option2="${3}"
    };
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        MOCK_CALL_ACTUAL_PREFIX)
            required_options=0;
            message="$(_testing.__gettext "Actual call")"
        ;;
        MOCK_CALL_N_NOT_AS_EXPECTED)
            required_options=2;
            message="$(_testing.__gettext "Mock '\${option1}' call \${option2} was not as expected!")"
        ;;
        MOCK_CALLED_N_TIMES)
            required_options=2;
            message="$(_testing.__gettext "Mock '\${option1}' was called \${option2} times!")"
        ;;
        MOCK_NOT_CALLED)
            required_options=1;
            message="$(_testing.__gettext "Mock '\${option1}' was not called!")"
        ;;
        MOCK_NOT_CALLED_ONCE_WITH)
            required_options=2;
            message="$(_testing.__gettext "Mock '\${option1}' was not called once with '\${option2}' !")"
        ;;
        MOCK_NOT_CALLED_WITH)
            required_options=2;
            message="$(_testing.__gettext "Mock '\${option1}' was not called with '\${option2}' !")"
        ;;
        MOCK_REQUIRES_BUILTIN)
            required_options=2;
            message="$(_testing.__gettext "Mock '\${option1}' requires the '\${option2}' keyword to perform this operation, but it is currently overridden.")"
        ;;
        MOCK_TARGET_INVALID)
            required_options=1;
            message="$(_testing.__gettext "The object identified by '\${option1}' cannot be mocked!")"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="$(_testing.__gettext "Unknown message key '${key}'")"
        ;;
    esac;
    (("${#@}" - 1 == required_options)) || {
        message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        _testing.__protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

_testing.parametrize.__message.get ()
{
    builtin local key="${1}";
    builtin local message;
    builtin local option1="${2}";
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        PARAMETRIZE_CONFIGURATION_ERROR)
            required_options=0;
            message="$(_testing.__gettext "Misconfigured parametrize parameters!")"
        ;;
        PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)
            required_options=0;
            message="$(_testing.__gettext "This test variant was created twice, please check your parametrize configuration for this test.")"
        ;;
        PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)
            required_options=0;
            message="$(_testing.__gettext "Duplicate test variant name!")"
        ;;
        PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)
            required_options=0;
            message="$(_testing.__gettext "It does not exist!")"
        ;;
        PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID)
            required_options=1;
            message="$(_testing.__gettext "The function '${option1}' cannot be used in a parametrize series!")"
        ;;
        PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)
            required_options=0;
            message="$(_testing.__gettext "It's name must be prefixed with '${STDLIB_TESTING_PARAMETRIZE_SETTING_PREFIX}' !")"
        ;;
        PARAMETRIZE_ERROR_TEST_FN_INVALID)
            required_options=1;
            message="$(_testing.__gettext "The function '${option1}' cannot be parametrized.")"
        ;;
        PARAMETRIZE_ERROR_TEST_FN_NAME)
            required_options=0;
            message="$(_testing.__gettext "It's name must start with 'test' and contain a '${STDLIB_TESTING_PARAMETRIZE_SETTING_VARIANT_TAG}' tag, please rename this function!")"
        ;;
        PARAMETRIZE_FOOTER_SCENARIO_VALUES)
            required_options=0;
            message="$(_testing.__gettext "== End Scenario Values ==")"
        ;;
        PARAMETRIZE_HEADER_SCENARIO)
            required_options=0;
            message="$(_testing.__gettext "Parametrize Scenario")"
        ;;
        PARAMETRIZE_HEADER_SCENARIO_VALUES)
            required_options=0;
            message="$(_testing.__gettext "== Begin Scenario Values ==")"
        ;;
        PARAMETRIZE_PREFIX_FIXTURE_COMMAND)
            required_options=0;
            message="$(_testing.__gettext "Fixture Command")"
        ;;
        PARAMETRIZE_PREFIX_FIXTURE_COMMANDS)
            required_options=0;
            message="$(_testing.__gettext "Fixture Commands")"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_NAME)
            required_options=0;
            message="$(_testing.__gettext "Scenario Name")"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_VALUES)
            required_options=0;
            message="$(_testing.__gettext "Value Set")"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_VARIABLE)
            required_options=0;
            message="$(_testing.__gettext "Variables")"
        ;;
        PARAMETRIZE_PREFIX_TEST_NAME)
            required_options=0;
            message="$(_testing.__gettext "Test Name")"
        ;;
        PARAMETRIZE_PREFIX_VARIANT_NAME)
            required_options=0;
            message="$(_testing.__gettext "Variant name")"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="$(_testing.__gettext "Unknown message key '${key}'")"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        message="$(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        _testing.__protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

assert_array_equals ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(_testing.__protected stdlib.array.assert.is_equal "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_array_length ()
{
    if [[ $# -ne 2 ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)";
    fi;
    builtin local _stdlib_expected_length="${1}";
    builtin local _stdlib_indirect_reference;
    builtin local -a _stdlib_indirect_array;
    builtin local _stdlib_variable_name="${2}";
    _testing.__assertion.value.check "${_stdlib_variable_name}";
    _testing.__protected assert_is_array "${_stdlib_variable_name}";
    _stdlib_indirect_reference="${_stdlib_variable_name}[@]";
    _stdlib_indirect_array=("${!_stdlib_indirect_reference}");
    assert_equals "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}" || fail " $(_testing.assert.__message.get ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}")"
}

assert_is_array ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(_testing.__protected stdlib.array.assert.is_array "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_is_fn ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.is_fn "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_not_fn ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(_testing.__protected stdlib.fn.assert.not_fn "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_not_null ()
{
    builtin local _stdlib_test_value="${1}";
    assert_not_equals "" "${_stdlib_test_value}" " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NULL)"
}

assert_null ()
{
    builtin local _stdlib_test_value="${1}";
    assert_equals "" "${_stdlib_test_value}" " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NOT_NULL "${_stdlib_test_value}")"
}

assert_output ()
{
    if [[ -z "${TEST_OUTPUT}" ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NULL)";
    fi;
    assert_equals "${1}" "${TEST_OUTPUT}" " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

assert_output_null ()
{
    assert_equals "" "${TEST_OUTPUT}" " $(_testing.assert.__message.get ASSERT_ERROR_VALUE_NOT_NULL "${TEST_OUTPUT}")"
}

assert_output_raw ()
{
    if [[ -z "${TEST_OUTPUT}" ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NULL)";
    fi;
    assert_equals "${1}" "${TEST_OUTPUT}" " $(_testing.assert.__message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

assert_rc ()
{
    if [[ -z "${TEST_RC}" ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_RC_NULL)";
    fi;
    assert_equals "${1}" "${TEST_RC}" " $(_testing.assert.__message.get ASSERT_ERROR_RC_NON_MATCHING)"
}

assert_snapshot ()
{
    builtin local _stdlib_expected_output;
    builtin local _stdlib_snapshot_filename="${1}";
    _testing.__assertion.value.check "${_stdlib_snapshot_filename}";
    if [[ ! -f "${_stdlib_snapshot_filename}" ]]; then
        fail " $(_testing.assert.__message.get ASSERT_ERROR_FILE_NOT_FOUND "${_stdlib_snapshot_filename}")";
    fi;
    _stdlib_expected_output="$(< "${_stdlib_snapshot_filename}")";
    assert_equals "${_stdlib_expected_output}" "${TEST_OUTPUT}" " $(_testing.assert.__message.get ASSERT_ERROR_SNAPSHOT_NON_MATCHING "${_stdlib_snapshot_filename}")"
}

# this snippet is included by the build script:
# src/testing/mock/mock.snippet
_testing.__protect_stdlib
_mock.__internal.persistence.registry.create
_mock.__internal.persistence.sequence.initialize
