# AI Instructions

Please make sure to thoroughly read [CONTRIBUTING.md](./CONTRIBUTING.md).
Changes that do not conform to the specified format will be rejected.

If you are adding documentation to the codebase, please limit the scope of your changes STRICTLY to comments.  No other changes are permitted unless you ask for permission.

Please do not modify file permissions or create extra scripts if you are having trouble running the tests, instead refer to [CONTRIBUTING.md](./CONTRIBUTING.md).

## Running Tests Without a Container

Although the [container.sh](./container.sh) script is the only fully support method of running the test suite, an alternative host based method is available for environments where the use of docker is limited or unavailable.

This alternative method is enabled by with the [host.sh](./host.sh) script:
1. Install bash_unit on the local system:
    - `sudo ./host.sh bash_unit`
2. Launch a shell with a correctly configured 't' script in PATH:
    - `./host.sh shell`
3. Use the 't' command to run individual tests:
    - `t src/var/assert/tests/test_stdlib_var_assert_is_set.sh`
