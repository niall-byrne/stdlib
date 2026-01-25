#!/bin/bash

# @description This is a valid function.
# @arg $1 string A string argument.
# @exitcode 0 If the operation succeeded.
# @stdout The message "hello".
stdlib.valid() {
  builtin echo "hello"
}
