#!/bin/bash

# stdlib testing mock internal persistence registry library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_REGISTRY_FILENAME=""
__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES=()
__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""

# @description Adds a new mock to the registry and creates temporary files for it.
# @arg $1 string The name of the mock.
# @arg $2 string The sanitized name of the mock.
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.registry.add_mock() {
  __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES+=("${1}")
  builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
  builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
}

# @description Applies a command to all registered mocks.
# @arg $1 string The command to apply (e.g., 'clear', 'reset').
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.registry.apply_to_all() {
  builtin local mock_instance

  for mock_instance in "${__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

# @description Cleans up the mock registry and removes temporary files.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.registry.cleanup() {
  if [[ -n "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
    "${_STDLIB_BINARY_RM}" -rf "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}"
  fi
}

# @description Creates a new temporary directory for the mock registry.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
_mock.__internal.persistence.registry.create() {
  if [[ -z "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
    __STDLIB_TESTING_MOCK_REGISTRY_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -d)"
  fi
}
