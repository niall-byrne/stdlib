#!/bin/bash

# stdlib testing mock arg_string library

builtin set -eo pipefail

_MOCK_ATTRIBUTES_RESTRICTED=(
  "builtin"
  "case"
  "do"
  "done"
  "elif"
  "else"
  "esac"
  "fi"
  "for"
  "if"
  "while"
)
