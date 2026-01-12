#!/bin/bash

# stdlib testing parametrize apply library

builtin set -eo pipefail

@parametrize.apply() {
  # $1: the name of the test function to parametrize
  # $@: a series of parametrize functions to apply to this function

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
    _testing.error "${FUNCNAME[0]}: $(__testing.protected stdlib.message.get ARGUMENTS_INVALID)"
    builtin return 127
  }
  @parametrize._components.validate.fn_name.test "${original_test_function_name}" || builtin return 126

  @parametrize._components.create.array.fn_variant_tags \
    parametrizer_variant_tag_padding \
    parametrizer_variant_array \
    "${@:2}" || builtin return 126

  for ((parametrizer_index = 0; parametrizer_index < "${#parametrizer_fn_array[@]}"; parametrizer_index++)); do
    parametrizer_fn="${parametrizer_fn_array[parametrizer_index]}"
    parametrized_test_function_name="$(
      @parametrize._components.create.string.padded_test_fn_variant_name \
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
