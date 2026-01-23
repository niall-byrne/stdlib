#!/bin/bash

# stdlib binaries library

builtin set -eo pipefail

_STDLIB_BINARY_CAT="$(builtin command -v cat)"       # noqa
_STDLIB_BINARY_CUT="$(builtin command -v cut)"       # noqa
_STDLIB_BINARY_GREP="$(builtin command -v grep)"     # noqa
_STDLIB_BINARY_HEAD="$(builtin command -v head)"     # noqa
_STDLIB_BINARY_MKTEMP="$(builtin command -v mktemp)" # noqa
_STDLIB_BINARY_RM="$(builtin command -v rm)"         # noqa
_STDLIB_BINARY_SED="$(builtin command -v sed)"       # noqa
_STDLIB_BINARY_SORT="$(builtin command -v sort)"     # noqa
_STDLIB_BINARY_TAIL="$(builtin command -v tail)"     # noqa
_STDLIB_BINARY_TPUT="$(builtin command -v tput)"     # noqa
_STDLIB_BINARY_TR="$(builtin command -v tr)"         # noqa
