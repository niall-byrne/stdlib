#!/bin/bash

# stdlib - reusable components for bash scripting

# shellcheck disable=SC2034
{
  STDLIB_DIRECTORY="$(dirname -- "${BASH_SOURCE[0]}")"
  STDLIB_TEXTDOMAINDIR="$(dirname -- "${STDLIB_DIRECTORY}")/locales"
}

# Check Builtin Integrity

source "${STDLIB_DIRECTORY}/security/shell/shell.snippet" || exit 1 # noqa

builtin set -eo pipefail

# Bootstrap Procedure

# @description Sources a module file.
# @arg $1 string The path to the module to import.
# @exitcode 0 If the operation succeeded.
# @internal
stdlib.__bootstrap() {
  # shellcheck source=/dev/null
  builtin source "${1}"
}

stdlib.__bootstrap "${STDLIB_DIRECTORY}/binary.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/builtin.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/gettext.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/gettext.snippet"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/message.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/setting/__lib__.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/string/colour/colour.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/logger/logger.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/string/query/__lib__.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/string/assert/__lib__.sh"
stdlib.__bootstrap "${STDLIB_DIRECTORY}/fn/__lib__.sh"

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
# source=src/var/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/__lib__.sh"
