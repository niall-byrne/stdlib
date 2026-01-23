#!/bin/bash

# stdlib io path query is library

builtin set -eo pipefail

# @description Checks if a path exists.
# @arg $1 string The path to check.
# @exitcode 0 If the path exists.
# @exitcode 1 If the path does not exist.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.io.path.query.is_exists() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  stdlib.builtin.overridable test -e "${1}" || builtin return 1
}

# @description Checks if a path is a file.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a file.
# @exitcode 1 If the path is not a file.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.io.path.query.is_file() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  stdlib.builtin.overridable test -f "${1}" || builtin return 1
}

# @description Checks if a path is a folder.
# @arg $1 string The path to check.
# @exitcode 0 If the path is a folder.
# @exitcode 1 If the path is not a folder.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.io.path.query.is_folder() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126
  stdlib.builtin.overridable test -d "${1}" || builtin return 1
}
