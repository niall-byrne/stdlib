# @description Invalid type check.
# @arg $1 unknown An unknown type.
# @exitcode 0 If the operation succeeded.
stdlib.invalid_type() {
  builtin echo "hello"
}
