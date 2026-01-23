#!/bin/bash

# stdlib testing mock internal persistence sequence library

builtin set -eo pipefail

_mock.__internal.persistence.sequence.clear() {
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=()
  _mock.__internal.persistence.sequence.update
}

_mock.__internal.persistence.sequence.initialize() {
  if [[ -z "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}" ]]; then
    __STDLIB_TESTING_MOCK_SEQUENCE_FILENAME="$("${_STDLIB_BINARY_MKTEMP}" -p "${__STDLIB_TESTING_MOCK_REGISTRY_FILENAME}")"
    _mock.__internal.persistence.sequence.update
  fi
}

_mock.__internal.persistence.sequence.retrieve() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  builtin eval "$(${_STDLIB_BINARY_CAT} "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}")"
  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY[@]}")
}

_mock.__internal.persistence.sequence.update() {
  builtin local -a __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY

  __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY=("${__STDLIB_TESTING_MOCK_SEQUENCE_ARRAY[@]}")

  builtin declare -p __STDLIB_TESTING_MOCK_SEQUENCE_ARRAY_PERSISTED_ARRAY > "${__STDLIB_TESTING_MOCK_SEQUENCE_FILENAME}"
}
