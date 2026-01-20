#!/bin/bash

# stdlib distributable packaging script

set -eo pipefail

# shellcheck disable=SC2034
{
  STDLIB_DIRECTORY="$(cd -- "$(dirname "$(dirname -- "${BASH_SOURCE[0]}")")" &> /dev/null && pwd)/src"
}

STDLIB_RELEASE="dist/stdlib.sh"
STDLIB_TESTING_RELEASE="dist/stdlib_testing.sh"

__package_build_stdlib() {
  bash build/build.sh stdlib | sed 's/ $//g' > "${STDLIB_RELEASE}"
}

__package_build_stdlib_testing() {
  bash build/build.sh testing | sed 's/ $//g' > "${STDLIB_TESTING_RELEASE}"
}

__package_test_stdlib() {
  # shellcheck source=/dev/null
  source "${STDLIB_RELEASE}"

  _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1" stdlib.setting.colour.enable
  stdlib.logger.success "The stdlib library was successfully packaged."
}

__package_test_stdlib_testing() {
  # shellcheck source=/dev/null
  source "${STDLIB_RELEASE}"
  # shellcheck source=/dev/null
  source "${STDLIB_TESTING_RELEASE}"

  _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1" stdlib.setting.colour.enable
  stdlib.logger.success "The stdlib testing library was successfully packaged."
}

__package_translate() {
  rm -rf dist/locales
  cp -rp locales dist
  find dist/locales '(' -iname '*.po' -o -iname '*.pot' ')' -delete

  # shellcheck source=/dev/null
  source "${STDLIB_RELEASE}"

  _STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN="1" stdlib.setting.colour.enable
  stdlib.logger.success "The translations were successfully packaged."
}

__package_main() {
  __package_build_stdlib
  __package_build_stdlib_testing

  __package_test_stdlib
  __package_test_stdlib_testing

  __package_translate
}

__package_main
