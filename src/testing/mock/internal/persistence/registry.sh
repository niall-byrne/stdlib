#!/bin/bash

# stdlib testing mock internal persistence registry library

builtin set -eo pipefail

__MOCK_REGISTRY=""
__MOCK_INSTANCES=()
__MOCK_SEQUENCE_PERSISTENCE_FILE=""

_mock.__internal.persistence.registry.add_mock() {
  # $1: the name of the mock being added to the registry
  # $2: the sanitized name of the mock being added to the registry

  __MOCK_INSTANCES+=("${1}")
  builtin printf -v "__${2}_mock_calls_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
  builtin printf -v "__${2}_mock_side_effects_file" "%s" "$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
}

_mock.__internal.persistence.registry.apply_to_all() {
  # $1: the command to execute on all registered mocks

  builtin local mock_instance

  for mock_instance in "${__MOCK_INSTANCES[@]}"; do
    "${mock_instance}".mock."${1}"
  done
}

_mock.__internal.persistence.registry.cleanup() {
  if [[ -n "${__MOCK_REGISTRY}" ]]; then
    "${_STDLIB_BINARY_RM}" -rf "${__MOCK_REGISTRY}"
  fi
}

_mock.__internal.persistence.registry.create() {
  if [[ -z "${__MOCK_REGISTRY}" ]]; then
    __MOCK_REGISTRY="$("${_STDLIB_BINARY_MKTEMP}" -d)"
  fi
}
