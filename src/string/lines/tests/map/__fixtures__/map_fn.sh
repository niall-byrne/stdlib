#!/bin/bash

_uppercase() {
  builtin echo "UPPERCASE: ${1}" | "${_STDLIB_BINARY_TR}" '[:lower:]' '[:upper:]'
}
