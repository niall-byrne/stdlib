#!/bin/bash

# stdlib testing parametrize compose library

builtin set -eo pipefail

# @description Composes multiple parametrizer functions to create a product of scenarios.
# @arg $1 string The name of the test function to parametrize.
# @arg $@ array A series of parametrizer functions to compose.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
@parametrize.compose() {
  builtin local -a __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY
  builtin local original_test_function_name="${1}"
  builtin local parametrizer_fn
  builtin local -a parametrizer_fn_array
  builtin local parametrizer_fn_target
  builtin local -a parametrizer_fn_targets
  builtin local parametrizer_index=0

  parametrizer_fn_array=("${@:2}")

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126

  parametrizer_fn_targets=("${original_test_function_name}")
  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    @parametrize.__internal.validate.fn_name.parametrizer "${parametrizer_fn}" || builtin return 126
    __STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY=()
    for parametrizer_fn_target in "${parametrizer_fn_targets[@]}"; do
      "${parametrizer_fn}" "${parametrizer_fn_target}"
    done
    parametrizer_fn_targets=("${__STDLIB_TESTING_PARAMETRIZE_GENERATED_FUNCTIONS_ARRAY[@]}")
  done

  builtin unset -f "${original_test_function_name}"
}
