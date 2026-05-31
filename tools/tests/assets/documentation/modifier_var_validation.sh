#!/bin/bash

# @description A function with no modifier variables.
# @noargs
# @exitcode 0 If successful.
stdlib.no_modifier_vars() {
  builtin return 0
}

# @description A function with a validated modifier variable.
#   * STDLIB_VALIDATED_VAR global boolean: A validated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.validated_modifier_var() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_VALIDATED_VAR # validates STDLIB_VALIDATED_VAR
  builtin return 0
}

# @description A function with a manually validated modifier variable.
#   * STDLIB_VALIDATED_VAR global string: A validated variable (default="").
# @noargs
# @exitcode 0 If successful.
stdlib.manually_validated_modifier_var() {
  # shellcheck disable=SC2034
  local value_with_default="${STDLIB_VALIDATED_VAR:-a}"

  stdlib.var.assert.is_valid_with stdlib.string.assert.is_char value_with_default # defaults STDLIB_VALIDATED_VAR
  builtin return 0
}

# @description A function with a manually validated modifier variable.
#   * STDLIB_VALIDATED_VAR1 global string: A validated variable (default="").
#   * STDLIB_VALIDATED_VAR2 global string: A validated variable (default="").
# @noargs
# @exitcode 0 If successful.
# shellcheck disable=SC2034
stdlib.manually_validated_modifier_var_multiple() {
  local value_with_default1="${STDLIB_VALIDATED_VAR1:-a}"
  local value_with_default2="${STDLIB_VALIDATED_VAR2:-a}"

  validation_function value_with_default1 value_with_default2 # validates STDLIB_VALIDATED_VAR1,STDLIB_VALIDATED_VAR2
  builtin return 0
}

# @description A function with an unvalidated modifier variable.
#   * STDLIB_UNVALIDATED_VAR global boolean: An unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.unvalidated_modifier_var() {
  builtin return 0
}

# @description A function with multiple modifier variables, one unvalidated.
#   * STDLIB_VALID_VAR global boolean: A validated variable (default=0).
#   * STDLIB_INVALID_VAR global boolean: An unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.multiple_modifier_vars() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_VALID_VAR # validates STDLIB_VALID_VAR
  builtin return 0
}

# @description A function with a dynamic modifier variable that is validated.
#   * __${2}_mock_pipeable global boolean: A dynamic validated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.dynamic_validated_modifier_var() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean "__${2}_mock_pipeable" # validates __${2}_mock_pipeable
  builtin return 0
}

# @description A function with a dynamic modifier variable that is NOT validated.
#   * __${2}_mock_rc global boolean: A dynamic unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.dynamic_unvalidated_modifier_var() {
  builtin return 0
}

# @description A function where validation is commented out.
#   * STDLIB_COMMENTED_VAR global boolean: A variable whose validation is commented out (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.commented_validation() {
  # stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_COMMENTED_VAR
  builtin return 0
}

# @description A function where a prefix match might occur.
#   * STDLIB_PREFIX_VAR global boolean: A variable that is a prefix of another (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.prefix_match_validation() {
  stdlib.var.assert.is_valid_with stdlib.string.assert.is_boolean STDLIB_PREFIX_VAR_LONGER
  builtin return 0
}

# @description An internal function with unvalidated modifier variable.
#   * STDLIB_INTERNAL_UNVALIDATED_VAR global boolean: An unvalidated variable (default=0).
# @noargs
# @exitcode 0 If successful.
# @internal
stdlib.__internal_unvalidated_var() {
  builtin return 0
}

# @description An function with a modifier variable marked as already clean.
#   * STDLIB_CLEANED_VAR global boolean: An variable that has already been validated elsewhere (default=0).
# @noargs
# @exitcode 0 If successful.
stdlib.already_clean() {
  # clean STDLIB_CLEANED_VAR
  builtin return 0
}
