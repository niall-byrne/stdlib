#!/bin/bash

# @description A derivative of stdlib.string.pad.left that can read from stdin.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string (optional, default="-") The string to pad, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @stdin The string to pad.
stdlib.string.pad.left_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

# @description A derivative of stdlib.string.pad.left that can read from and write to a variable.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
stdlib.string.pad.left_var() { :; }
stdlib.fn.derive.var "stdlib.string.pad.left"
