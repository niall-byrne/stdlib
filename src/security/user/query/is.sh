#!/bin/bash

# stdlib security query user library

builtin set -eo pipefail

# @description Checks if the current user is root.
# @noargs
# @exitcode 0 If the user is root.
# @exitcode 1 If the user is not root.
# @exitcode 127 If the wrong number of arguments were provided.
stdlib.security.user.query.is_root() {
  [[ "${#@}" == "0" ]] || builtin return 127

  if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
    builtin return 1
  fi
}
