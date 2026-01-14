# AI Instructions

## Testing and Production Code

If you are writing tests, or touching production code please make sure to thoroughly read [CONTRIBUTING.md](./CONTRIBUTING.md).

Changes that do not conform to the specified format will be rejected.

## Documentation

If you are adding documentation to the codebase, please limit the scope of your changes STRICTLY to comments.
Changes to production or test files are not authorized unless you explicitly ask for permissions.  It would still be advisable to read [CONTRIBUTING.md](./CONTRIBUTING.md) for context, however.

To generate documentation, the library [shdoc](https://github.com/reconquest/shdoc) is being used.

All functions with names that are prefixed with **stdlib** inside files within the [src](./src) folder are to be documented.  There may be existing comments that document the arguments inside each function, they should be removed as part of the Documentation work. They will look similar to "# $1: a description of this argument"

Care should be taken to add comments that identify the following mandatory fields:
- @description
- @arg / @noargs
- @set (if applicable)
- @exitcode
- @stdin (if applicable)
- @stdout (if applicable)
- @stderr (if applicable)
- @internal (if applicable)

Many of these functions consume global variables as "options" that modify their behaviour.
It might be good to detail these as: @option entries (if applicable)
<!-- vale off -->
In general the return codes should conform to:
- 0: operation succeeded
- 1: operation failed
- 126: An invalid argument was provided.
- 127: The wrong number of arguments was provided.
<!-- vale on -->
It should be possible to look at the code and decipher these return codes.
If return codes are found that don't seem to conform to this pattern, please make a list and manually notify a user.
