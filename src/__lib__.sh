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

# Bootstrap

# source=src/binary.sh
builtin source "${STDLIB_DIRECTORY}/binary.sh"
# source=src/deferred.sh
builtin source "${STDLIB_DIRECTORY}/deferred.sh"

stdlib.deferred.__initialize

# source=src/array/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/array/__lib__.sh"
# source=src/builtin.sh
builtin source "${STDLIB_DIRECTORY}/builtin.sh"
# source=src/gettext.sh
builtin source "${STDLIB_DIRECTORY}/gettext.sh"
# source=src/io/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/io/__lib__.sh"
# source=src/logger/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/logger/__lib__.sh"
# source=src/message.sh
builtin source "${STDLIB_DIRECTORY}/message.sh"
# source=src/security/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/security/__lib__.sh"
# source=src/setting/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/setting/__lib__.sh"
# source=src/string/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/string/__lib__.sh"
# source=src/trap/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/trap/__lib__.sh"
# source=src/var/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/var/__lib__.sh"

# Source the deferred functions last

# source=src/fn/__lib__.sh
builtin source "${STDLIB_DIRECTORY}/fn/__lib__.sh"
# source=src/gettext.snippet

# Source the required snippets

# source=src/gettext.snippet.sh
builtin source "${STDLIB_DIRECTORY}/gettext.snippet"
# source=src/trap/register.snippet.sh
builtin source "${STDLIB_DIRECTORY}/trap/register.snippet"

stdlib.deferred.__execute
