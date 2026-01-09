#!/bin/bash

set -eo pipefail

# Uploads coverage reports to codecov.com

# CODECOV_TOKEN:  The token for codecov.com.

# CI only script.

main() {
  codecov_folder="$(mktemp -d)"
  coverage_folder="${PWD}/coverage"

  pushd "${codecov_folder}" > /dev/null

  curl https://keybase.io/codecovsecurity/pgp_keys.asc | gpg --no-default-keyring --keyring trustedkeys.gpg --import
  curl -Os https://cli.codecov.io/latest/linux/codecov
  curl -Os https://cli.codecov.io/latest/linux/codecov.SHA256SUM
  curl -Os https://cli.codecov.io/latest/linux/codecov.SHA256SUM.sig
  gpg --keyring trustedkeys.gpg --verify codecov.SHA256SUM.sig codecov.SHA256SUM

  shasum -a 256 -c codecov.SHA256SUM
  sudo chmod +x codecov

  popd > /dev/null

  "${codecov_folder}"/codecov upload-coverage -f "${coverage_folder}" -t "${CODECOV_TOKEN}"
}

main "$@"
