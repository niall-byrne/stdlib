#!/bin/bash

# stdlib testing mock object library

builtin set -eo pipefail

# shellcheck source=src/testing/mock/arg_string.sh
source "${STDLIB_DIRECTORY}/testing/mock/arg_string.sh"
# shellcheck source=src/testing/mock/attributes.sh
source "${STDLIB_DIRECTORY}/testing/mock/attributes.sh"
# shellcheck source=src/testing/mock/internal/__lib__.sh
source "${STDLIB_DIRECTORY}/testing/mock/internal/__lib__.sh"
# shellcheck source=src/testing/mock/message.sh
source "${STDLIB_DIRECTORY}/testing/mock/message.sh"
# shellcheck source=src/testing/mock/mock.sh
source "${STDLIB_DIRECTORY}/testing/mock/mock.sh"
# shellcheck source=src/testing/mock/sequence.sh
source "${STDLIB_DIRECTORY}/testing/mock/sequence.sh"
