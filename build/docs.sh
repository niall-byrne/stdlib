#!/bin/bash

# stdlib documentation build script

builtin set -eo pipefail

DOCS_BUILD_FILE_PATH=()
DOCS_BUILD_SUBSTITUTION_FOR_ONE=""
DOCS_BUILD_SUBSTITUTION_FOR_TWO=""

# @description Builds the stdlib reference files.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_reference() {
  builtin local -a docs_build_target_folders=("." "" "array" "fn" "io" "logger" "security" "setting" "string" "trap" "var")
  builtin local -a docs_build_target_topics=("Complete" "" "Array" "FN" "IO" "Logger" "Security" "Setting" "String" "Trap" "Variable")

  docs.build.__reference_index_generator \
    "REFERENCE.md" \
    "STDLIB Function References" \
    "src" \
    docs_build_target_folders \
    docs_build_target_topics
}

# @description Builds the stdlib testing mock object reference file.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_mock_object_reference() {
  builtin local -a DOCS_BUILD_FILE_PATH
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_ONE="object"
  builtin local DOCS_BUILD_SUBSTITUTION_FOR_TWO="object"
  builtin local docs_build_markdown_file_header

  DOCS_BUILD_FILE_PATH=("src/testing/mock/components/main.sh")

  docs_build_markdown_file_header="$( # noqa
    "${_STDLIB_BINARY_CAT}" << 'EOF'
# STDLIB Testing Mock Object Reference

<!-- markdownlint-disable MD024 -->

This reference uses the fictional example of a mock created with `_mock.create object`.

EOF
  )"

  docs.build.__generic_reference_from_here_doc \
    "src/testing/mock/REFERENCE_MOCK_OBJECT.md" \
    "${docs_build_markdown_file_header}" \
    "__STDLIB_TESTING_MOCK_COMPONENT" \
    src/testing/mock/components \
    -iname '*.sh' \
    -not -ipath 'src/testing/mock/components/main.sh'
}

# @description Builds the stdlib testing reference files.
# @noargs
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.stdlib_testing_reference() {
  builtin local -a docs_build_target_folders=("." "" "assertion" "capture" "fixtures" "." "mock" "parametrize")
  builtin local -a docs_build_target_folder_depths=("100" "100" "100" "100" "100" "1" "100" "100")
  builtin local -a docs_build_target_topics=("Complete" "" "Testing Assertion" "Testing Capture" "Testing Fixture" "Testing Generic" "Testing Mock" "Testing Parametrization")

  docs.build.__reference_index_generator \
    "REFERENCE_TESTING.md" \
    "STDLIB Testing Function References" \
    "src/testing" \
    docs_build_target_folders \
    docs_build_target_topics \
    docs_build_target_folder_depths
}

# @description Builds a shell reference from a folder (and subfolders) of documented shell scripts.
# @arg $1 string The file path to output generated markdown to.
# @arg $2 string A header string to write to the file path BEFORE markdown is appended.  This is typically used for a title.
# @arg $@ array A list of arguments to pass to 'find'.  This find call should output a list of all required shell files.
# @exitcode 0 If the operation succeeded.
# @internal
docs.build.__generic_reference() {
  builtin local docs_build_filepath
  builtin local -a docs_build_filepaths
  builtin local docs_build_markdown_file_path="${1}"
  builtin local docs_build_markdown_file_header="${2}"

  builtin shift 2

  while IFS= builtin read -r docs_build_filepath; do
    docs_build_filepaths+=("${docs_build_filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${docs_build_markdown_file_header}\n" > "${docs_build_markdown_file_path}" # noqa

  shdoc <(for docs_build_filepath in "${docs_build_filepaths[@]}"; do
    "${_STDLIB_BINARY_CAT}" "${docs_build_filepath}"
  done) >> "${docs_build_markdown_file_path}"

  truncate -s -1 "${docs_build_markdown_file_path}"
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
  builtin local docs_build_component_var_name="${3}"
  builtin local docs_build_filepath
  builtin local -a docs_build_filepaths
  builtin local docs_build_markdown_file_path="${1}"
  builtin local docs_build_markdown_file_header="${2}"
  builtin local docs_build_substitution_for_1="${DOCS_BUILD_SUBSTITUTION_FOR_ONE-"1"}"
  builtin local docs_build_substitution_for_2="${DOCS_BUILD_SUBSTITUTION_FOR_TWO-"2"}"

  builtin shift 3

  docs_build_filepaths+=("${DOCS_BUILD_FILE_PATH[@]}")

  while IFS= builtin read -r docs_build_filepath; do
    docs_build_filepaths+=("${docs_build_filepath}")
  done <<< "$(find "${@}" -not -ipath 'src/tests/*.sh' -not -ipath 'src/*/tests/*.sh' | "${_STDLIB_BINARY_SORT}")"

  builtin echo -e "${docs_build_markdown_file_header}\n" > "${docs_build_markdown_file_path}" # noqa

  shdoc <(for docs_build_filepath in "${docs_build_filepaths[@]}"; do
    # shellcheck source=/dev/null
    builtin source "${docs_build_filepath}"

    builtin echo -e "\n${!docs_build_component_var_name}\n" | # noqa
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${1}\|^\${1}/${docs_build_substitution_for_1}/g" |
      "${_STDLIB_BINARY_SED}" "s/[^\\]\${2}\|^\${2}/${docs_build_substitution_for_2}/g" |
      "${_STDLIB_BINARY_SED}" "s/\\$\(.\)/$\1/g"
  done) >> "${docs_build_markdown_file_path}"

  truncate -s -1 "${docs_build_markdown_file_path}"
}

# @description Generates a markdown header for a reference file.
# @arg $1 string The topic name.
# @exitcode 0 If the operation succeeded.
# @stdout The markdown header.
# @internal
docs.build.__header_generator() {
  builtin local docs_build_target_topic="${1}"

  "${_STDLIB_BINARY_CAT}" << EOF
# STDLIB ${docs_build_target_topic} Function Reference

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
# @internal
docs.build.__reference_index_generator() {
  builtin local docs_build_index_file_path="${1}"
  builtin local docs_build_index_title="${2}"
  builtin local docs_build_base_dir="${3}"
  builtin local docs_build_folders_ref_name="${4}[@]"
  builtin local docs_build_topics_ref_name="${5}[@]"
  builtin local -a docs_build_folders=("${!docs_build_folders_ref_name}")
  builtin local -a docs_build_topics=("${!docs_build_topics_ref_name}")
  builtin local -a docs_build_depths=()
  builtin local docs_build_index
  builtin local docs_build_target_folder
  builtin local docs_build_target_topic
  builtin local docs_build_target_folder_depth
  builtin local docs_build_target_markdown_file_path
  builtin local docs_build_markdown_file_header

  if [[ -n "${6}" ]]; then
    builtin local docs_build_depths_ref_name="${6}[@]"
    docs_build_depths=("${!docs_build_depths_ref_name}")
  fi

  "${_STDLIB_BINARY_CAT}" << EOF > "${docs_build_index_file_path}" # noqa
# ${docs_build_index_title}

<!-- markdownlint-disable MD024 -->

EOF

  for ((docs_build_index = 0; docs_build_index < "${#docs_build_folders[@]}"; docs_build_index++)); do
    docs_build_target_folder="${docs_build_folders[docs_build_index]}"
    docs_build_target_topic="${docs_build_topics[docs_build_index]}"

    if [[ -z "${docs_build_target_folder}" ]]; then
      builtin echo "---" >> "${docs_build_index_file_path}" # noqa
      builtin continue
    fi

    if [[ -n "${6}" ]]; then
      docs_build_target_folder_depth="${docs_build_depths[docs_build_index]}"
    fi

    if [[ "${docs_build_target_topic}" == "Complete" ]]; then
      docs_build_target_markdown_file_path="${docs_build_base_dir}/${docs_build_target_folder}/REFERENCE_COMPLETE.md"
      docs_build_target_markdown_file_path="${docs_build_target_markdown_file_path/"/."/}"
    else
      docs_build_target_markdown_file_path="${docs_build_base_dir}/${docs_build_target_folder}/REFERENCE.md"
    fi

    docs_build_markdown_file_header="$(docs.build.__header_generator "${docs_build_target_topic}")" # noqa

    if [[ -n "${docs_build_target_folder_depth}" ]]; then
      docs.build.__generic_reference \
        "${docs_build_target_markdown_file_path}" \
        "${docs_build_markdown_file_header}" \
        "${docs_build_base_dir}/${docs_build_target_folder}" \
        -maxdepth "${docs_build_target_folder_depth}" \
        '(' -iname '*.sh' -o -iname '*.snippet' ')'
    else
      docs.build.__generic_reference \
        "${docs_build_target_markdown_file_path}" \
        "${docs_build_markdown_file_header}" \
        "${docs_build_base_dir}/${docs_build_target_folder}" \
        '(' -iname '*.sh' -o -iname '*.snippet' ')' \
        -not -ipath "src/./testing/*.sh" \
        -not -ipath "src/./testing/*/*.sh"
    fi

    if [[ "${docs_build_target_folder}" == "mock" ]]; then
      builtin echo "* [Mock Object Reference](${docs_build_base_dir}/${docs_build_target_folder}/REFERENCE_MOCK_OBJECT.md)" >> "${docs_build_index_file_path}" # noqa
    fi

    builtin echo "* [${docs_build_target_topic/Testing /} Function Reference](${docs_build_target_markdown_file_path})" >> "${docs_build_index_file_path}" # noqa
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
