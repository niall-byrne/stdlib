#!/bin/bash

# stdlib development test runner
# $@: arguments to pass to the distributable test runner

set -eo pipefail

# shellcheck disable=SC2154
_t_runner_custom_execution_context() {
  # shellcheck source=src/__lib__.sh
  source "${_t_runner_working_directory}/../src/__lib__.sh"
  # shellcheck source=src/trap/register.snippet
  source "${_t_runner_working_directory}/../src/trap/register.snippet"
  # shellcheck source=src/testing/__lib__.sh
  source "${_t_runner_working_directory}/../src/testing/__lib__.sh"
  # shellcheck source=src/testing/mock/mock.snippet
  source "${_t_runner_working_directory}/../src/testing/mock/mock.snippet"

  stdlib.trap.handler.exit.fn.register __mock.persistence.registry.cleanup

  _t_runner_execute "$@"

  exit "${_t_runner_exit_code}"
}

export -f _t_runner_custom_execution_context
t "$@"
