#!/bin/bash

# stdlib - reusable components for bash scripting

builtin set -eo pipefail

# shellcheck disable=SC2034
STDLIB_DIRECTORY="$(builtin cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && builtin pwd)"

# Bootstrap Procedure

bootstrap() {
  # $1: the module to import

  # shellcheck source=/dev/null
  builtin source "${1}"
}

bootstrap "${STDLIB_DIRECTORY}/message.sh"
bootstrap "${STDLIB_DIRECTORY}/binary.sh"
bootstrap "${STDLIB_DIRECTORY}/setting/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/builtin.sh"
bootstrap "${STDLIB_DIRECTORY}/string/colour/colour.sh"
bootstrap "${STDLIB_DIRECTORY}/logger/logger.sh"
bootstrap "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
bootstrap "${STDLIB_DIRECTORY}/fn/__lib__.sh"

# source=src/array/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/array/__lib__.sh"
# source=src/fn/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/fn/__lib__.sh"
# source=src/io/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/io/__lib__.sh"
# source=src/logger/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/logger/__lib__.sh"
# source=src/security/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/__lib__.sh"
# source=src/string/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/string/__lib__.sh"
# source=src/trap/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/trap/__lib__.sh"
