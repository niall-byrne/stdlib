#!/bin/bash

# stdlib development host script

set -eo pipefail

_host_bash_unit() {
  curl \
    --silent \
    --retry 5 \
    --retry-delay 5 \
    --fail \
    "https://raw.githubusercontent.com/bash-unit/bash_unit/master/install.sh" | bash &&
    mv bash_unit /usr/local/bin
}

_host_require_root() {
  if [[ "${EUID}" != "0" ]]; then
    echo "This command must be run as root."
    return 127
  fi
}

_host_shell() {
  script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
  export PATH="${PATH}:${script_directory}/build:${script_directory}/dist"
  bash
}

_host_main() {
  case "${1}" in
    bash_unit)
      _host_require_root
      _host_bash_unit
      ;;
    shell)
      _host_shell
      ;;
    *)
      echo "USAGE: host.sh [command]"
      echo "  Valid Commands:"
      echo "    - bash_unit           - install the bash_unit dependency to /usr/local/bin"
      echo "    - shell               - launch a shell with the 't' command for running tests"
      return 127
      ;;
  esac
}

_host_main "$@"
