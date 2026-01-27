#!/bin/bash

# stdlib testing parametrize apply library

builtin set -eo pipefail

# @description Applies multiple parametrizer functions to a test function.
# @arg $1 string The name of the test function to parametrize.
# @arg $@ array A series of parametrizer functions to apply.
# @exitcode 0 If the parametrizer functions were applied successfully.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
@parametrize.apply() {
  builtin local original_test_function_name=""
  builtin local parametrized_test_function_name=""
  builtin local parametrizer_index=0
  builtin local parametrizer_fn
  builtin local -a parametrizer_fn_array
  builtin local -a parametrizer_variant_array
  builtin local parametrizer_variant_tag_padding

  original_test_function_name="${1}"
  parametrizer_fn_array=("${@:2}")

  [[ "${#@}" -gt "1" ]] || {
    _testing.error "${FUNCNAME[0]}: $(_testing.__protected stdlib.__message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize.__internal.validate.fn_name.test "${original_test_function_name}" || builtin return 126

  @parametrize.__internal.create.array.fn_variant_tags \
    parametrizer_variant_tag_padding \
    parametrizer_variant_array \
    "${@:2}" || builtin return 126

  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    parametrized_test_function_name="$(
      @parametrize.__internal.create.string.padded_test_fn_variant_name \
        "${original_test_function_name}" \
        "${parametrizer_variant_array[parametrizer_index]}" \
        "${parametrizer_variant_tag_padding}"
    )"
    stdlib.fn.derive.clone \
      "${original_test_function_name}" \
      "${parametrized_test_function_name}"

    "${parametrizer_fn}" "${parametrized_test_function_name}"
  done

  builtin unset -f "${original_test_function_name}"
}
