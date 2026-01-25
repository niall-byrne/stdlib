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
#   * _INVALID_GLOBAL_VARIABLE This variable is not formatted correctly.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_colon() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE: this variable is not formatted correctly (default=1).
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_capital() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE: This variable is not formatted correctly (default=1)
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_period() {
  builtin echo "hello"
}

# @description This description has an improperly formatted global variable.
#   * _INVALID_GLOBAL_VARIABLE: This variable is not formatted correctly.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout A greeting message.
stdlib.invalid_description_no_global_variable_default() {
  builtin echo "hello"
}
