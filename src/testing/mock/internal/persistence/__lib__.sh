#!/bin/bash

# stdlib testing mock internal persistence library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/internal/persistence/registry.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence/registry.sh"
# shellcheck source=src/testing/mock/internal/persistence/sequence.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/persistence/sequence.sh"
