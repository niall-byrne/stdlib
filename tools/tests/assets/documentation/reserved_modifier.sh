#!/bin/bash

# @description This function uses a reserved modifier variable.
#   * STDLIB_RESERVED_VAR string reserved: This is a reserved variable (default="").
# @arg $1 string An argument.
# @exitcode 0 If the operation succeeded.
# @stdout Success message.
stdlib.reserved_modifier_func() {
  # clean STDLIB_RESERVED_VAR
  builtin echo "Success"
}
