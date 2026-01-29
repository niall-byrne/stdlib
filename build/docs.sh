#!/bin/bash

# stdlib documentation build script

builtin set -eo pipefail

DOCS_BUILD_FILE_PATH=()
DOCS_BUILD_SUBSTITUTION_FOR_ONE=""
DOCS_BUILD_SUBSTITUTION_FOR_TWO=""

# @description Builds the stdlib reference files.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The index file.
# @internal
docs.build.stdlib_reference() {
  builtin local -a target_folders=("." "" "array" "fn" "io" "logger" "security" "setting" "string" "trap" "var")
  builtin local -a target_topics=("Complete" "" "Array" "FN" "IO" "Logger" "Security" "Setting" "String" "Trap" "Variable")

  docs.build.__reference_index_generator \
    "REFERENCE.md" \
    "STDLIB Function References" \
    "src" \
    target_folders \
    target_topics
}

# @description Builds the stdlib testing mock object reference file.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_mock_object_reference() {
  builtin local -a DOCS_BUILD_FILE_PATH
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_ONE="object"
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_TWO="object"
  builtin local markdown_file_header

  DOCS_BUILD_FILE_PATH=("src/testing/mock/components/main.sh")

  markdown_file_header="$( # noqa
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

# @description Builds the stdlib testing reference files.
# @noargs
# @exitcode 0 If the operation succeeded.
# @stdout The index file.
# @internal
docs.build.stdlib_testing_reference() {
  builtin local -a target_folders=("." "" "assertion" "capture" "fixtures" "." "mock" "parametrize")
  builtin local -a target_folder_depths=("100" "100" "100" "100" "100" "1" "100" "100")
  builtin local -a target_topics=("Complete" "" "Testing Assertion" "Testing Capture" "Testing Fixture" "Testing Generic" "Testing Mock" "Testing Parametrization")

  docs.build.__reference_index_generator \
    "REFERENCE_TESTING.md" \
    "STDLIB Testing Function References" \
    "src/testing" \
    target_folders \
    target_topics \
    target_folder_depths
}

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts.
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation succeeded.
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
# @exitcode 0 If the operation succeeded.
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

# @description Generates a markdown header for a reference file.
# @arg $1 string The topic name.
# @exitcode 0 If the operation succeeded.
# @stdout The markdown header.
# @internal
docs.build.__header_generator() {
  builtin local target_topic="${1}"

  "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB ${target_topic} Function Reference

<!-- markdownlint-disable MD024 -->

EOF
}

# @description A generic index and reference generator.
# @arg $1 string The path to the index file.
# @arg $2 string The title of the index file.
# @arg $3 string The base directory for source files.
# @arg $4 string The name of the folders array variable.
# @arg $5 string The name of the topics array variable.
# @arg $6 string The name of the depths array variable (optional).
# @exitcode 0 If the operation succeeded.
# @stdout The index file.
# @internal
docs.build.__reference_index_generator() {
  builtin local index_file_path="${1}"
  builtin local index_title="${2}"
  builtin local base_dir="${3}"
  builtin local folders_ref_name="${4}[@]"
  builtin local topics_ref_name="${5}[@]"
  builtin local -a folders=("${!folders_ref_name}")
  builtin local -a topics=("${!topics_ref_name}")
  builtin local -a depths=()
  builtin local index
  builtin local target_folder
  builtin local target_topic
  builtin local target_folder_depth
  builtin local target_markdown_file_path
  builtin local markdown_file_header

  if [[ -n "${6}" ]]; then
    builtin local depths_ref_name="${6}[@]"
    depths=("${!depths_ref_name}")
  fi

  "${_STDLIB_BINARY_CAT}" << EOF > "${index_file_path}"
# ${index_title}

<!-- markdownlint-disable MD024 -->

EOF

  for ((index = 0; index < "${#folders[@]}"; index++)); do
    target_folder="${folders[index]}"
    target_topic="${topics[index]}"

    if [[ -z "${target_folder}" ]]; then
      builtin echo "---" >> "${index_file_path}"
      builtin continue
    fi

    if [[ -n "${6}" ]]; then
      target_folder_depth="${depths[index]}"
    fi

    if [[ "${target_topic}" == "Complete" ]]; then
      target_markdown_file_path="${base_dir}/${target_folder}/REFERENCE_COMPLETE.md"
      target_markdown_file_path="${target_markdown_file_path/"/."/}"
    else
      target_markdown_file_path="${base_dir}/${target_folder}/REFERENCE.md"
    fi

    markdown_file_header="$(docs.build.__header_generator "${target_topic}")" # noqa

    if [[ -n "${target_folder_depth}" ]]; then
      docs.build.__generic_reference \
        "${target_markdown_file_path}" \
        "${markdown_file_header}" \
        "${base_dir}/${target_folder}" \
        -maxdepth "${target_folder_depth}" \
        '(' -iname '*.sh' -o -iname '*.snippet' ')'
    else
      docs.build.__generic_reference \
        "${target_markdown_file_path}" \
        "${markdown_file_header}" \
        "${base_dir}/${target_folder}" \
        '(' -iname '*.sh' -o -iname '*.snippet' ')' \
        -not -ipath "src/./testing/*.sh" \
        -not -ipath "src/./testing/*/*.sh"
    fi

    if [[ "${target_folder}" == "mock" ]]; then
      builtin echo "* [Mock Object Reference](${base_dir}/${target_folder}/REFERENCE_MOCK_OBJECT.md)" >> "${index_file_path}"
    fi

    builtin echo "* [${target_topic/Testing /} Function Reference](${target_markdown_file_path})" >> "${index_file_path}"
  done
}

# @description Builds all stdlib function references.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.main() {
  builtin source "src/binary.sh"

  docs.build.stdlib_reference
  docs.build.stdlib_testing_reference
  docs.build.stdlib_testing_mock_object_reference
}

docs.main "${@}"
