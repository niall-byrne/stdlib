#!/bin/bash

# stdlib development container script

set -eo pipefail

TEST_CONTAINER_DISABLE_TTY="${TEST_CONTAINER_DISABLE_TTY:-0}"

_container_build() {
  pushd "${test_working_directory}" > /dev/null

  docker build \
    --build-arg UID1="$(id -u)" \
    --build-arg GID1="$(id -u)" \
    -f Dockerfile \
    -t stdlib:local \
    .

  popd > /dev/null
}

_container_run() {
  pushd "${test_working_directory}" > /dev/null

  if [[ "${TEST_CONTAINER_DISABLE_TTY}" -eq "1" ]]; then
    test_container_switches="t"
  fi

  docker run \
    --rm \
    -"${test_container_switches}" \
    -e TEST_RUNNER \
    -v "${PWD}":/work \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --tmpfs /tmp:exec \
    stdlib:local \
    "${test_container_command}" "${@}"

  popd > /dev/null
}

_container_main() {
  local test_container_command="${2:-"bash"}"
  local test_container_switches="it"
  local test_working_directory

  if [[ "${EUID}" == "0" ]]; then
    echo "Do not run this container as root."
    echo "Try one of the following strategies:"
    echo "#1 add yourself to the docker group, and retry:"
    echo "- ./container.sh docker_group"
    echo "#2 change the permissions on the docker socket:"
    echo "- ./container.sh docker_permissions"
    return 127
  fi

  test_working_directory="$(dirname "${0}")"

  case "${1}" in
    build)
      _container_build
      ;;
    ci)
      test_container_switches="t"
      _container_build
      _container_run t
      ;;
    docker_group)
      sudo usermod -aG docker "${USER}"
      exec sudo su -l "${USER}"
      ;;
    docker_permissions)
      sudo chgrp "${USER}" /var/run/docker.sock
      ;;
    run)
      _container_run "${@:3}"
      ;;
    *)
      echo "USAGE: container.sh [command]"
      echo "  Valid Commands:"
      echo "    - build               - build container"
      echo "    - docker_group        - add the current user to the docker group"
      echo "    - docker_permissions  - modify permissions on the docker socket"
      echo "    - run <optional cmds> - run container with a shell, or commands"
      return 127
      ;;
  esac
}

_container_main "$@"
