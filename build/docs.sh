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

# @description Builds the stdlib reference files.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.build.stdlib_reference() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE.md"
  builtin local -a target_folders
  builtin local target_folder
  builtin local target_markdown_file_path

  "${_STDLIB_BINARY_CAT}" << EOF > "${markdown_index_file_path}"
# STDLIB Function References

<!-- markdownlint-disable MD024 -->

EOF

  target_folders=("." "" "array" "fn" "io" "logger" "security" "setting" "string" "trap" "var")
  target_topics=("Complete" "" "Array" "FN" "IO" "Logger" "Security" "Setting" "String" "Trap" "Variable")

  for ((index = 0; index < "${#target_folders[@]}"; index++)); do
    target_folder="${target_folders[index]}"
    target_topic="${target_topics[index]}"

    if [[ -z "${target_folder}" ]]; then
      builtin echo "---" >> "${markdown_index_file_path}"
      builtin continue
    fi

    if [[ "${target_topic}" == "Complete" ]]; then
      target_markdown_file_path="src/${target_folder}/REFERENCE_COMPLETE.md"
      target_markdown_file_path="${target_markdown_file_path/"/."/}"
    else
      target_markdown_file_path="src/${target_folder}/REFERENCE.md"
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
      "src/${target_folder}" \
      '(' -iname '*.sh' -o -iname '*.snippet' ')' \
      -not -ipath "src/./testing/*.sh" \
      -not -ipath "src/./testing/*/*.sh"

    builtin echo "* [${target_topic} Function Reference](${target_markdown_file_path})" >> "${markdown_index_file_path}"
  done
}

# @description Builds the stdlib testing reference files.
# @noargs
# @exitcode 0 If the operation is successful.
# @internal
docs.build.stdlib_testing_reference() {
  builtin local index
  builtin local markdown_file_header
  builtin local markdown_index_file_path="REFERENCE_TESTING.md"
  builtin local -a target_folders
  builtin local target_folder
  builtin local -a target_topics
  builtin local target_topic
  builtin local -a target_folder_depths
  builtin local target_folder_depth
  builtin local target_markdown_file_path

  "${_STDLIB_BINARY_CAT}" << EOF > "${markdown_index_file_path}"
# STDLIB Testing Function References

<!-- markdownlint-disable MD024 -->

EOF

  target_folders=("." "" "assertion" "capture" "fixtures" "." "mock" "parametrize")
  target_folder_depths=("100" "100" "100" "100" "100" "1" "100" "100")
  target_topics=("Complete" "" "Testing Assertion" "Testing Capture" "Testing Fixture" "Testing Generic" "Testing Mock" "Testing Parametrization")

  for ((index = 0; index < "${#target_folders[@]}"; index++)); do
    target_folder="${target_folders[index]}"
    target_folder_depth="${target_folder_depths[index]}"
    target_topic="${target_topics[index]}"

    if [[ -z "${target_folder}" ]]; then
      builtin echo "---" >> "${markdown_index_file_path}"
      builtin continue
    fi

    if [[ "${target_topic}" == "Complete" ]]; then
      target_markdown_file_path="src/testing/${target_folder}/REFERENCE_COMPLETE.md"
      target_markdown_file_path="${target_markdown_file_path/"/."/}"
    else
      target_markdown_file_path="src/testing/${target_folder}/REFERENCE.md"
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

    if [[ "${target_folder}" == "mock" ]]; then
      builtin echo "* [Mock Object Reference](src/testing/${target_folder}/REFERENCE_MOCK_OBJECT.md)" >> "${markdown_index_file_path}"
    fi
    builtin echo "* [${target_topic/Testing /} Function Reference](${target_markdown_file_path})" >> "${markdown_index_file_path}"
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
