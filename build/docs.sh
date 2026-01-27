#!/bin/bash

# stdlib documentation build script

docs_stdlib_reference() {
  local filepath
  local filepaths=()
  local markdown_file="REFERENCE.md"

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

docs_stdlib_testing_mock_reference() {
  local filepath
  local filepaths=("src/testing/mock/components/main.sh")
  local markdown_file="src/testing/mock/MOCK_OBJECT_REFERENCE.md"
  local mock_object_name="object"

  while IFS= read -r filepath; do
    filepaths+=("${filepath}")
  done <<< "$(
    find src/testing/mock/components \
      -iname '*.sh' \
      -not -ipath 'src/testing/mock/components/main.sh' \
      -not -ipath 'src/testing/mock/components/tests/*.sh' |
      sort
  )"

  source "src/binary.sh"

  cat << 'EOF' > "${markdown_file}"
# STDLIB Mock Object Reference

<!-- markdownlint-disable MD024 -->

This reference uses the fictional example of a mock created with `_mock.create object`.

EOF

  shdoc <(for filepath in "${filepaths[@]}"; do
    # shellcheck source=/dev/null
    source "${filepath}"

    # shellcheck disable=SC2001
    echo -e "\n${__STDLIB_TESTING_MOCK_COMPONENT}\n" |
      sed "s/[^\\]\${1}\|^\${1}/${mock_object_name}/g" |
      sed "s/[^\\]\${2}\|^\${2}/${mock_object_name}/g" |
      sed "s/\\$\(.\)/$\1/g"
  done) >> "${markdown_file}"

  truncate -s -1 "${markdown_file}"
}

docs_stdlib_reference
docs_stdlib_testing_mock_reference
