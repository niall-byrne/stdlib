#!/bin/bash

# stdlib testing mock internal compile library

builtin set -eo pipefail

# @description Compiles the mock generator function.
#   * STDLIB_DIRECTORY string global: The path to the stdlib library root as assigned by the build scripts (default=directory of ${BASH_SOURCE[0]}).
#   * __STDLIB_TESTING_MOCK_COMPONENT string reserved: A string containing an exported mock component for final assembly (default="").
# @noargs
# @exitcode 0 If the mock generator function was compiled successfully.
# @stdout The generated mock function definition.
# @internal
_mock.__internal.compile() {
  builtin local mock_component
  builtin local -a mock_component_file_set

  # clean STDLIB_DIRECTORY

  # KCOV_EXCLUDE_BEGIN
  mock_component_file_set=(
    "${STDLIB_DIRECTORY}/testing/mock/components/defaults.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/main.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/call.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/controller.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/getter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/setter.sh"
    "${STDLIB_DIRECTORY}/testing/mock/components/assertion.sh"
  )
  # KCOV_EXCLUDE_END

  # shellcheck disable=SC1090
  builtin source <({
    builtin echo "_mock.__generate_mock() {"
    builtin echo "  _mock.__internal.persistence.registry.add_mock \"\${1}\" \"\${2}\""
    builtin echo "builtin eval \"\$(\"${_STDLIB_BINARY_CAT}\" <<EOF"

    for mock_component in "${mock_component_file_set[@]}"; do
      builtin echo -e "\n\n# === component start =========================="
      builtin source "${mock_component}" # defaults __STDLIB_TESTING_MOCK_COMPONENT
      builtin echo "${__STDLIB_TESTING_MOCK_COMPONENT}"
      builtin unset __STDLIB_TESTING_MOCK_COMPONENT
      builtin echo -e "# === component end ============================\n\n"
    done

    builtin echo "EOF"
    builtin echo ")\""
    builtin echo "}"
  })
}
