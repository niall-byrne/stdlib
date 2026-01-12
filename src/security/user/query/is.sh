#!/bin/bash

# stdlib security query user library

builtin set -eo pipefail

stdlib.security.user.query.is_root() {

  [[ "${#@}" == "0" ]] || builtin return 127

  if [[ "$(stdlib.security.get.euid)" != "0" ]]; then
    builtin return 1
  fi
}
