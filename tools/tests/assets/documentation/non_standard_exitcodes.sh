#!/bin/bash

# @description Non standard exit codes.
# @arg $1 string An argument.
# @exitcode 0 If the operation succeeded.
# @exitcode 123 Invalid 123.
# @exitcode 124 Invalid 124.
# @exitcode 125 Invalid 125.
# @exitcode 126 Wrong message.
# @exitcode 127 Also wrong.
stdlib.non_standard_exitcodes() {
  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  return 126
}
