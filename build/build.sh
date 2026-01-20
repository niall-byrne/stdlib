#!/bin/bash

# stdlib distributable build script

__build_add_snippet() {
  # $1: the snippet file to add

  echo
  echo "# this snippet is included by the build script:"
  echo "# ${1}"

  tail +3 "${1}"
}

__build_generate_step_1_stdlib_file_header() {
  echo "#!/bin/bash"
  echo
  echo "# stdlib distributable for bash"

  __build_add_snippet src/security/shell/shell.snippet

  echo
  echo "builtin set -eo pipefail"
}

__build_generate_step_1_testing_file_header() {
  echo "#!/bin/bash"
  echo
  echo "# stdlib testing distributable for bash"
  echo
  echo "set -eo pipefail"
}

__build_generate_step_2_stdlib_variables() {
  echo
  echo "# stdlib variable definitions"
  echo

  while IFS= read -r stdlib_variable_name_line; do
    echo "${stdlib_variable_name_line}"
  done <<< "$(builtin declare -p | "${_STDLIB_BINARY_GREP}" -E "${stdlib_variable_regex}" | "${_STDLIB_BINARY_GREP}" -v "${stdlib_variable_filter}")"
}

__build_generate_step_2_testing_variables() {
  echo
  echo "# stdlib testing variable definitions"
  echo

  while IFS= read -r stdlib_variable_name_line; do
    echo "${stdlib_variable_name_line}"
  done <<< "$(builtin declare -p | "${_STDLIB_BINARY_GREP}" -E "${stdlib_testing_variable_regex}")"
}

__build_generate_step_3_stdlib_functions() {
  echo
  echo "# stdlib function definitions"

  while IFS= read -r stdlib_fn_name_line; do
    stdlib_fn_name="${stdlib_fn_name_line/" () "/}"
    echo
    declare -f "${stdlib_fn_name}"
  done <<< "$(builtin declare -f | "${_STDLIB_BINARY_GREP}" -E "${stdlib_function_regex}" | "${_STDLIB_BINARY_GREP}" -v "${stdlib_function_filter}")"
}

__build_generate_step_3_testing_functions() {
  echo
  echo "# stdlib testing function definitions"

  while IFS= read -r stdlib_fn_name_line; do
    stdlib_fn_name="${stdlib_fn_name_line/" () "/}"
    echo
    declare -f "${stdlib_fn_name}"
  done <<< "$(builtin declare -f | "${_STDLIB_BINARY_GREP}" -E "${stdlib_testing_function_regex}" | "${_STDLIB_BINARY_GREP}" -v "${stdlib_testing_function_filter}")"
}

__build_generate_step_4_stdlib_snippets() {
  __build_add_snippet src/gettext.snippet
  __build_add_snippet src/trap/register.snippet
}

__build_generate_step_4_testing_snippets() {
  __build_add_snippet src/testing/mock/mock.snippet
}

__build_generate_step_5_stdlib_settings() {
  echo
  echo "# colours are disabled by default"
  echo "stdlib.setting.colour.disable"
}

__build_target() {
  # $1: the target to build

  case "${1}" in
    stdlib)
      source src/__lib__.sh
      __build_generate_step_1_stdlib_file_header
      __build_generate_step_2_stdlib_variables
      __build_generate_step_3_stdlib_functions
      __build_generate_step_4_stdlib_snippets
      __build_generate_step_5_stdlib_settings
      ;;
    testing)
      source src/__lib__.sh
      source src/testing/__lib__.sh
      __build_generate_step_1_testing_file_header
      __build_generate_step_2_testing_variables
      __build_generate_step_3_testing_functions
      __build_generate_step_4_testing_snippets
      ;;
    *)
      echo "ERROR: unknown build target!"
      exit 127
      ;;
  esac
}

__build() {
  local stdlib_library_prefix="stdlib"
  local stdlib_function_regex="^${stdlib_library_prefix}\\..* ()"
  local stdlib_function_filter="^${stdlib_library_prefix}.security.__shell.assert.is_safe ()"
  local stdlib_variable_regex=" _*STDLIB_.*="
  local stdlib_variable_filter="STDLIB_DIRECTORY\|STDLIB_TEXTDOMAINDIR"

  local stdlib_testing_library_prefix="((_mock|_testing|_capture|\\@parametrize)\\.|assert_|\\@parametrize)"
  local stdlib_testing_function_regex="^${stdlib_testing_library_prefix}.* ()"
  local stdlib_testing_function_filter="^_mock.__internal.compile ()"
  local stdlib_testing_variable_regex="( _*STDLIB_TESTING_.*=| _*PARAMETRIZE_.*=| _*MOCK_.*=)"

  local stdlib_variable_name_line
  local stdlib_fn_name_line
  local stdlib_fn_name

  __build_target "${1}"
}

__build "${@}"
