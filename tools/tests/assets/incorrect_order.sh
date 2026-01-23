# @arg $1 string A string argument.
# @description This is out of order.
# @exitcode 0 If the operation succeeded.
stdlib.incorrect_order() {
  builtin echo "hello"
}
