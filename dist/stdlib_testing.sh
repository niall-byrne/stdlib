#!/bin/bash

# stdlib testing distributable for bash

set -eo pipefail

# stdlib testing variable definitions

declare -- STDLIB_TESTING_THEME_DEBUG_FIXTURE="GREY"
declare -- STDLIB_TESTING_THEME_ERROR="LIGHT_RED"
declare -- STDLIB_TESTING_THEME_LOAD="GREY"
declare -- STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT="LIGHT_BLUE"
declare -- STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES="GREY"
declare -- STDLIB_TESTING_TRACEBACK_REGEX="((^\\.\\/|^\\/)[^:]+:[0-9]+:.*|environment:[0-9]+:_t_runner_custom_execution_context\\(\\))"
declare -a _MOCK_ATTRIBUTES_RESTRICTED=([0]="builtin" [1]="case" [2]="do" [3]="done" [4]="elif" [5]="else" [6]="esac" [7]="eval" [8]="fi" [9]="for" [10]="if" [11]="local" [12]="return" [13]="set" [14]="false" [15]="true" [16]="unset" [17]="while")
declare -- _PARAMETRIZE_DEBUG="0"
declare -- _PARAMETRIZE_FIELD_SEPARATOR=";"
declare -- _PARAMETRIZE_FIXTURE_COMMAND_PREFIX="@fixture "
declare -a _PARAMETRIZE_GENERATED_FUNCTIONS=()
declare -- _PARAMETRIZE_PARAMETRIZER_PREFIX="@parametrize_with_"
declare -- _PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES="0"
declare -- _PARAMETRIZE_VARIANT_TAG="@vary"
declare -- _STDLIB_TESTING_STDLIB_PROTECT_PREFIX=""
declare -a __MOCK_INSTANCES=()
declare -- __MOCK_REGISTRY=""
declare -a __MOCK_SEQUENCE=()
declare -- __MOCK_SEQUENCE_PERSISTENCE_FILE=""
declare -- __MOCK_SEQUENCE_TRACKING="0"

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
        _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize._components.validate.fn_name.test "${original_test_function_name}" || builtin return "$?";
    stdlib.fn.derive.clone "${original_test_function_name}" "${original_test_function_reference}";
    builtin unset -f "${1}";
    builtin shift;
    parametrize_configuration=("${@}");
    @parametrize._components.configuration.parse parametrize_configuration parametrize_configuration_scenario_start_index array_environment_variables array_fixture_commands test_function_variant_padding_value || builtin return "$?";
    parametrize_configuration=("${parametrize_configuration[@]:parametrize_configuration_scenario_start_index}");
    for ((parametrize_configuration_index = 0; "${parametrize_configuration_index}" < "${#parametrize_configuration[@]}"; parametrize_configuration_index++))
    do
        parametrize_configuration_line="${parametrize_configuration[parametrize_configuration_index]}";
        IFS="${_PARAMETRIZE_FIELD_SEPARATOR}" builtin read -ra array_scenario_values <<< "${parametrize_configuration_line}";
        test_function_variant_name="$(@parametrize._components.create.string.padded_test_fn_variant_name "${original_test_function_name}" "${array_scenario_values[0]}" "${test_function_variant_padding_value}")";
        if stdlib.fn.query.is_fn "${test_function_variant_name}"; then
            _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)";
            {
                _testing.message.get PARAMETRIZE_PREFIX_TEST_NAME;
                builtin echo ": '$(__testing.protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "${original_test_function_name}")'";
                _testing.message.get PARAMETRIZE_PREFIX_VARIANT_NAME;
                builtin echo ": '$(__testing.protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_HIGHLIGHT}" "${test_function_variant_name}")'"
            } 1>&2;
            _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)";
            builtin return 126;
        fi;
        @parametrize._components.create.fn.test_variant "${test_function_variant_name}" "${original_test_function_name}" "${original_test_function_reference}" array_environment_variables array_fixture_commands array_scenario_values;
        _PARAMETRIZE_GENERATED_FUNCTIONS+=("${test_function_variant_name}");
    done
}

@parametrize._components.configuration.parse ()
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
    @parametrize._components.configuration.parse_header "${parse_configuration_array[@]}" || builtin return "$?";
    builtin printf -v "${2}" "%s" "${parse_configuration_array_index}";
    @parametrize._components.configuration.parse_scenarios "${parse_configuration_array[@]:"${parse_configuration_array_index}"}" || builtin return "$?";
    if [[ "${#parse_fixture_commands_array[@]}" == "0" ]]; then
        builtin eval "${4}=()";
    else
        builtin eval "${4}=($(builtin printf '%q ' "${parse_fixture_commands_array[@]}"))";
    fi;
    builtin printf -v "${5}" "%s" "${parse_variant_padding_value}"
}

@parametrize._components.configuration.parse_header ()
{
    while [[ -n "${1}" ]]; do
        ((parse_configuration_array_index = parse_configuration_array_index + 1));
        if stdlib.string.query.starts_with "${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}" "${1}"; then
            parse_fixture_commands_array+=("${1/"${_PARAMETRIZE_FIXTURE_COMMAND_PREFIX}"/}");
            builtin shift;
            builtin continue;
        else
            __testing.protected stdlib.array.make.from_string "${parse_env_var_array_name?}" "${_PARAMETRIZE_FIELD_SEPARATOR}" "${1}";
            builtin shift;
            builtin break;
        fi;
    done
}

@parametrize._components.configuration.parse_scenarios ()
{
    builtin local -a parse_scenario_array;
    while [[ -n "${1}" ]]; do
        ((parse_configuration_array_index++));
        __testing.protected stdlib.array.make.from_string parse_scenario_array "${_PARAMETRIZE_FIELD_SEPARATOR}" "${1}";
        @parametrize._components.validate.scenario "${parse_env_var_array_name}" parse_fixture_commands_array parse_scenario_array || builtin return "$?";
        if [[ "${#parse_scenario_array[0]}" -gt "${parse_variant_padding_value}" ]]; then
            parse_variant_padding_value="${#parse_scenario_array[0]}";
        fi;
        builtin shift;
    done
}

@parametrize._components.create.array.fn_variant_tags ()
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
        @parametrize._components.validate.fn_name.parametrizer "${parametrizer_function_name}" || builtin return 126;
        variant_tag="${parametrizer_function_name/${_PARAMETRIZE_PARAMETRIZER_PREFIX}/}";
        variants+=("${variant_tag}");
        if [[ "${#variant_tag}" -gt "${padding_value}" ]]; then
            padding_value="${#variant_tag}";
        fi;
    done;
    builtin printf -v "${arg_name_for_padding_value}" "%s" "${padding_value}";
    builtin eval "${arg_name_for_variant_array}=($(builtin printf '%q ' "${variants[@]}"))"
}

@parametrize._components.create.fn.test_variant ()
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
  $(if [[ "${_PARAMETRIZE_SHOW_ORIGINAL_TEST_NAMES}" == "1" ]]; then
    builtin echo -e "builtin echo -ne '\n                $(__testing.protected stdlib.string.colour "${STDLIB_TESTING_THEME_PARAMETRIZE_ORIGINAL_TEST_NAMES}" "${original_test_function_name} ...")'";
fi
builtin echo "  builtin printf -v \"PARAMETRIZE_SCENARIO_NAME\" \"%s\" \"${array_indirect_scenario_definition[0]}\""
scenario_debug_message+='
'
scenario_debug_message+="$(_testing.message.get PARAMETRIZE_HEADER_SCENARIO): "
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
    scenario_debug_message+="$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMAND): "
scenario_debug_message+="\"${array_indirect_fixture_commands[scenario_index]}\""
scenario_debug_message+='
'
builtin printf "%s\n" "${array_indirect_fixture_commands[scenario_index]}";
done
if [[ "${_PARAMETRIZE_DEBUG}" == "1" ]]; then
    @parametrize._components.debug.message "${scenario_debug_message}";
fi)
    ${original_test_function_reference};
  }
  "
}

@parametrize._components.create.string.padded_test_fn_variant_name ()
{
    builtin local padded_variant_name;
    padded_variant_name="${2// /_}";
    if (("${3}" > "${#2}")); then
        padded_variant_name="$(stdlib.string.pad.right "$(("${3}" - "${#2}"))" "${padded_variant_name}")";
        padded_variant_name="${padded_variant_name// /_}";
    fi;
    builtin echo "${1/"${_PARAMETRIZE_VARIANT_TAG}"/"${padded_variant_name}"}"
}

@parametrize._components.debug.message ()
{
    builtin echo "builtin echo '${1}'"
}

@parametrize._components.validate.fn_name.parametrizer ()
{
    if ! stdlib.fn.query.is_fn "${1}"; then
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")";
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)";
        builtin return 126;
    fi;
    if ! stdlib.string.query.starts_with "${_PARAMETRIZE_PARAMETRIZER_PREFIX}" "${1}"; then
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID "${1}")";
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)";
        builtin return 126;
    fi
}

@parametrize._components.validate.fn_name.test ()
{
    if ! stdlib.fn.query.is_fn "${1}"; then
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")";
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)";
        builtin return 126;
    fi;
    if ! stdlib.string.query.has_substring "${_PARAMETRIZE_VARIANT_TAG}" "${1}" || ! stdlib.string.query.starts_with "test" "${1}"; then
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_INVALID "${1}")";
        _testing.error "$(_testing.message.get PARAMETRIZE_ERROR_TEST_FN_NAME)";
        builtin return 126;
    fi
}

@parametrize._components.validate.scenario ()
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
            _testing.message.get PARAMETRIZE_HEADER_SCENARIO_VALUES;
            builtin echo;
            for ((validation_index = 0; validation_index < "${#validate_env_var_indirect_array[@]}"; validation_index++))
            do
                builtin echo "  ${validate_env_var_indirect_array[validation_index]} = ${validate_scenario_indirect_array[validation_index + 1]}";
            done;
            _testing.message.get PARAMETRIZE_FOOTER_SCENARIO_VALUES;
            builtin echo
        } 1>&2;
        _testing.error "$(_testing.message.get PARAMETRIZE_CONFIGURATION_ERROR)" "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_NAME): ${validate_scenario_indirect_array[0]}" "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VARIABLE): ${validate_env_var_indirect_array[*]} = ${#validate_env_var_indirect_array[@]} variables" "$(_testing.message.get PARAMETRIZE_PREFIX_SCENARIO_VALUES): ${validate_scenario_indirect_array[*]:1} = $((${#validate_scenario_indirect_array[@]} - 1)) values" "$(_testing.message.get PARAMETRIZE_PREFIX_FIXTURE_COMMANDS): $(builtin printf "'%s' " "${validate_fixture_indirect_command_array[@]}")";
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
        _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize._components.validate.fn_name.test "${original_test_function_name}" || builtin return 126;
    @parametrize._components.create.array.fn_variant_tags parametrizer_variant_tag_padding parametrizer_variant_array "${@:2}" || builtin return 126;
    for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++))
    do
        parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}";
        parametrized_test_function_name="$(@parametrize._components.create.string.padded_test_fn_variant_name "${original_test_function_name}" "${parametrizer_variant_array[parametrizer_index]}" "${parametrizer_variant_tag_padding}")";
        stdlib.fn.derive.clone "${original_test_function_name}" "${parametrized_test_function_name}";
        "${parametrizer_fn}" "${parametrized_test_function_name}";
    done;
    builtin unset -f "${original_test_function_name}"
}

@parametrize.compose ()
{
    builtin local -a _PARAMETRIZE_GENERATED_FUNCTIONS;
    builtin local original_test_function_name="${1}";
    builtin local parametrizer_fn;
    builtin local -a parametrizer_fn_array;
    builtin local parametrizer_fn_target;
    builtin local -a parametrizer_fn_targets;
    builtin local parametrizer_index=0;
    parametrizer_fn_array=("${@:2}");
    [[ "${#@}" -gt "1" ]] || {
        _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    @parametrize._components.validate.fn_name.test "${original_test_function_name}" || builtin return 126;
    parametrizer_fn_targets=("${original_test_function_name}");
    for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++))
    do
        parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}";
        @parametrize._components.validate.fn_name.parametrizer "${parametrizer_fn}" || builtin return 126;
        _PARAMETRIZE_GENERATED_FUNCTIONS=();
        for parametrizer_fn_target in "${parametrizer_fn_targets[@]}";
        do
            "${parametrizer_fn}" "${parametrizer_fn_target}";
        done;
        parametrizer_fn_targets=("${_PARAMETRIZE_GENERATED_FUNCTIONS[@]}");
    done;
    builtin unset -f "${original_test_function_name}"
}

__mock.arg_array.array_arg_as_string ()
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

__mock.arg_array.from_array ()
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
            if __testing.protected stdlib.array.query.is_array "${_mock_keyword_arg}"; then
                _mock_arg_array+=("${_mock_keyword_arg}($(__mock.arg_array.array_arg_as_string))");
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

__mock.create_sanitized_fn_name ()
{
    builtin local _fn_name_sanitized;
    builtin local _fn_name_original="${1}";
    _fn_name_sanitized="${_fn_name_original//@/____at_sign____}";
    _fn_name_sanitized="${_fn_name_sanitized//-/____dash____}";
    _fn_name_sanitized="${_fn_name_sanitized//./____dot____}";
    builtin echo "${_fn_name_sanitized}_sanitized"
}

__mock.persistence.create ()
{
    __MOCK_INSTANCES+=("${1}");
    builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")";
    builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
}

__mock.persistence.registry.apply_to_all ()
{
    builtin local mock_instance;
    for mock_instance in "${__MOCK_INSTANCES[@]}";
    do
        "${mock_instance}".mock."${1}";
    done
}

__mock.persistence.registry.cleanup ()
{
    "${_STDLIB_BINARY_RM}" -rf "${__MOCK_REGISTRY}"
}

__mock.persistence.registry.create ()
{
    if [[ -z "${__MOCK_REGISTRY}" ]]; then
        __MOCK_REGISTRY="$("${_STDLIB_BINARY_MKTEMP}" -d)";
    fi
}

__mock.persistence.sequence.clear ()
{
    __MOCK_SEQUENCE=();
    __mock.persistence.sequence.update
}

__mock.persistence.sequence.initialize ()
{
    if [[ -z "${__MOCK_SEQUENCE_PERSISTENCE_FILE}" ]]; then
        __MOCK_SEQUENCE_PERSISTENCE_FILE="$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")";
        __mock.persistence.sequence.update;
    fi
}

__mock.persistence.sequence.retrieve ()
{
    builtin local -a __MOCK_SEQUENCE_PERSISTED_ARRAY;
    builtin eval "$(${_STDLIB_BINARY_CAT} "${__MOCK_SEQUENCE_PERSISTENCE_FILE}")";
    __MOCK_SEQUENCE=("${__MOCK_SEQUENCE_PERSISTED_ARRAY[@]}")
}

__mock.persistence.sequence.update ()
{
    builtin local -a __MOCK_SEQUENCE_PERSISTED_ARRAY;
    __MOCK_SEQUENCE_PERSISTED_ARRAY=("${__MOCK_SEQUENCE[@]}");
    builtin declare -p __MOCK_SEQUENCE_PERSISTED_ARRAY > "${__MOCK_SEQUENCE_PERSISTENCE_FILE}"
}

__testing.protect_stdlib ()
{
    builtin local stdlib_library_prefix="${_STDLIB_TESTING_STDLIB_PROTECT_PREFIX:-"stdlib"}";
    builtin local stdlib_function_regex="^${stdlib_library_prefix}\\..* ()";
    while IFS= builtin read -r stdlib_fn_name; do
        stdlib_fn_definition="$(builtin declare -f "${stdlib_fn_name/" () "/}")";
        builtin eval "${stdlib_fn_definition//"${stdlib_library_prefix}."/"${stdlib_library_prefix}.testing.internal."}";
    done <<< "$(builtin declare -f | "${_STDLIB_BINARY_GREP}" -E "${stdlib_function_regex}")"
}

__testing.protected ()
{
    _STDLIB_BUILTIN_BOOLEAN=1 "${1//"stdlib."/"stdlib.testing.internal."}" "${@:2}"
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
        fail " $(_testing.assert.message.get ASSERT_ERROR_DID_NOT_FAIL "${1}")";
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
    __mock.persistence.create "${1}" "${2}";
    builtin eval "$("/usr/bin/cat" <<EOF


# === component start ==========================
__${2}_mock_keywords=()
__${2}_mock_pipeable=0
__${2}_mock_rc=""
__${2}_mock_side_effects_boolean=0
__${2}_mock_stderr=""
__${2}_mock_stdout=""
# === component end ============================




# === component start ==========================
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


${1}.mock.clear() {
  builtin local -a _mock_object_side_effects
  builtin echo -n "" > "\${__${2}_mock_calls_file}"
  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
}

${1}.mock.reset() {
  ${1}.mock.clear
  __${2}_mock_rc=""
  __${2}_mock_stderr=""
  __${2}_mock_stdout=""
  builtin unset -f __${1}_mock_subcommand || builtin true
}
# === component end ============================




# === component start ==========================
${1}.mock.__call() {
  # $@: the arguments the mock was called with

  builtin local -a _mock_object_args
  builtin local -a _mock_object_call_array

  _mock_object_args=("\${@}")

  __mock.arg_array.from_array     _mock_object_call_array     _mock_object_args     "__${2}_mock_keywords"

  builtin declare -p _mock_object_call_array >> "\${__${2}_mock_calls_file}"

  if [[ "\${__MOCK_SEQUENCE_TRACKING}" == "1" ]]; then
    __mock.persistence.sequence.retrieve
    __MOCK_SEQUENCE+=("${1}")
    __mock.persistence.sequence.update
  fi
}
# === component end ============================




# === component start ==========================
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
${1}.mock.__get_apply_to_matching_mock_calls() {
  # $1: the matching command to execute against mock_args
  # $@: the command to apply to the result

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

${1}.mock.get.call() {
  # $1: the call to retrieve

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  __testing.protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  __testing.protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126

  builtin printf -v _mock_object_escaped_args "%q" "\${1}"

  ${1}.mock.__get_apply_to_matching_mock_calls     "[[ "\\\${_mock_object_call_file_index}" == "\${_mock_object_escaped_args}" ]]"     builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

${1}.mock.get.calls() {
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_escaped_args

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  ${1}.mock.__get_apply_to_matching_mock_calls     "true"     builtin printf '%s\\\\n' '"\${_mock_object_call_array[*]}"'
}

${1}.mock.get.count() {
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  < "\${__${2}_mock_calls_file}" wc -l
}

${1}.mock.get.keywords() {
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  builtin echo "\${__${2}_mock_keywords[*]}"
}
# === component end ============================




# === component start ==========================
${1}.mock.set.keywords() {
  # $@: the keyword names to assign to the mock

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _mock_object_keywords

  _mock_object_keywords=("\${@}")

  __testing.protected stdlib.array.assert.not_contains "" _mock_object_keywords || builtin return 126

  builtin eval "__${2}_mock_keywords=(\$(builtin printf '%q ' "\${@}"))"
}


${1}.mock.set.pipeable() {
  # $1: the boolean to enable or disable the pipeable attribute

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  __testing.protected stdlib.string.assert.is_boolean "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_pipeable" "%s" "\${1}"
}

${1}.mock.set.rc() {
  # $1: the return code to make the mock return
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  __testing.protected stdlib.string.assert.is_integer_with_range "0" "255" "\${1}" || builtin return 126

  builtin printf -v "__${2}_mock_rc" "%s" "\${1}"
}

${1}.mock.set.side_effects() {
  # $1: the array to set as a queue of side effect functions

  builtin local -a _mock_object_side_effects

  _mock_object_side_effects=("\${@}")

  builtin declare -p _mock_object_side_effects > "\${__${2}_mock_side_effects_file}"
  builtin printf -v "__${2}_mock_side_effects_boolean" "%s" "1"
}

${1}.mock.set.stderr() {
  # $1: the value to make the mock emit to stderr

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stderr" "%s" "\${1}"
}

${1}.mock.set.stdout() {
  # $1: the value to make the mock emit to stdout

  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"

  _STDLIB_ARGS_NULL_SAFE=("1")

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  builtin printf -v "__${2}_mock_stdout" "%s" "\${1}"
}

${1}.mock.set.subcommand() {
  # $@: the subcommand to execute on each mock call

  builtin eval "__${1}_mock_subcommand() {
      \${@}
  }"
}
# === component end ============================




# === component start ==========================

${1}.mock.__count_matches() {
  # $1: a set of call args as a string

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

${1}.mock.assert_any_call_is() {
  # $1: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_match_count

  _STDLIB_ARGS_NULL_SAFE=("1")

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  assert_not_equals     "0"     "\${_mock_object_match_count}"     "\$(_testing.mock.message.get "MOCK_NOT_CALLED_WITH" "${1}" "\${1}")"
}

${1}.mock.assert_call_n_is() {
  # $1: the call count to assert
  # $2: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_call_count

  _STDLIB_ARGS_NULL_SAFE=("2")

  __testing.protected stdlib.fn.args.require "2" "0" "\${@}" || builtin return "\$?"
  __testing.protected stdlib.string.assert.is_digit "\${1}" || builtin return 126
  __testing.protected stdlib.string.assert.not_equal "0" "\${1}" || builtin return 126

  _mock_object_call_count="\$(${1}.mock.get.count)"

  if [[ "\${_mock_object_call_count}" -lt "\${1}" ]]; then
    fail       "\$(_testing.mock.message.get MOCK_CALLED_N_TIMES "${1}" "\${_mock_object_call_count}")"
  fi

  _mock_object_arg_string_actual="\$("${1}.mock.get.call" "\${1}")"

  assert_equals     "\${2}"     "\${_mock_object_arg_string_actual}"     "\$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\${1}")"
}

${1}.mock.assert_called_once_with() {
  # $1: a set of call args as a string

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local -a _STDLIB_ARGS_NULL_SAFE
  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_match_count

  _STDLIB_ARGS_NULL_SAFE=("1")

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"

  ${1}.mock.assert_count_is "1"

  _mock_object_match_count="\$(${1}.mock.__count_matches "\${1}")"

  if [[ "\${_mock_object_match_count}" != "1" ]]; then
    _mock_object_arg_string_actual="\$(${1}.mock.get.call "1")"
    builtin echo       "\$(_testing.mock.message.get MOCK_CALL_ACTUAL_PREFIX): [\${_mock_object_arg_string_actual}]"
  fi

  assert_equals     "1"     "\${_mock_object_match_count}"     "\$(_testing.mock.message.get MOCK_NOT_CALLED_ONCE_WITH "${1}" "\${1}")"
}

${1}.mock.assert_calls_are() {
  # $@: a set of call args as strings that should match

  builtin local _mock_object_arg_string_actual
  builtin local _mock_object_arg_string_expected
  builtin local _mock_object_call_definition=""
  builtin local _mock_object_call_index=0
  builtin local -a _mock_object_expected_mock_calls

  _mock_object_expected_mock_calls=("\${@}")

  while IFS= builtin read -r _mock_object_call_definition; do
    builtin eval "\${_mock_object_call_definition}"
    builtin printf -v _mock_object_arg_string_expected "%q" "\${_mock_object_expected_mock_calls[_mock_object_call_index]}"
    builtin printf -v _mock_object_arg_string_actual "%q" "\${_mock_object_call_array[*]}"

    assert_equals       "\${_mock_object_arg_string_expected}"       "\${_mock_object_arg_string_actual}"       "\$(_testing.mock.message.get MOCK_CALL_N_NOT_AS_EXPECTED "${1}" "\$((_mock_object_call_index + 1))")"
    ((_mock_object_call_index++))
  done < "\${__${2}_mock_calls_file}" || builtin true

  if [[ "\${_mock_object_call_index}" == 0 ]] && [[ "\${#@}" != 0 ]]; then
    fail "\$(_testing.mock.message.get "MOCK_NOT_CALLED" "${1}")"
  fi

  if [[ "\${_mock_object_call_index}" < "\${#_mock_object_expected_mock_calls[@]}" ]]; then
    fail "\$(_testing.mock.message.get MOCK_CALLED_N_TIMES "${1}" "\$((_mock_object_call_index))")"
  fi
}

${1}.mock.assert_count_is() {
  # $1: the call count to assert

  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  __testing.protected stdlib.fn.args.require "1" "0" "\${@}" || builtin return "\$?"
  __testing.protected stdlib.string.assert.is_digit "\${1}" || builtin return 126

  _mock_object_call_count="\$("${1}.mock.get.count")"

  assert_equals     "\${1}"     "\${_mock_object_call_count}"     "\$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}

${1}.mock.assert_not_called() {
  builtin local _STDLIB_ARGS_CALLER_FN_NAME="\${FUNCNAME[0]}"
  builtin local _mock_object_call_count

  __testing.protected stdlib.fn.args.require "0" "0" "\${@}" || builtin return "\$?"

  _mock_object_call_count="\$(${1}.mock.get.count)"

  assert_equals     "0"     "\${_mock_object_call_count}"     "\$(_testing.mock.message.get "MOCK_CALLED_N_TIMES" "${1}" "\${_mock_object_call_count}")"
}
# === component end ============================


EOF
)"
}

_mock.arg_string.from_array ()
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
    __testing.protected stdlib.fn.args.require "1" "1" "$@" || builtin return 127;
    __testing.protected stdlib.array.assert.is_array "${1}" || builtin return 126;
    if [[ "${#@}" == 2 ]]; then
        __testing.protected stdlib.array.assert.is_array "${2}" || builtin return 126;
    fi;
    __mock.arg_array.from_array _mock_generated_mock_arg_array "${@}";
    builtin echo "${_mock_generated_mock_arg_array[*]}"
}

_mock.arg_string.from_string ()
{
    builtin local -a _STDLIB_ARGS_NULL_SAFE;
    builtin local -a _mock_args_array;
    builtin local -a _mock_arg_string_args;
    builtin local _mock_separator="${_STDLIB_DELIMITER:- }";
    _STDLIB_ARGS_NULL_SAFE=("2");
    _mock_arg_string_args=("_mock_args_array");
    __testing.protected stdlib.fn.args.require "1" "1" "${@}" || builtin return 127;
    if [[ -n "${2}" ]]; then
        _mock_arg_string_args+=("${2}");
    fi;
    __testing.protected stdlib.array.make.from_string _mock_args_array "${_mock_separator}" "${1}" || builtin return "$?";
    _mock.arg_string.from_array "${_mock_arg_string_args[@]}"
}

_mock.clear_all ()
{
    __mock.persistence.registry.apply_to_all "clear"
}

_mock.create ()
{
    builtin local _mock_sanitized_fn_name;
    builtin local _mock_escaped_fn_name;
    builtin local _mock_attribute;
    builtin local _mock_restricted_attribute_boolean=0;
    if [[ "${#@}" != 1 ]] || [[ -z "${1}" ]]; then
        _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        builtin return 127;
    fi;
    if ! __testing.protected stdlib.fn.query.is_valid_name "${1}" || __testing.protected stdlib.array.query.is_contains "${1}" _MOCK_ATTRIBUTES_RESTRICTED; then
        _testing.error "${FUNCNAME[0]}: $(_testing.message.get MOCK_TARGET_INVALID "${1}")";
        builtin return 126;
    fi;
    builtin printf -v "_mock_escaped_fn_name" "%q" "${1}";
    _mock_sanitized_fn_name="$(__mock.create_sanitized_fn_name "${_mock_escaped_fn_name}")";
    if __testing.protected stdlib.fn.query.is_fn "${_mock_escaped_fn_name}"; then
        __testing.protected stdlib.fn.derive.clone "${_mock_escaped_fn_name}" "${_mock_escaped_fn_name}____copy_of_original_implementation";
    fi;
    _mock.__generate_mock "${_mock_escaped_fn_name}" "${_mock_sanitized_fn_name}"
}

_mock.delete ()
{
    __testing.protected stdlib.fn.assert.is_fn "${1}" || builtin return 127;
    __testing.protected stdlib.fn.assert.is_fn "${1}.mock.set.subcommand" || builtin return 127;
    builtin unset -f "${1}";
    while IFS= builtin read -r mocked_function; do
        mocked_function="${mocked_function/" ()"/}";
        mocked_function="${mocked_function%?}";
        builtin unset -f "${mocked_function/" ()"/}";
    done <<< "$(builtin declare -f | ${_STDLIB_BINARY_GREP} -E "^${1}.mock.* ()")";
    if __testing.protected stdlib.fn.query.is_fn "${1}____copy_of_original_implementation"; then
        __testing.protected stdlib.fn.derive.clone "${1}____copy_of_original_implementation" "${1}";
    fi
}

_mock.reset_all ()
{
    __mock.persistence.registry.apply_to_all "reset"
}

_mock.sequence.assert_is ()
{
    builtin local -a mock_sequence;
    builtin local -a expected_mock_sequence;
    expected_mock_sequence=("$@");
    _testing.__assertion.value.check "${@}";
    _mock.sequence.record.stop;
    __mock.persistence.sequence.retrieve;
    mock_sequence=("${__MOCK_SEQUENCE[@]}");
    assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.assert_is_empty ()
{
    builtin local -a mock_sequence;
    builtin local -a expected_mock_sequence;
    _mock.sequence.record.stop;
    __mock.persistence.sequence.retrieve;
    mock_sequence=("${__MOCK_SEQUENCE[@]}");
    assert_array_equals expected_mock_sequence mock_sequence
}

_mock.sequence.clear ()
{
    __mock.persistence.sequence.clear
}

_mock.sequence.record.resume ()
{
    __MOCK_SEQUENCE_TRACKING="1"
}

_mock.sequence.record.start ()
{
    __mock.persistence.sequence.clear;
    __MOCK_SEQUENCE_TRACKING="1"
}

_mock.sequence.record.stop ()
{
    __MOCK_SEQUENCE_TRACKING="0"
}

_testing.__assertion.value.check ()
{
    builtin local value_name="${1}";
    builtin local assertion_name="${FUNCNAME[1]}";
    if [[ -z "${value_name}" ]]; then
        fail " '${assertion_name}' $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
    fi
}

_testing.assert.message.get ()
{
    builtin local key="${1}";
    builtin local message;
    builtin local option1="${2}";
    builtin local option2="${3}";
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        ASSERT_ERROR_DID_NOT_FAIL)
            required_options=1;
            message="The assertion '${option1}' was expected to fail, but it succeeded instead."
        ;;
        ASSERT_ERROR_FILE_NOT_FOUND)
            required_options=1;
            message="the file '${option1}' does not exist"
        ;;
        ASSERT_ERROR_OUTPUT_NON_MATCHING)
            required_options=0;
            message="the expected output string was not generated"
        ;;
        ASSERT_ERROR_OUTPUT_NULL)
            required_options=0;
            message="the 'TEST_OUTPUT' value is empty, consider using '_capture.output'"
        ;;
        ASSERT_ERROR_RC_NON_MATCHING)
            required_options=0;
            message="the expected status code was not returned"
        ;;
        ASSERT_ERROR_RC_NULL)
            required_options=0;
            message="the 'TEST_RC' value is empty, consider using '_capture.rc'"
        ;;
        ASSERT_ERROR_SNAPSHOT_NON_MATCHING)
            required_options=1;
            message="the contents of '${option1}' does not match the received output"
        ;;
        ASSERT_ERROR_VALUE_NOT_NULL)
            required_options=1;
            message="The value '${option1}' is not null!"
        ;;
        ASSERT_ERROR_VALUE_NULL)
            required_options=0;
            message="The value is null!"
        ;;
        ASSERT_ERROR_INSUFFICIENT_ARGS)
            required_options=1;
            message="'${option1}' was not given sufficient arguments"
        ;;
        ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING)
            required_options=2;
            message="expected [${option1}] but was [${option2}]"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="Unknown message key '${key}'"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        __testing.protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

_testing.error ()
{
    {
        ( while [[ -n "${1}" ]]; do
            __testing.protected stdlib.string.colour "${STDLIB_TESTING_THEME_ERROR}" "${1}";
            builtin shift;
        done )
    } 1>&2
}

_testing.fixtures.debug.diff ()
{
    builtin local debug_colour;
    debug_colour="$(stdlib.setting.theme.get_colour "${STDLIB_TESTING_THEME_DEBUG_FIXTURE}")";
    builtin printf "%s\n" "$(_testing.message.get DEBUG_DIFF_HEADER)";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.message.get DEBUG_DIFF_PREFIX_EXPECTED):" "${1}";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n%q\n" "$(_testing.message.get DEBUG_DIFF_PREFIX_ACTUAL):" "${2}";
    builtin printf "${!debug_colour}%s${STDLIB_COLOUR_NC}\n" "$(_testing.message.get DEBUG_DIFF_PREFIX):";
    diff <(builtin printf "%s" "${1}") <(builtin printf "%s" "${2}");
    builtin printf "%s\n" "$(_testing.message.get DEBUG_DIFF_FOOTER)"
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
        _testing.error "_testing.load: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        builtin return 127
    };
    __testing.protected stdlib.string.colour "${STDLIB_TESTING_THEME_LOAD}" "    $(_testing.message.get LOAD_MODULE_NOTIFICATION "${1}")";
    . "${1}" 2> /dev/null || {
        _testing.error "$(_testing.message.get LOAD_MODULE_NOT_FOUND "${1}")";
        builtin return 126
    }
}

_testing.message.get ()
{
    builtin local key="${1}";
    builtin local message;
    builtin local option1="${2}";
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        DEBUG_DIFF_FOOTER)
            required_options=0;
            message="== End Debug Diff =="
        ;;
        DEBUG_DIFF_HEADER)
            required_options=0;
            message="== Start Debug Diff =="
        ;;
        DEBUG_DIFF_PREFIX)
            required_options=0;
            message="Diff"
        ;;
        DEBUG_DIFF_PREFIX_ACTUAL)
            required_options=0;
            message="ACTUAL"
        ;;
        DEBUG_DIFF_PREFIX_EXPECTED)
            required_options=0;
            message="EXPECTED"
        ;;
        LOAD_MODULE_NOT_FOUND)
            required_options=1;
            message="The module '${option1}' could not be found!"
        ;;
        LOAD_MODULE_NOTIFICATION)
            required_options=1;
            message="Loading module '${option1}' ..."
        ;;
        MOCK_TARGET_INVALID)
            required_options=1;
            message="The object identified by '${option1}' cannot be mocked!"
        ;;
        PARAMETRIZE_CONFIGURATION_ERROR)
            required_options=0;
            message="Misconfigured parametrize parameters!"
        ;;
        PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_DETAIL)
            required_options=0;
            message="This test variant was created twice, please check your parametrize configuration for this test."
        ;;
        PARAMETRIZE_ERROR_DUPLICATE_TEST_VARIANT_NAME)
            required_options=0;
            message="Duplicate test variant name!"
        ;;
        PARAMETRIZE_ERROR_FN_DOES_NOT_EXIST)
            required_options=0;
            message="It does not exist!"
        ;;
        PARAMETRIZE_ERROR_PARAMETRIZER_FN_INVALID)
            required_options=1;
            message="The function '${option1}' cannot be used in a parametrize series!"
        ;;
        PARAMETRIZE_ERROR_PARAMETRIZER_FN_NAME)
            required_options=0;
            message="It's name must be prefixed with '${_PARAMETRIZE_PARAMETRIZER_PREFIX}' !"
        ;;
        PARAMETRIZE_ERROR_TEST_FN_INVALID)
            required_options=1;
            message="The function '${option1}' cannot be parametrized."
        ;;
        PARAMETRIZE_ERROR_TEST_FN_NAME)
            required_options=0;
            message="It's name must start with 'test' and contain a '${_PARAMETRIZE_VARIANT_TAG}' tag, please rename this function!"
        ;;
        PARAMETRIZE_FOOTER_SCENARIO_VALUES)
            required_options=0;
            message="== End Scenario Values =="
        ;;
        PARAMETRIZE_HEADER_SCENARIO)
            required_options=0;
            message="Parametrize Scenario"
        ;;
        PARAMETRIZE_HEADER_SCENARIO_VALUES)
            required_options=0;
            message="== Begin Scenario Values =="
        ;;
        PARAMETRIZE_PREFIX_FIXTURE_COMMAND)
            required_options=0;
            message="Fixture Command"
        ;;
        PARAMETRIZE_PREFIX_FIXTURE_COMMANDS)
            required_options=0;
            message="Fixture Commands"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_NAME)
            required_options=0;
            message="Scenario Name"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_VALUES)
            required_options=0;
            message="Value Set"
        ;;
        PARAMETRIZE_PREFIX_SCENARIO_VARIABLE)
            required_options=0;
            message="Variables"
        ;;
        PARAMETRIZE_PREFIX_TEST_NAME)
            required_options=0;
            message="Test Name"
        ;;
        PARAMETRIZE_PREFIX_VARIANT_NAME)
            required_options=0;
            message="Variant name"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="Unknown message key '${key}'"
        ;;
    esac;
    (("${#@}" == 1 + required_options)) || {
        message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        __testing.protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

_testing.mock.message.get ()
{
    builtin local key="${1}";
    builtin local message;
    builtin local option1="${2}";
    builtin local option2="${3}";
    builtin local required_options=0;
    builtin local return_status=0;
    case "${key}" in
        MOCK_CALL_ACTUAL_PREFIX)
            required_options=0;
            message="Actual call"
        ;;
        MOCK_CALL_N_NOT_AS_EXPECTED)
            required_options=2;
            message="Mock '${option1}' call ${option2} was not as expected!"
        ;;
        MOCK_CALLED_N_TIMES)
            required_options=2;
            message="Mock '${option1}' was called ${option2} times!"
        ;;
        MOCK_NOT_CALLED)
            required_options=1;
            message="Mock '${option1}' was not called!"
        ;;
        MOCK_NOT_CALLED_ONCE_WITH)
            required_options=2;
            message="Mock '${option1}' was not called once with '${option2}' !"
        ;;
        MOCK_NOT_CALLED_WITH)
            required_options=2;
            message="Mock '${option1}' was not called with '${option2}' !"
        ;;
        "")
            required_options=0;
            return_status=126;
            message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
        ;;
        *)
            required_options=0;
            return_status=126;
            message="Unknown message key '${key}'"
        ;;
    esac;
    (("${#@}" - 1 == required_options)) || {
        message="$(__testing.protected stdlib.message.get ARGUMENTS_INVALID)";
        return_status=127
    };
    ((return_status == 0)) || {
        __testing.protected stdlib.logger.error "${message}";
        builtin return ${return_status}
    };
    builtin echo -n "${message}"
}

assert_array_equals ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(__testing.protected stdlib.array.assert.is_equal "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_array_length ()
{
    if [[ $# -ne 2 ]]; then
        fail " $(_testing.assert.message.get ASSERT_ERROR_INSUFFICIENT_ARGS assert_array_length)";
    fi;
    builtin local _stdlib_expected_length="${1}";
    builtin local _stdlib_indirect_reference;
    builtin local -a _stdlib_indirect_array;
    builtin local _stdlib_variable_name="${2}";
    _testing.__assertion.value.check "${_stdlib_variable_name}";
    __testing.protected assert_is_array "${_stdlib_variable_name}";
    _stdlib_indirect_reference="${_stdlib_variable_name}[@]";
    _stdlib_indirect_array=("${!_stdlib_indirect_reference}");
    assert_equals "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}" || fail " $(_testing.assert.message.get ASSERT_ERROR_ARRAY_LENGTH_NON_MATCHING "${_stdlib_expected_length}" "${#_stdlib_indirect_array[*]}")"
}

assert_is_array ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(__testing.protected stdlib.array.assert.is_array "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_is_fn ()
{
    builtin local _stdlib_assertion_output;
    builtin local _stdlib_return_code=0;
    _stdlib_assertion_output="$(__testing.protected stdlib.fn.assert.is_fn "${@}" 2>&1)" || _stdlib_return_code="$?";
    _stdlib_assertion_output="${_stdlib_assertion_output/'
'/'
 '}";
    [[ "${_stdlib_return_code}" == "0" ]] || fail " ${_stdlib_assertion_output}"
}

assert_not_null ()
{
    builtin local _stdlib_test_value="${1}";
    assert_not_equals "" "${_stdlib_test_value}" " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NULL)"
}

assert_null ()
{
    builtin local _stdlib_test_value="${1}";
    assert_equals "" "${_stdlib_test_value}" " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "${_stdlib_test_value}")"
}

assert_output ()
{
    if [[ -z "${TEST_OUTPUT}" ]]; then
        fail " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)";
    fi;
    assert_equals "${1}" "${TEST_OUTPUT}" " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

assert_output_null ()
{
    assert_equals "" "${TEST_OUTPUT}" " $(_testing.assert.message.get ASSERT_ERROR_VALUE_NOT_NULL "${TEST_OUTPUT}")"
}

assert_output_raw ()
{
    if [[ -z "${TEST_OUTPUT}" ]]; then
        fail " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NULL)";
    fi;
    assert_equals "${1}" "${TEST_OUTPUT}" " $(_testing.assert.message.get ASSERT_ERROR_OUTPUT_NON_MATCHING)"
}

assert_rc ()
{
    if [[ -z "${TEST_RC}" ]]; then
        fail " $(_testing.assert.message.get ASSERT_ERROR_RC_NULL)";
    fi;
    assert_equals "${1}" "${TEST_RC}" " $(_testing.assert.message.get ASSERT_ERROR_RC_NON_MATCHING)"
}

assert_snapshot ()
{
    builtin local _stdlib_expected_output;
    builtin local _stdlib_snapshot_filename="${1}";
    _testing.__assertion.value.check "${_stdlib_snapshot_filename}";
    if [[ ! -f "${_stdlib_snapshot_filename}" ]]; then
        fail " $(_testing.assert.message.get ASSERT_ERROR_FILE_NOT_FOUND "${_stdlib_snapshot_filename}")";
    fi;
    _stdlib_expected_output="$(< "${_stdlib_snapshot_filename}")";
    assert_equals "${_stdlib_expected_output}" "${TEST_OUTPUT}" " $(_testing.assert.message.get ASSERT_ERROR_SNAPSHOT_NON_MATCHING "${_stdlib_snapshot_filename}")"
}

# this snippet is included by the build script:
# src/testing/mock/mock.snippet
__testing.protect_stdlib
__mock.persistence.registry.create
__mock.persistence.sequence.initialize
