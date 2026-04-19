#!/bin/bash

# stdlib distribution test runner
# $@: arguments to pass to the distributable test runner

set -eo pipefail

_t_runner_working_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# shellcheck disable=SC2154
_t_runner_custom_execution_context() {
  # shellcheck source=/dev/null
  source "${_t_runner_working_directory}/../dist/stdlib.sh"
  # shellcheck source=/dev/null
  source "${_t_runner_working_directory}/../dist/stdlib_testing.sh"

  # shellcheck source=/dev/null
  __STDLIB_SECURE_DISTRIBUTION=0 \
    source "${_t_runner_working_directory}/../src/builtin.sh"

  _t_runner_execute "$@"
}

export -f _t_runner_custom_execution_context

if [[ "${#@}" -eq 0 ]]; then
  set -- "${@}" "src"
fi

"${_t_runner_working_directory}/../dist/t" "$@"
