#!/bin/bash

# @description This description has an improperly formatted global variable.
#     _INVALID_GLOBAL_VARIABLE: This variable is not formatted correctly.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_list() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE string keyword This variable is not formatted correctly.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_colon() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE string keyword: this variable is not formatted correctly (default=1).
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_capital() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE string keyword: This variable is not formatted correctly (default=1)
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_period() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE string keyword: This variable is not formatted correctly.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_default() {
  builtin echo "hello"
}

# @description This description has a global variable with an invalid type.
#   * _INVALID_TYPE_GLOBAL_VARIABLE invalid_type keyword: This variable has an invalid type (default=1).
# @noargs
# @exitcode 0 If successful.
stdlib.invalid_variable_type() {
  builtin return 0
}

# @description This description has a global variable with an invalid modifier.
#   * _INVALID_MODIFIER_GLOBAL_VARIABLE string invalid_modifier: This variable has an invalid modifier (default="").
# @noargs
# @exitcode 0 If successful.
stdlib.invalid_modifier_type() {
  builtin return 0
}
