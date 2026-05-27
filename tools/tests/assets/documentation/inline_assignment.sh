#!/bin/bash

# @description This function uses an inline global variable assignment.
# @noargs
# @exitcode 0 If the operation succeeded.
stdlib.inline_assignment_usage() {
  STDLIB_KW_SOURCE_VAR="lock_permissions" stdlib.fn.keyword.assert.is_valid_with stdlib.string.assert.is_octal_permission STDLIB_LOCK_PERMISSION_OCTAL || builtin return 125
}
