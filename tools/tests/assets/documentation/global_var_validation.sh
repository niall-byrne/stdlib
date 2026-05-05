#!/bin/bash

# @description A function with no global variables.
# @noargs
# @exitcode 0 If successful.
stdlib.no_global_vars() {
  builtin return 0
}

# @description A function with a validated global variable.
#   * STDLIB_VALIDATED_VAR: A validated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.validated_global_var() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_VALIDATED_VAR
  builtin return 0
}

# @description A function with an unvalidated global variable.
#   * STDLIB_UNVALIDATED_VAR: An unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.unvalidated_global_var() {
  builtin return 0
}

# @description A function with multiple global variables, one unvalidated.
#   * STDLIB_VALID_VAR: A validated variable (default=0).
#   * STDLIB_INVALID_VAR: An unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.multiple_global_vars() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_VALID_VAR
  builtin return 0
}

# @description A function with a dynamic global variable that is validated.
#   * __${2}_mock_pipeable: A dynamic validated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.dynamic_validated_global_var() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean "__${2}_mock_pipeable"
  builtin return 0
}

# @description A function with a dynamic global variable that is NOT validated.
#   * __${2}_mock_rc: A dynamic unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.dynamic_unvalidated_global_var() {
  builtin return 0
}

# @description A function where validation is commented out.
#   * STDLIB_COMMENTED_VAR: A variable whose validation is commented out (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.commented_validation() {
  # stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_COMMENTED_VAR
  builtin return 0
}

# @description A function where a prefix match might occur.
#   * STDLIB_PREFIX_VAR: A variable that is a prefix of another (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.prefix_match_validation() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_PREFIX_VAR_LONGER
  builtin return 0
}

# @description A function with single quoted variable validation.
#   * STDLIB_SINGLE_QUOTED_VAR: A variable validated with single quotes (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.single_quoted_validation() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean 'STDLIB_SINGLE_QUOTED_VAR'
  builtin return 0
}
