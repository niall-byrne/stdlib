# STDLIB

A reusable standard library for [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)).

## About

This is my small attempt to create a home for the myriad of helper functions we all seem to end up implementing when cobbling together scripting.

A mocking system, modelled on Python, has also been included to try and simplify the task of testing scripts.

This won't cover every use case out there, but it does provide a consistent and extendable API that can easily grow.  Pull requests are welcome, as is feedback and ideas.

Comprehensive [documentation](https://bash-stdlib.readthedocs.io/) is also available to get you started.

## Compatibility

Most of the library is intentionally POSIX in nature, which makes me confident that a wide variety of BASH versions are supported.

It's important to note that STDLIB in its current form requires GNU/Linux binaries to function correctly.  If there is sufficient interest, support for BSD or OSX environments can be added.
