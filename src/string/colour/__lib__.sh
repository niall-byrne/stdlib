#!/bin/bash

# stdlib string colour library

builtin set -eo pipefail

# shellcheck source=src/string/colour/colour.sh
builtin source "${STDLIB_DIRECTORY}/string/colour/colour.sh"
# shellcheck source=src/string/colour/substring.sh
builtin source "${STDLIB_DIRECTORY}/string/colour/substring.sh"

# @description A derivative of stdlib.string.colour_n that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string (optional, default="-") The string to colour, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to colour.
# @stdout The coloured string without a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_n_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour_n" "2"

# @description A derivative of stdlib.string.colour_n that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour_n" "stdlib.string.colour_var"

# @description A derivative of stdlib.string.colour that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string (optional, default="-") The string to colour, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to colour.
# @stdout The coloured string with a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour" "2"

# @description A derivative of stdlib.string.colour.substring that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string (optional, default="-") The source string, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The source string.
# @stdout The string with the first occurrence of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substring_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour.substring" "3"

# @description A derivative of stdlib.string.colour.substring that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour.substring_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour.substring"

# @description A derivative of stdlib.string.colour.substrings that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string (optional, default="-") The source string, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The source string.
# @stdout The string with all occurrences of the substring coloured.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour.substrings" "3"

# @description A derivative of stdlib.string.colour.substrings that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The substring to colour.
# @arg $3 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour.substrings_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour.substrings"
