#!/bin/bash

# stdlib binaries library

builtin set -eo pipefail

# @internal
# @description The path to the 'cat' binary.
_STDLIB_BINARY_CAT="$(builtin command -v cat)"       # noqa
# @internal
# @description The path to the 'cut' binary.
_STDLIB_BINARY_CUT="$(builtin command -v cut)"       # noqa
# @internal
# @description The path to the 'grep' binary.
_STDLIB_BINARY_GREP="$(builtin command -v grep)"     # noqa
# @internal
# @description The path to the 'head' binary.
_STDLIB_BINARY_HEAD="$(builtin command -v head)"     # noqa
# @internal
# @description The path to the 'mktemp' binary.
_STDLIB_BINARY_MKTEMP="$(builtin command -v mktemp)" # noqa
# @internal
# @description The path to the 'rm' binary.
_STDLIB_BINARY_RM="$(builtin command -v rm)"         # noqa
# @internal
# @description The path to the 'sed' binary.
_STDLIB_BINARY_SED="$(builtin command -v sed)"       # noqa
# @internal
# @description The path to the 'sort' binary.
_STDLIB_BINARY_SORT="$(builtin command -v sort)"     # noqa
# @internal
# @description The path to the 'tail' binary.
_STDLIB_BINARY_TAIL="$(builtin command -v tail)"     # noqa
# @internal
# @description The path to the 'tput' binary.
_STDLIB_BINARY_TPUT="$(builtin command -v tput)"     # noqa
# @internal
# @description The path to the 'tr' binary.
_STDLIB_BINARY_TR="$(builtin command -v tr)"         # noqa
