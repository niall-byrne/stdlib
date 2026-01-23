#!/bin/bash

# stdlib testing mock internal persistence registry library

builtin set -eo pipefail

__STDLIB_TESTING_MOCK_REGISTRY_FILENAME=""
__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY=()
__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME=""

_mock.__internal.persistence.registry.add_mock() {
  # $1: the name of the mock being added to the registry
  # $2: the sanitized name of the mock being added to the registry

  __STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY+=("${1}")
  builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
  builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
}

_mock.__internal.persistence.registry.apply_to_all() {
  # $1: the command to execute on all registered mocks

  builtin local mock_instance

  for mock_instance in "${__STDLIB_TESTING_MOCK_REGISTERED_INSTANCES_ARRAY[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

_mock.__internal.persistence.registry.cleanup() {
  if [[ -n "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
    "${_STDLIB_BINARY_RM}" -rf "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}"
  fi
}

_mock.__internal.persistence.registry.create() {
  if [[ -z "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}" ]]; then
    __STDLIB_TESTING_MOCK_REGISTRY_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -d)"
  fi
}
