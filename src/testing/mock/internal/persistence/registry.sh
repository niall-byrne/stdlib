#!/bin/bash

# stdlib testing mock internal persistence registry library

builtin set -eo pipefail

# @description Adds a mock to the registry and creates its persistence files.
#   * __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY array reserved: A list of mock functions that have been created (default=()).
#   * __STDLIB_TESTING_MOCK_REGISTRY_FOLDER string reserved: The folder where mock related tracking data is stored during test execution (default="").
# @arg $1 string The name of the mock being added.
# @arg $2 string The sanitized name of the mock being added.
# @exitcode 0 If the mock was added to the registry.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @internal
_mock.__internal.persistence.registry.add_mock() {
  builtin local mock_name="${2}"

  _testing.__protected stdlib.var.reserved.assert.__is_valid_with "$(_testing.__protected_name stdlib.array.assert.is_array)" __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY name || builtin return 123 # validates __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY
  _testing.__protected stdlib.var.reserved.assert.__is_valid_with "$(_testing.__protected_name stdlib.io.path.assert.is_folder)" __STDLIB_TESTING_MOCK_REGISTRY_FOLDER || builtin return 123              # validates __STDLIB_TESTING_MOCK_REGISTRY_FOLDER

  __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY+=("${1}")

  builtin printf -v "__${mock_name}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}")"
  builtin printf -v "__${mock_name}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}")"
}

# @description Applies a command to all registered mock instances.
#   * __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY array reserved: A list of mock functions that have been created (default=()).
# @arg $1 string The command to execute (e.g., "clear" or "reset").
# @exitcode 0 If the command was applied to all mocks.
# @exitcode 123 If a variable reserved for use by the BASH stdlib has been assigned an invalid value.
# @internal
_mock.__internal.persistence.registry.apply_to_all() {
  builtin local mock_instance

  _testing.__protected stdlib.var.reserved.assert.__is_valid_with "$(_testing.__protected_name stdlib.array.assert.is_array)" __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY name || builtin return 123 # validates __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY

  for mock_instance in "${__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

# @description Cleans up the mock registry and its persistence files.
#   * __STDLIB_TESTING_MOCK_REGISTRY_FOLDER string reserved: The folder where mock related tracking data is stored during test execution (default="").
# @noargs
# @exitcode 0 If the mock registry was cleaned up.
# @internal
_mock.__internal.persistence.registry.cleanup() {
  if _testing.__protected stdlib.io.path.query.is_folder "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}"; then # validates __STDLIB_TESTING_MOCK_REGISTRY_FOLDER
    "${_STDLIB_BINARY_RM}" -rf "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}"
  fi
}

# @description Creates the mock registry directory if it does not exist.
#   * __STDLIB_TESTING_MOCK_REGISTRY_FOLDER string reserved: The folder where mock related tracking data is stored during test execution (default="").
# @noargs
# @exitcode 0 If the mock registry directory was created.
# @internal
_mock.__internal.persistence.registry.create() {
  if ! _testing.__protected stdlib.io.path.query.is_folder "${__STDLIB_TESTING_MOCK_REGISTRY_FOLDER}"; then # validates __STDLIB_TESTING_MOCK_REGISTRY_FOLDER
    __STDLIB_TESTING_MOCK_REGISTRY_FOLDER="$("${_STDLIB_BINARY_MKTEMP}" -d)"
  fi
}
