#!/bin/bash

# stdlib testing mock internal persistence sequence library

builtin set -eo pipefail

_mock.__internal.persistence.sequence.clear() {
  __MOCK_SEQUENCE=()
  _mock.__internal.persistence.sequence.update
}

_mock.__internal.persistence.sequence.initialize() {
  if [[ -z "${__MOCK_SEQUENCE_PERSISTENCE_FILE}" ]]; then
    __MOCK_SEQUENCE_PERSISTENCE_FILE="$("${_STDLIB_BINARY_MKTEMP}" -p "${__MOCK_REGISTRY}")"
    _mock.__internal.persistence.sequence.update
  fi
}

_mock.__internal.persistence.sequence.retrieve() {
  builtin local -a __MOCK_SEQUENCE_PERSISTED_ARRAY

  builtin eval "$(${_STDLIB_BINARY_CAT} "${__MOCK_SEQUENCE_PERSISTENCE_FILE}")"
  __MOCK_SEQUENCE=("${__MOCK_SEQUENCE_PERSISTED_ARRAY[@]}")
}

_mock.__internal.persistence.sequence.update() {
  builtin local -a __MOCK_SEQUENCE_PERSISTED_ARRAY

  __MOCK_SEQUENCE_PERSISTED_ARRAY=("${__MOCK_SEQUENCE[@]}")

  builtin declare -p __MOCK_SEQUENCE_PERSISTED_ARRAY > "${__MOCK_SEQUENCE_PERSISTENCE_FILE}"
}
