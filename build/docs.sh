#!/bin/bash

# stdlib documentation build script

set -eo pipefail

DOCS_BUILD_FILE_PATH_ARRAY=()
DOCS_BUILD_SUBSTITUTION_FOR_ONE=""
DOCS_BUILD_SUBSTITUTION_FOR_TWO=""

DOCS_STDLIB_FOLDERS_ARRAY=("array" "fn" "io" "logger" "security" "setting" "string" "trap" "var")
DOCS_STDLIB_TOPICS_ARRAY=("Array" "FN" "IO" "Logger" "Security" "Setting" "String" "Trap" "Variable")

DOCS_STDLIB_TESTING_FOLDERS_ARRAY=("assertion" "capture" "fixtures" "." "mock" "parametrize")
DOCS_STDLIB_TESTING_TOPICS_ARRAY=("Testing Assertion" "Testing Capture" "Testing Fixture" "Testing Generic" "Testing Mock" "Testing Parametrization")

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts.
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.__generic_reference() {
  builtin local filepath
  builtin local -a filepath_array
  builtin local markdown_file_path="${1}"
  builtin local markdown_file_header="${2}"

  builtin shift 2

  while IFS= builtin read -r filepath; do
    filepath_array+=("${filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${markdown_file_header}\n" > "${markdown_file_path}" # noqa

  shdoc <(for filepath in "${filepath_array[@]}"; do
    "${_STDLIB_BINARY_CAT}" "${filepath}"
  done) >> "${markdown_file_path}"

  truncate -s -1 "${markdown_file_path}"
}

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts inside a here-doc.
#   * DOCS_BUILD_FILE_PATH_ARRAY: A pre-populated array of file paths that can be added to final reference (default=()).
#   * DOCS_BUILD_SUBSTITUTION_FOR_ONE: A value to substitute for $1 references in the here-docs (default="1").
#   * DOCS_BUILD_SUBSTITUTION_FOR_TWO: A value to substitute for $1 references in the here-docs (default="2").
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $3 string The variable the heredoc is stored in when the shell script is sourced.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.__generic_reference_from_here_doc() {
  builtin local component_var_name="${3}"
  builtin local filepath
  builtin local -a filepath_array
  builtin local markdown_file_path="${1}"
  builtin local markdown_file_header="${2}"
  builtin local substitution_for_1="${DOCS_BUILD_SUBSTITUTION_FOR_ONE-"1"}"
  builtin local substitution_for_2="${DOCS_BUILD_SUBSTITUTION_FOR_TWO-"2"}"

  builtin shift 3

  filepath_array+=("${DOCS_BUILD_FILE_PATH_ARRAY[@]}")

  while IFS= builtin read -r filepath; do
    filepath_array+=("${filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${markdown_file_header}\n" > "${markdown_file_path}" # noqa

  shdoc <(for filepath in "${filepath_array[@]}"; do
    # shellcheck source=/dev/null
    builtin source "${filepath}"

    builtin echo -e "\n${!component_var_name}\n" | # noqa
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${1}\|^\${1}/${substitution_for_1}/g" |
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${2}\|^\${2}/${substitution_for_2}/g" |
      "${_STDLIB_BINARY_SED}" "s/\\$\(.\)/$\1/g"
  done) >> "${markdown_file_path}"

  truncate -s -1 "${markdown_file_path}"
}

# @description Builds the stdlib reference files.
#   * DOCS_STDLIB_FOLDERS_ARRAY: The folders to include in the stdlib reference.
#   * DOCS_STDLIB_TOPICS_ARRAY: The topics associated with each folder in the stdlib reference.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_reference() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE.md"
  builtin local -a target_folder_array
  builtin local target_folder
  builtin local target_markdown_file_path
  builtin local target_topic
  builtin local -a target_topic_array

  "${_STDLIB_BINARY_CAT}" << EOF > "${markdown_index_file_path}"
# STDLIB Function References

<!-- markdownlint-disable MD024 -->

EOF

  target_folder_array=("${DOCS_STDLIB_FOLDERS_ARRAY[@]}")
  target_topic_array=("${DOCS_STDLIB_TOPICS_ARRAY[@]}")

  for ((index = 0; index < "${#target_folder_array[@]}"; index++)); do
    target_folder="${target_folder_array[index]}"
    target_topic="${target_topic_array[index]}"

    target_markdown_file_path="src/${target_folder}/REFERENCE.md"
    target_markdown_file_path="${target_markdown_file_path/"/."/}"

    markdown_file_header="$(
      "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB ${target_topic} Function Reference

<!-- markdownlint-disable MD024 -->

EOF
    )"
    docs.build.__generic_reference \
      "${target_markdown_file_path}" \
      "${markdown_file_header}" \
      "src/${target_folder}" \
      '(' -iname '*.sh' -o -iname '*.snippet' ')'

    if [[ "${index}" -eq 0 ]]; then
      builtin echo "* [Complete Function Reference](src/REFERENCE_COMPLETE.md)" >> "${markdown_index_file_path}"
      builtin echo "---" >> "${markdown_index_file_path}"
    fi

    builtin echo "* [${target_topic} Function Reference](${target_markdown_file_path})" >> "${markdown_index_file_path}"
  done
}

# @description Builds the complete stdlib function reference file.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_reference_complete() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE_COMPLETE.md"
  builtin local target_markdown_file_path

  target_markdown_file_path="src/${markdown_index_file_path}"

  markdown_file_header="$(
    "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB Complete Function Reference

<!-- markdownlint-disable MD024 -->

EOF
  )"
  docs.build.__generic_reference \
    "${target_markdown_file_path}" \
    "${markdown_file_header}" \
    "src" \
    '(' -iname '*.sh' -o -iname '*.snippet' ')' \
    -not -ipath "src/testing/*.sh" \
    -not -ipath "src/testing/*/*.sh"
}

# @description Builds the stdlib testing reference files.
#   * DOCS_STDLIB_TESTING_FOLDERS_ARRAY: The folders to include in the stdlib testing reference.
#   * DOCS_STDLIB_TESTING_TOPICS_ARRAY: The topics associated with each folder in the stdlib testing reference.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_reference() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE_TESTING.md"
  builtin local target_folder
  builtin local -a target_folder_array
  builtin local target_markdown_file_path
  builtin local target_folder_depth
  builtin local target_topic
  builtin local -a target_topic_array

  "${_STDLIB_BINARY_CAT}" << EOF > "${markdown_index_file_path}"
# STDLIB Testing Function References

<!-- markdownlint-disable MD024 -->

EOF

  target_folder_array=("${DOCS_STDLIB_TESTING_FOLDERS_ARRAY[@]}")
  target_topic_array=("${DOCS_STDLIB_TESTING_TOPICS_ARRAY[@]}")

  for ((index = 0; index < "${#target_folder_array[@]}"; index++)); do
    target_folder="${target_folder_array[index]}"
    target_folder_depth=100
    target_topic="${target_topic_array[index]}"

    target_markdown_file_path="src/testing/${target_folder}/REFERENCE.md"
    target_markdown_file_path="${target_markdown_file_path/"/."/}"

    if [[ "${target_folder}" == "." ]]; then
      target_folder_depth=1
    fi

    markdown_file_header="$(
      "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB ${target_topic} Function Reference

<!-- markdownlint-disable MD024 -->

EOF
    )"
    docs.build.__generic_reference \
      "${target_markdown_file_path}" \
      "${markdown_file_header}" \
      "src/testing/${target_folder}" \
      -maxdepth "${target_folder_depth}" \
      '(' -iname '*.sh' -o -iname '*.snippet' ')'

    if [[ "${index}" -eq 0 ]]; then
      builtin echo "* [Complete Function Reference](src/testing/REFERENCE_COMPLETE.md)" >> "${markdown_index_file_path}"
      builtin echo "---" >> "${markdown_index_file_path}"
    fi

    if [[ "${target_folder}" == "mock" ]]; then
      builtin echo "* [Mock Object Reference](src/testing/${target_folder}/REFERENCE_MOCK_OBJECT.md)" >> "${markdown_index_file_path}"
    fi

    builtin echo "* [${target_topic/Testing /} Function Reference](${target_markdown_file_path})" >> "${markdown_index_file_path}"
  done
}

# @description Builds the complete stdlib testing function reference file.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_reference_complete() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE_COMPLETE.md"
  builtin local target_markdown_file_path

  target_markdown_file_path="src/testing/${markdown_index_file_path}"

  markdown_file_header="$(
    "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB Testing Complete Function Reference

<!-- markdownlint-disable MD024 -->

* [Mock Object Reference](mock/REFERENCE_MOCK_OBJECT.md)
----
EOF
  )"
  docs.build.__generic_reference \
    "${target_markdown_file_path}" \
    "${markdown_file_header}" \
    "src/testing" \
    '(' -iname '*.sh' -o -iname '*.snippet' ')'
}

# @description Builds the stdlib testing mock object reference file.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_reference_mock_object() {
  builtin local -a DOCS_BUILD_FILE_PATH_ARRAY
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_ONE="object"
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_TWO="object"
  builtin local markdown_file_header

  DOCS_BUILD_FILE_PATH_ARRAY=("src/testing/mock/components/main.sh")

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
# @exitcode 0 If the operation succeeded.
# @internal
docs.main() {
  builtin source "src/binary.sh"

  docs.build.stdlib_reference
  docs.build.stdlib_reference_complete

  docs.build.stdlib_testing_reference
  docs.build.stdlib_testing_reference_complete
  docs.build.stdlib_testing_reference_mock_object
}

docs.main "${@}"
