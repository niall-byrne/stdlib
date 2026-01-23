# @description Missing stderr and stdout tags.
# @arg $1 string An argument.
# @exitcode 0 If the operation succeeded.
stdlib.missing_outputs() {
  builtin echo "stdout"
  builtin echo "stderr" >&2
}
