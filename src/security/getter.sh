#!/bin/bash

# stdlib security getter library

builtin set -eo pipefail

# @description Returns the effective user ID (EUID).
# @noargs
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The effective user ID.
stdlib.security.get.euid() {
  [[ "${#@}" == "0" ]] || builtin return 127

  builtin echo "${EUID}"
}

# @description Returns the group ID (GID) for a specified group name.
# @arg $1 string The group name.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The group ID.
stdlib.security.get.gid() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  getent group "${1}" | "${_STDLIB_BINARY_CUT}" -d ":" -f 3 || builtin return 126
}

# @description Returns the user ID (UID) for a specified username.
# @arg $1 string The username.
# @exitcode 0 If the operation succeeded.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The user ID.
stdlib.security.get.uid() {
  [[ "${#@}" == "1" ]] || builtin return 127
  [[ -n "${1}" ]] || builtin return 126

  id -u "${1}" || builtin return 126
}

# @description Returns the first unused user ID (UID) starting from 1000.
# @noargs
# @exitcode 0 If an unused UID was found.
# @exitcode 1 If no unused UID was found.
# @exitcode 127 If the wrong number of arguments was provided.
# @stdout The first unused user ID.
stdlib.security.get.unused_uid() {
  builtin local current_id
  builtin local -a existing_ids
  builtin local existing_ids_index=0

  [[ "${#@}" == "0" ]] || builtin return 127

  builtin read -d '' -ra existing_ids <<< \
    "$( # KCOV_EXCLUDE_BEGIN
      "${_STDLIB_BINARY_CAT}" /etc/group /etc/passwd |
        "${_STDLIB_BINARY_CUT}" -d ':' -f 3 |
        "${_STDLIB_BINARY_SORT}" -n |
        "${_STDLIB_BINARY_GREP}" "^....$\|^.....$"
    )" || builtin true # KCOV_EXCLUDE_END

  # based on 2.4 linux kernel limit
  for ((current_id = "1000"; current_id <= "65535"; current_id++)); do
    while ((existing_ids_index < "${#existing_ids[@]}")); do
      if ((current_id < "${existing_ids[existing_ids_index]}")); then
        builtin break
      fi
      if ((current_id == "${existing_ids[existing_ids_index]}")); then
        ((existing_ids_index = existing_ids_index + 1))
        builtin continue 2
      fi
      ((existing_ids_index = existing_ids_index + 1))
    done
    id "${current_id}" > /dev/null 2>&1 || {
      builtin echo "${current_id}"
      builtin return 0
    }
  done

  builtin return 1
}
