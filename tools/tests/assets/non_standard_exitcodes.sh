# @description Non standard exit codes.
# @arg $1 string An argument.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 Wrong message.
# @exitcode 127 Also wrong.
stdlib.non_standard_exitcodes() {
  stdlib.fn.args.require "1" "0" "${@}" || builtin return "$?"
  return 126
}
