#!/bin/bash

# stdlib documentation build script

set -eo pipefail

DOCS_BUILD_FILE_PATH=()
DOCS_BUILD_SUBSTITUTION_FOR_ONE=""
DOCS_BUILD_SUBSTITUTION_FOR_TWO=""

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts.
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation is successful.
# @internal
docs.build.__generic_reference() {
  builtin local filepath
  builtin local -a filepaths
  builtin local markdown_file_path="${1}"
  builtin local markdown_file_header="${2}"

  builtin shift 2

  while IFS= builtin read -r filepath; do
    filepaths+=("${filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${markdown_file_header}\n" > "${markdown_file_path}" # noqa

  shdoc <(for filepath in "${filepaths[@]}"; do
    "${_STDLIB_BINARY_CAT}" "${filepath}"
  done) >> "${markdown_file_path}"

  truncate -s -1 "${markdown_file_path}"
}

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts inside a here-doc.
#   * DOCS_BUILD_FILE_PATH: A pre-populated array of file paths that can be added to final reference (default=()).
#   * DOCS_BUILD_SUBSTITUTION_FOR_ONE: A value to substitute for $1 references in the here-docs (default="1").
#   * DOCS_BUILD_SUBSTITUTION_FOR_TWO: A value to substitute for $1 references in the here-docs (default="2").
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $3 string The variable the heredoc is stored in when the shell script is sourced.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation is successful.
# @internal
docs.build.__generic_reference_from_here_doc() {
  builtin local component_var_name="${3}"
  builtin local filepath
  builtin local -a filepaths
  builtin local markdown_file_path="${1}"
  builtin local markdown_file_header="${2}"
  builtin local substitution_for_1="${DOCS_BUILD_SUBSTITUTION_FOR_ONE-"1"}"
  builtin local substitution_for_2="${DOCS_BUILD_SUBSTITUTION_FOR_TWO-"2"}"

  builtin shift 3

  filepaths+=("${DOCS_BUILD_FILE_PATH[@]}")

  while IFS= builtin read -r filepath; do
    filepaths+=("${filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${markdown_file_header}\n" > "${markdown_file_path}" # noqa

  shdoc <(for filepath in "${filepaths[@]}"; do
    # shellcheck source=/dev/null
    builtin source "${filepath}"

    builtin echo -e "\n${!component_var_name}\n" | # noqa
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${1}\|^\${1}/${substitution_for_1}/g" |
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${2}\|^\${2}/${substitution_for_2}/g" |
      "${_STDLIB_BINARY_SED}" "s/\\$\(.\)/$\1/g"
  done) >> "${markdown_file_path}"

  truncate -s -1 "${markdown_file_path}"
}

# @description Builds the central stdlib reference file.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.build.stdlib_reference() {
  local markdown_file_header

  markdown_file_header="$(
    "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB Function Reference

<!-- markdownlint-disable MD024 -->

EOF
  )"

  docs.build.__generic_reference \
    "REFERENCE.md" \
    "${markdown_file_header}" \
    src \
    '(' -iname '*.sh' -o -iname '*.snippet' ')' \
    -not -ipath 'src/testing/*.sh'
}

# @description Builds the central stdlib testing reference files.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.build.stdlib_testing_reference() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE_TESTING.md"
  builtin local -a testing_folders
  builtin local testing_folder
  builtin local -a testing_topics
  builtin local testing_topic
  builtin local -a testing_folder_depths
  builtin local testing_folder_depth

  "${_STDLIB_BINARY_CAT}" << EOF > "${markdown_index_file_path}"
# STDLIB Testing Function References

<!-- markdownlint-disable MD024 -->

EOF

  testing_folders=("assertion" "capture" "fixtures" "." "mock" "parametrize")
  testing_folder_depths=("100" "100" "100" "1" "100" "100")
  testing_topics=("Testing Assertion" "Testing Capture" "Testing Fixture" "Testing Generic" "Testing Mock" "Testing Parametrization")

  for ((index = 0; index < "${#testing_folders[@]}"; index++)); do
    testing_folder="${testing_folders[index]}"
    testing_topic="${testing_topics[index]}"
    testing_folder_depth="${testing_folder_depths[index]}"

    markdown_file_header="$(
      "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB ${testing_topic} Function Reference

<!-- markdownlint-disable MD024 -->

EOF
    )"
    docs.build.__generic_reference \
      "src/testing/${testing_folder}/REFERENCE.md" \
      "${markdown_file_header}" \
      "src/testing/${testing_folder}" \
      -maxdepth "${testing_folder_depth}" \
      '(' -iname '*.sh' -o -iname '*.snippet' ')'

    if [[ "${testing_folder}" == "mock" ]]; then
      echo "* [Mock Object Reference](src/testing/${testing_folder}/REFERENCE_MOCK_OBJECT.md)" >> "${markdown_index_file_path}"
    fi
    echo "* [${testing_topic/Testing /} Function Reference](src/testing/${testing_folder}/REFERENCE.md)" >> "${markdown_index_file_path}"
  done
}

# @description Builds the stdlib testing mock object reference file.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.build.stdlib_testing_mock_object_reference() {
  builtin local -a DOCS_BUILD_FILE_PATH
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_ONE="object"
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_TWO="object"
  builtin local markdown_file_header

  DOCS_BUILD_FILE_PATH=("src/testing/mock/components/main.sh")

  markdown_file_header="$(
    "${_STDLIB_BINARY_CAT}" << 'EOF'
# STDLIB Testing Mock Object Reference

<!-- markdownlint-disable MD024 -->

This reference uses the fictional example of a mock created with `_mock.create object`.

EOF
  )"

  docs.build.__generic_reference_from_here_doc \
    "src/testing/mock/REFERENCE_MOCK_OBJECT.md" \
    "${markdown_file_header}" \
    "__STDLIB_TESTING_MOCK_COMPONENT" \
    src/testing/mock/components \
    -iname '*.sh' \
    -not -ipath 'src/testing/mock/components/main.sh'
}

# @description Builds all stdlib function references.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.main() {
  builtin source "src/binary.sh"

  docs.build.stdlib_reference
  docs.build.stdlib_testing_reference
  docs.build.stdlib_testing_mock_object_reference
}

docs.main "${@}"
