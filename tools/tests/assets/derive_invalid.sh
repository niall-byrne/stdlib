#!/bin/bash

# @description Wrong description.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string (optional, default="-") The string to pad.
stdlib.string.pad.left_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"

# @description A derivative of stdlib.string.pad.left that can read from and write to a variable.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string Wrong arg description.
stdlib.string.pad.left_var() { :; }
stdlib.fn.derive.var "stdlib.string.pad.left"

# Missing stub
stdlib.fn.derive.pipeable "stdlib.string.pad.right" "2"

# Wrong name stub
# @description A derivative of stdlib.string.pad.right that can read from and write to a variable.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string The name of the variable to read from and write to.
wrong_name_var() { :; }
stdlib.fn.derive.var "stdlib.string.pad.right"

# Missing @stdin
# @description A derivative of stdlib.string.pad.left that can read from stdin.
# @arg $1 integer The number of spaces to pad with.
# @arg $2 string (optional, default="-") The string to pad, by default this function reads from stdin.
stdlib.string.pad.left_pipe_no_stdin() { :; }
stdlib.fn.derive.pipeable "stdlib.string.pad.left" "2"
