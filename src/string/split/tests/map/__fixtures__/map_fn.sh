#!/bin/bash

_uppercase() {
  echo "UPPERCASE: ${1}" | "${_STDLIB_BINARY_TR}" '[:lower:]' '[:upper:]'
}
