#!/bin/bash

# stdlib documentation build script
# $1: the target filename
# $@: an array of files to build documentation from

main() {
  local argument
  local filepath
  local filepaths
  local markdown_file="${1}"

  shift

  while IFS= read -r filepath; do
    filepaths+=("${filepath}")
  done <<< "$(for argument in "${@}"; do
    echo "${argument}"
  done | sort)"

  cat << EOF > "${markdown_file}"
# STDLIB Function Reference

<!-- markdownlint-disable MD024 -->

EOF

  shdoc <(for filepath in "${filepaths[@]}"; do
    cat "${filepath}"
  done) >> "${markdown_file}"

  truncate -s -1 "${markdown_file}"
}

main "${@}"
