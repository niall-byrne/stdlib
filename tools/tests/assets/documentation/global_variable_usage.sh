#!/bin/bash

# @description Documented global variable usage.
#   * STDLIB_LOGGING_MESSAGE_PREFIX string keyword: A prefix identifying the calling function (default="").
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.documented_global_var() {
  builtin echo "${STDLIB_LOGGING_MESSAGE_PREFIX}"
}

# @description Undocumented global variable usage.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.undocumented_global_var() {
  builtin echo "${STDLIB_THEME_LOGGER_ERROR}"
}

# @description Local variable usage should be ignored.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.local_var_usage() {
  builtin local STDLIB_THEME_LOGGER_ERROR="local"
  builtin echo "${STDLIB_THEME_LOGGER_ERROR}"
}

# @description Documented via @set tag.
# @noargs
# @exitcode 0 If the operation succeeded.
# @set STDLIB_OUTPUT_VARIABLE string The output variable.
stdlib.documented_via_set() {
  # shellcheck disable=SC2034
  STDLIB_OUTPUT_VARIABLE="value"
}

# @description Undocumented internal global variable.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
stdlib.__undocumented_internal_var() {
  builtin echo "${__STDLIB_LOGGING_DECORATORS_ARRAY[@]}"
}

# @description Documented internal global variable.
#   * __STDLIB_LOGGING_DECORATORS_ARRAY array global: An array of decorators (default=()).
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
stdlib.__documented_internal_var() {
  builtin echo "${__STDLIB_LOGGING_DECORATORS_ARRAY[@]}"
}

# @description Usage of binary variable.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.binary_var_usage() {
  "${_STDLIB_BINARY_CAT}" << EOF
hello
EOF
}

# @description Usage with noqa should be ignored.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.noqa_usage() {
  builtin echo "${STDLIB_UNDOCUMENTED_VAR}" # noqa
}

# @description Global variable name as argument.
# @arg $1 string The array name.
# @exitcode 0 If it is an array.
stdlib.var_name_as_arg() {
  stdlib.array.query.is_array STDLIB_THEME_LOGGER_ERROR
}

eval "$(
  "${_STDLIB_BINARY_CAT}" << 'EOF'

# @description Mock component documented.
#   * __${2}_mock_rc integer global: The return code (default=0).
# @noargs
# @exitcode 0 If the operation succeeded.
${1}.mock.documented() {
  builtin return "${__${2}_mock_rc}"
}

# @description Mock component undocumented.
# @noargs
# @exitcode 0 If the operation succeeded.
${1}.mock.undocumented() {
  builtin return "${__${2}_mock_rc}"
}

EOF
)"
#!/bin/bash

# @description This function uses an inline global variable assignment.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.inline_assignment_usage() {
  STDLIB_KW_SOURCE_VAR="lock_permissions" stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_octal_permission STDLIB_LOCK_PERMISSION_OCTAL || builtin return 125
}
