#!/bin/bash
# stdlib.global_variables
# builtin set -eo pipefail

# @description Documented usage.
#   * STDLIB_DOC_VAR: A documented variable (default="val").
# @noargs
# @exitcode 0 If success.
stdlib.documented_usage() {
  builtin echo "${STDLIB_DOC_VAR}"
}

# @description Undocumented usage.
# @noargs
# @exitcode 0 If success.
stdlib.undocumented_usage() {
  builtin echo "${STDLIB_UNDOC_VAR}"
}

# @description Inline assignment.
# @noargs
# @exitcode 0 If success.
stdlib.inline_assignment() {
  STDLIB_KW_VAR="val" some_command
}

# @description Local variable with global prefix.
# @noargs
# @exitcode 0 If success.
stdlib.local_variable() {
  builtin local STDLIB_LOCAL_VAR="val"
  builtin echo "${STDLIB_LOCAL_VAR}"
}

# @description Variable documented with @set.
# @noargs
# @set STDLIB_SET_VAR string A variable set by the function.
# @exitcode 0 If success.
stdlib.set_documented() {
  STDLIB_SET_VAR="val"
}

# @description Mock template variable.
#   * __${2}_MOCK_VAR: A mock template variable (default="val").
# @noargs
# @exitcode 0 If success.
stdlib.mock_template() {
  builtin echo "${__${2}_MOCK_VAR}"
}
