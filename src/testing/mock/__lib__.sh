#!/bin/bash

# stdlib testing mock object library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/arg_string.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/arg_string.sh"
# shellcheck source=src/testing/mock/attributes.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/attributes.sh"
# shellcheck source=src/testing/mock/internal/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/internal/__lib__.sh"
# shellcheck source=src/testing/mock/message.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/message.sh"
# shellcheck source=src/testing/mock/mock.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/mock.sh"
# shellcheck source=src/testing/mock/sequence.sh
builtin source "${STDLIB_DIRECTORY}/testing/mock/sequence.sh"
