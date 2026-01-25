#!/bin/bash

# stdlib documentation build script
# $1: the target filename

main() {
  local filepath
  local filepaths
  local markdown_file="${1}"

  while IFS= read -r filepath; do
    filepaths+=("${filepath}")
  done <<< "$(
    find src \
      '(' -iname '*.sh' -o -iname '*.snippet' ')' \
      -not -ipath 'src/tests/*.sh' \
      -not -ipath 'src/*/tests/*.sh' |
      sort
  )"

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
