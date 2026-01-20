# Contribution Guide

- [Codebase Setup Guidelines](#codebase-setup-guidelines)
- [Production Code Except for the Testing Folder](#production-code-except-for-the-testing-folder)
- [Production Code Inside the Testing Folder](#production-code-inside-the-testing-folder)
- [Documenting Production Code](#documenting-production-code)
- [Writing Tests for Production Code](#writing-tests-for-production-code)

***

## Codebase Setup Guidelines

1. Please be sure to install the [pre-commit hooks](https://pre-commit.com/) after cloning the repository:
    - `pip install poetry`
    - `poetry install`
    - `git config --global --unset-all core.hooksPath`
    - `poetry run pre-commit install`
2. Be sure to update the vale spelling rules:
    - `poetry run pre-commit run --hook-stage manual spelling-vale-sync`
3. Please also be sure to make commits that conform to the [commitizen](https://commitizen-tools.github.io/commitizen/) format:
    - For details please run: `poetry run cz`
    - The commit messages **scope** should be fully capitalized, with the message itself in lowercase:
        - i.e. `git commit -m 'docs(CONTRIBUTING): add contribution guide'`

**Do not skip failing pre-commit hooks, they are there to preserve code quality.  Instead, please investigate the problem or ask for help.**

***

## Production Code Except for the Testing Folder

The most important aspect of writing production code is to make sure the codebase pre-commit hooks are installed and functioning correctly.  These hooks will run external formatting and linting tools to enforce general guidelines about spacing and formatting.

Critically, these hooks also ensure consistent use the `builtin` keyword, which is best practice for protecting the library from being overridden by externally set functions.

It's also critically important to note that all functions exposed to the end user must be documented.  See the [documentation guide](#documenting-production-code) for details on the exact procedure.

### The Separation of the `testing` Folder

There is a critical separation between the [testing](src/testing) folder and the rest of the codebase. The standards in this section apply to all production code EXCEPT the testing folder, and its nested content.   There are [separate conventions](#production-code-inside-the-testing-folder) that are used for code in this folder.

This separation ensure users loading stdlib don't need to load testing code unless they are actually testing their application.

### Production File and Function Naming

File names should be <!-- vale off -->simple<!-- vale on -->, preferably one word (or a couple of snake-case words) that describe the entity the functions inside act on.  There are some existing patterns that have emerged that should be respected where possible.  For example:
- assertion / (is.sh / not.sh)
- query  / (is.sh / not.sh)

Subfolders should only be used when an <!-- vale off -->obvious<!-- vale on --> (or existing) type of grouping is being used, or when an impractical number of functions are found in the same file.

Function names should be prefixed with `stdlib` and use a dot separated naming scheme that follows the directory structure of the project.  Individual elements can be separated in a lower snake-case (lowercase with underscores) method if appropriate.  For example:
- `stdlib.array.assert.is_array`
- `stdlib.string.justify.left`

Private functions, that are not intended to be exposed to the end user, should <!-- vale off -->clearly<!-- vale on --> distinguish themselves by using a double underscore prefix.  For example:
- `stdlib.array.module.__example1`
- `stdlib.fn.__example2`

Private functions don't require documentation as they do not provide an API for end users to consume.

### Production Variable Naming

All local variables should be defined with strict usage of the `builtin local` keywords to prevent environment contamination.  Variables names should be in lower snake-case (lowercase, with underscore separators).

Local arrays should be defined using `builtin local -a`.  Associative arrays should be avoided, as we'd like stdlib to support as many versions of bash as possible.

Global variables should be prefixed with `STDLIB`, and should be in upper snake-case (uppercase, with underscore separators).  For example:
- `STDLIB_COLOUR_BLACK`
- `STDLIB_THEME_LOGGER_ERROR`
- `STDLIB_BINARY_CAT`

There are a few global variables that store state, and are not meant to be accessed by an end-user.  These are prefixed with `__STDLIB`, indicating they are private.  For example:
- `__STDLIB_LOGGING_DECORATORS`

Global variables are often used as a "modifying option" for function behaviour.  If they are performing this role should have a global definition in the most appropriate file so that the variable is included in the [packaging process](#creating-a-distributable).
### Production Centralization of Messages

To facilitate translation, the existing [message.sh](src/message.sh) file should be expanded (along with its tests) rather than using hardcoded strings in the codebase.

All production strings should be added to this file.  However, strings used inside the testing folder are treated differently, and are covered in  the [next section](#production-code-inside-the-testing-folder).

***

## Production Code Inside the Testing Folder

Everything under [testing](src/testing) should NOT be required for typical production use of a script consuming stdlib.  This separation of concerns between production and testing is intended to make it less resource intensive for consuming apps.

The functions in the testing folder should be used ONLY for writing tests, and never in non-testing production code.

The conventions for this folder differ slightly, chiefly to make writing tests as painless as possible.

### Production Testing Function and File Naming

<!-- vale off -->
File naming here follows the same paradigm as [production](#production-file-and-function-naming), file names should be simple and short.
<!-- vale on -->

Most conventions in the testing folder follow the same set of [general guidelines](#general-testing-folder-conventions), but there are different sets of function naming conventions to help end users of stdlib write tests easier.

In addition, it should be noted that there are a few different `message.sh` files in the testing folder to split up the different types of messages.

#### General Testing Folder Conventions

There are certain conventions that apply globally to the testing folder, and these "general" guidelines are typically used across board where it makes sense.

##### General Testing Function Names

In general most functions in the testing folder follow the [standard production function naming conventions](#production-file-and-function-naming) but with a different prefix.

The prefix `_testing` should be used.  For example:
- `_testing.load`
- `_testing.message.get`

Similarly to the rest of the production code, private functions include a double underscore. For example:
- `_testing.__protected`

Please note however that for the purposes of exposing a user-friendly API, there are several exceptions to this convention which are detailed in subsequent sections below.

##### General Testing Variable Names

The testing folder follows the [standard production variable naming conventions](#production-variable-naming).  This means that that local variable names should be lower snake-case and defined using the `builtin local` keywords.

Global variables, should be prefixed with `STDLIB_TESTING`, and should be in upper snake-case (uppercase, with underscore separators).  For example:
- `STDLIB_TESTING_TRACEBACK_REGEX`
- `STDLIB_TESTING_THEME_LOAD`
- `STDLIB_TESTING_PROTECT_PREFIX`

There are a few global variables that store state and are not meant to be accessed by an end-user.  These are prefixed with `__STDLIB_TESTING` to  indicate they are private.  For example:
- `__STDLIB_TESTING_MOCK_INSTANCES`
- `__STDLIB_TESTING_MOCK_REGISTRY`

##### Reserved Testing Global Variable Names

A few global variables are reserved for use in testing and are widely used across the testing folder's function families.

These variables are intended to be used by end users writing tests, so they are named quite <!-- vale off -->simply<!-- vale on -->.

| Variable Name | Purpose                                                     |
|---------------|-------------------------------------------------------------|
| TEST_OUTPUT   | To store captured stdout or stderr for use with assertions. |
| TEST_RC       | To store captured return codes for use with assertions.     |

##### General Centralization of Messages

Most of the subfolders in the testing folder contain their own `message.sh` file.  In addition, there is also a top-level general purpose [message.sh](src/testing/message.sh) file for strings that aren't tied to a more specific purpose.

When adding new strings that fit this "general purpose" criteria, this file should be expanded (along with its tests) rather than using hardcoded strings in the codebase.

#### Assertions

The [assertion testing subfolder](src/testing/assertion) contains a family of functions specifically written to extend the [bash_unit](https://github.com/bash-unit/bash_unit)test framework.

Specifically, they build complex assertions by building upon the following functions found in bash_unit:
- `fail`
- `assert_equals`
- `assert_not_equals`

##### Assertion Function Naming

All assertion functions are prefixed with `assert` and use  lower snake-case (lowercase, with underscore separators).  For example:
- `assert_is_fn`
- `assert_null`
- `assert_output`

This naming convention is used by both [bash_unit](https://github.com/bash-unit/bash_unit) and  [bashunit](https://bashunit.typeddevs.com/).  The assumption is that using the same convention will make tests easier to read for people who've used those frameworks before.

##### Assertion Centralization of Messages

To facilitate translation, all assertion strings are stored in a dedicated [message.sh](src/testing/assertion/message.sh) file.

When adding new strings, this file should be expanded (along with its tests) rather than using hardcoded strings in the codebase.

#### Captures

The [capture testing subfolder](src/testing/capture) contains a family of functions specifically written to make working with stdin, stderr and return codes easier.

##### Capture Function Naming

All capture functions are prefixed with `_capture` which is dot separated from a description written in lower snake-case (lowercase, with underscore separators).  For example:
- `_capture.assertion_failure`
- `_capture.output`
- `_capture.rc`
- `_capture.stderr_raw`

##### Capture Centralization of Messages

In general the captures do not produce output themselves, and have no message strings.  The exception to this is [capture_assertion_failure](src/testing/capture/assertion_failure.sh) which uses the assertion [message.sh](src/testing/assertion/message.sh) file as there is a logical relationship.

#### Mocks

The [mock testing subfolder](src/testing/mock) contains a family of functions specifically written to create a robust and flexible mocking system.  It's heavily influenced by [Python's mock module](https://docs.python.org/3.14/library/unittest.mock.html).

##### Mock Function Naming

The mocking function names follow the same rules as the [general testing folder conventions](#general-testing-function-names), but with a few exceptions.

<!-- vale off -->
A unique `_mock` prefix is given to handful of functions to create an easily consumable API for end users.  For example:
<!-- vale on -->
- `_mock.create`
- `_mock.sequence.assert_is_empty`
- `_mock.arg_string.make.from_array`

##### Mock Centralization of Messages

To facilitate translation, all mock strings are stored in a dedicated [message.sh](src/testing/mock/message.sh) file.

When adding new strings, this file should be expanded (along with its tests) rather than using hardcoded strings in the codebase.

#### Parametrizers

The [parametrize testing subfolder](src/testing/parametrize) contains a family of functions specifically written to decorate test functions.  The parametrizers use conditional values to create mutated variants of the original test function.

<!-- vale off -->
This allows an end user of stdlib to write a single test that can be used to test multiple execution paths.
<!-- vale on -->

These functions are inspired by [pytest's 'parametrize' feature](https://docs.pytest.org/en/stable/how-to/parametrize.html).

#### Parametrizer Functions

The parametrizer function names follow the same rules as the [general test folder conventions](#general-testing-function-names), but with a few exceptions.

<!-- vale off -->
A unique `@parametrize` prefix is given to handful of functions to create an easily consumable API for end users.  For example:
<!-- vale on -->
- `@parametrize`
- `@parametrize.apply`
- `@parametrize.compose`

##### Parametrizer Centralization of Messages

To facilitate translation, all parametrizer strings are stored in a dedicated [message.sh](src/testing/parametrize/message.sh) file.

When adding new strings, this file should be expanded (along with its tests) rather than using hardcoded strings in the codebase.

***

## Creating a Distributable

It's important to note that the distributable can only be generated from within the docker container.   This container is both built and run using the [container.sh](container.sh) script.

<!-- vale off -->
When the [package.sh](build/package.sh) script is executed it performs the following steps:
<!-- vale on -->

1. [stdlib.sh](dist/stdlib.sh) is built:
    - the production stdlib code is loaded
    - global variables that are prefixed with `STDLIB` or `__STDLIB` are parsed
    - functions that are prefixed with `stdlib` are parsed
    - `snippet` files containing runtime configuration are loaded
    - a <!-- vale off -->simple<!-- vale on --> self test is performed
    - the final distributable is then written to disk in the [distribution folder](dist) using these entities

2. [stdlib_testing.sh](dist/stdlib_testing.sh) is built:
    - the production stdlib code from the testing folder is loaded
    - global variables that are prefixed with `STDLIB_TESTING` or `__STDLIB_TESTING`  are parsed
    - functions that are prefixed with  `assertion`, `capture`, `mock`, `@parametrizer` or `testing` are parsed
    - `snippet` files containing runtime configuration are loaded
    - a <!-- vale off -->simple<!-- vale on --> self test is performed
    - the final distributable is then written to disk in the [distribution folder](dist) using these entities

3. [locales](dist/locales) is updated:
    - compiled translations from the locales folder are copied into the [distribution folder](dist)

***

## Documenting Production Code

To generate documentation, the library [shdoc](https://github.com/reconquest/shdoc) is being used.

All functions with names that are prefixed with **stdlib** inside files within the [src](src) folder are to be documented.

There may be at times existing comments that document the arguments inside each function, they should be removed as part of the documentation process.  An example of this would be:
- `# $1: a description of this argument`

Please correctly identify private functions that contain a double underscore (`__`) in their names:
- These functions get an additional `@internal` tag that keeps them private.

### Required Fields for Documentation

Please use capitalized proper sentences followed by a <!-- vale off -->period<!-- vale on --> as the content of each field.

Care should be taken to add comments that identify the following mandatory fields, in explicitly this order:
- `@description`
  - Please detail [global variable](#documenting-global-variable-usage) usage on 4 space indented lines in this section.
  - This indentation is 5 total spaces from the comment marker '#'.
- `@arg` / `@noargs` (one of these two fields must ALWAYS be present)
- `@exitcode` (see [below](#documenting-exit-codes))
- `@set` (if applicable)
- `@stdin` (if applicable)
- `@stdout` (if applicable, keep in mind that logging info, notice and success messages are written to stdout)
- `@stderr` (if applicable, keep in mind that logging errors and warnings are written to stderr)
- `@internal` (if applicable, private functions with a double underscore (`__`) in their names get this final tag)

The fields should appear in this exact order for consistency in the documentation.

### Documenting Global Variable Usage

Many of these functions consume global variables as "options" that modify their behaviour.

Please detail this inside the `@description` entries with 4 space indented lines (5 total spaces from the comment marker '#').

### Documenting Exit Codes

Exit code descriptions take the form of a capitalized conditional sentence starting with `If`.

<!-- vale off -->
In general the return codes should conform to:
- 0: If the operation succeeded.
- 1: If the operation failed.
- 126: If an invalid argument has been provided.
- 127: If the wrong number of arguments were provided.
<!-- vale on -->
It should be possible to look at the code and decipher these return codes.
An entry for exit code 0 should ALWAYS be included for consistency.

If return codes are found that don't seem to conform to this pattern, please notify someone before proceeding further.

#### Standardized Exit Code Messages

The exit codes for 126 and 127 are universally standardized.

Any function that can return 126, or 127 should use the same exact language for documentation:
- ```# @exitcode 126 If an invalid argument has been provided.```
- ```# @exitcode 127 If the wrong number of arguments were provided.```

### Documentation Examples

An example function with a single string argument and a consumed global variable:

```sh
# @description Prints an error message to stderr.
#     STDLIB_THEME_LOGGER_ERROR: The colour to use for the message.
# @arg $1 string The message to print.
# @exitcode 0 If the message was printed successfully.
# @stderr The error message.
```

An example function with two required and one optional arguments:

```sh
# @description Creates a cleanup function that removes files and directories.
# @arg $1 string The name of the cleanup function to create.
# @arg $2 string The name of the array used for tracking filesystem objects to clean up.
# @arg $3 boolean (optional, default=false) A boolean indicating if recursive deletes should be done.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
```

An example internal function with two required arguments that sets a global variable:

```sh
# @description A purely fictitious function that sets a global variable.
# @arg $1 string The first name of a person.
# @arg $2 string The last name of a person.
# @set FULL_NAME string The space separated combination of a person's first and last name.
# @exitcode 126 If an invalid argument has been provided.
# @exitcode 127 If the wrong number of arguments was provided.
```

### Documenting Derived Functions

There are some dynamically generated functions found in the codebase.  These functions are generated using:
- [stdlib.fn.derive.pipeable](src/fn/derive/pipeable.sh)
- [stdlib.fn.derive.var](src/fn/derive/var.sh)

These functions create new functions that are named slightly differently.  In order to document them, we must create stub functions on the line directly preceding the call to the derive function.  These stub functions are just placeholders.

#### An Example Pipeable Derived Function

This section contains an example for the function [stdlib.string.colour_n](src/string/colour/colour.sh).

**Please note the handling of the '-' argument, and it's description.**

All pipeable function comments should include the following:
1. A description tag that conforms to:
   - `A derivative of {original function name} that can read from stdin.`
2. An optional argument description with an appended clause that states:
   - `..., by default this function reads from stdin.`
3. A `@stdin` tag that conforms to:
   - `A capitalized full sentence describing the input.`

```sh
# @description A derivative of stdlib.string.colour_n that can read from stdin.
# @arg $1 string The name of the colour to use.
# @arg $2 string (optional, default="-") The string to colour, by default this function reads from stdin.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stdin The string to colour.
# @stdout The coloured string without a newline.
# @stderr The error message if the operation fails.
stdlib.string.colour_n_pipe() { :; }
stdlib.fn.derive.pipeable "stdlib.string.colour_n" "2"
```

#### An Example Variable Derived Function

This section contains an example for the function [stdlib.string.colour_n](src/string/colour/colour.sh).

**Please note the handing of the variable argument.**

All var functions comments should include the following:
1. A description tag that conforms to:
   - `A derivative of {original function name} that can read from and write to a variable.`
2. An argument description that states:
   - `The name of the variable to read from and write to.`

```sh
# @description A derivative of stdlib.string.colour_n that can read from and write to a variable.
# @arg $1 string The name of the colour to use.
# @arg $2 string The name of the variable to read from and write to.
# @exitcode 0 If the operation succeeded.
# @exitcode 127 If the wrong number of arguments were provided.
# @stderr The error message if the operation fails.
stdlib.string.colour_var() { :; }
stdlib.fn.derive.var "stdlib.string.colour_n" "stdlib.string.colour_var"
```

***

## Writing Tests for Production Code

All test code, even in the [testing](src/testing) folder, follows this same set of guidelines, which is slightly less stringent than production.

There are two test runners to be aware of:
- The test runner [dist/t](dist/t) is a test runner meant for projects that are consuming stdlib, and should **not** be used for testing stdlib itself.
- The test runner [build/t](build/t) is the one that should be used for testing stdlib, and is the default found in path in the testing container.

The preferred way to run the tests is with [container.sh](container.sh):
1. Build the test container first before running tests:
    - `./container.sh build`
2. Run the test suites themselves:
    - `./container.sh run t src`
    - `./container.sh run t src/logger`

If you are encountering TTY problems, try setting the environment variable `TEST_CONTAINER_DISABLE_TTY` to 1 before using the container script:
  - `TEST_CONTAINER_DISABLE_TTY=1 ./container.sh run t src`

If you encounter docker permission problems the script has two commands that are helpful:
  - `./container.sh docker_group` will add the shell user to the docker group which often resolves the problem
  - `./container.sh docker_permissions` will change the ownership of the docker socket which may also resolve the problem

If you cannot use docker it is also possible to run the tests with [t](build/t) directly.  This is the least preferred and most complex method.  It is not desirable as it provides no separation between the test environment and the host machine.

### Naming Test Files

Test file names conform to the following conventions:
- Each test lives in a `tests` folder next to the file being tested.
- Each function being tested gets its own separate test file in this folder, grouped together by a subfolder that is the same name as the file being tested.

For example if you were testing functions in the file `src/target.sh`, you would create files with the following names and folder structure:
- `src/tests/target/test_target_function1.sh`
- `src/tests/target/test_target_function2.sh`

### Naming Test Functions

Individual test functions all have names that are prefixed with `test` and are formatted in lower snake-case (lowercase with underscore separators).

Each test name should contain:
- The name function name being tested.
- A short description of the condition(s) being tested.
- The expected result.

The test name itself combines the prefix and these three elements, using double underscores to separate each element.  A single underscore separates the prefix `test` from the function name.

Concrete examples of this convention would be:
- `test_target_function_name__condition__expected_result() {}`
- `test_target_function_name__condition_1__condition2__expected_result() {}`

### Test Function Contents

Please follow the **Arrange**, **Act**, **Assert** (or AAA) testing methodology.  These three stages should be separated by at least one blank line in the test code.

Do not include comment to declare each **Arrange**, **Act** or **Assert** section.  Please just use a single blank line to separate these 3 stages from each other.

#### Setup and Tear Down

Outside the AAA portion of your test, you can wrap various `setup` and `teardown` functions.

Under the hood this project uses [bash_unit](https://github.com/bash-unit/bash_unit), please consult the documentation for details on its code reuse strategies.

##### Mocking

Use the [mocking framework](src/testing/mock/mock.sh) to create mocks in either the `setup`, or `setup_suite` test functions:
- `_mock.create my_new_mock`

It's also acceptable to create mocks in the **Arrange** section of individual test functions themselves if that is the required scope of the mock itself.

Use the mock object's builtin assertions to test each object's behaviour.  The assertions are typically broken into multiple lines for readability:

```bash
  my_mock.mock.assert_called_once_with
    "1(argument1) 2(argument2) 3(argument3)"
  my_mock.mock.assert_calls_are
    "1(call1-argument1) 2(call1-argument2) 3(call1-argument3)"
    "1(call2-argument1) 2(call2-argument2) 3(call2-argument3)"
```

Be sure to refer to the [documentation](src/testing/mock/mock.sh) on the mock object's behaviour and to see the complete list of available assertions.

#### Arrange

In the **Arrange** section of your test, you should define all local variables, and then after a single blank space, perform any additional setup your test requires.

##### Local Variables

All `local` variable definitions go at the top of the function definition, separated from the rest of the test function by a blank line.

Avoid using `local -a` and instead define with an empty array:
- avoid: `local -a variable_name`  - instead: `local variable_name=()`

(Production code uses `builtin local -a` and differs from this testing requirement.)

##### Fixture Functions

If you have tests that require extensive setup that isn't generalized enough to fit into a `setup` function, you may wish to create `_fixture_<name>` functions.  This is a way to reuse code while keeping your test readable.

Place these _fixture functions at the start of the file after any setup functions and parametrizers.

#### Act

Make the call to the function being tested in this portion of your tests.

#### Assert

As this project uses [bash_unit](https://github.com/bash-unit/bash_unit), its provided assertions will work in tests.  Consult its documentation for further details.

In addition to this, tests can use the assertions built into the [mocking system](src/testing/mock/mock.sh) and a group of included [custom assertions](src/testing/assertion).

##### Custom Assertions

| Assertion Function  | Related Capture Functions                               |
|---------------------|---------------------------------------------------------|
| assert_array_equals |                                                         |
| assert_array_length |                                                         |
| assert_is_array     |                                                         |
| assert_is_fn        |                                                         |
| assert_null         |                                                         |
| assert_not_null     |                                                         |
| assert_output       | `_capture.output`, `_capture.stdout`, `_capture.stderr` |
| assert_output_null  | `_capture.output`, `_capture.stdout`, `_capture.stderr` |
| assert_output_raw   | `_capture.output`, `_capture.stdout`, `_capture.stderr` |
| assert_rc           | `_capture.rc`                                           |
| assert_snapshot     |                                                         |

The `assert_output` family of assertions are widely used throughout the project.

##### Using Custom Assertions with Captures

Use the referenced [custom capture functions](src/testing/capture) to handle tasks such as:
- capturing stdout or stderr
- capturing return codes

Internally the capture functions assign values to `TEST_OUTPUT` and `TEST_RC`, which can be in turn tested with the `assert_output` and `assert_rc` functions respectively.

##### Assertion Line Breaks

Long assertion calls are generally broken into multiple lines with backslashes for readability:

```bash
test_example__long_assertion() {
  _capture.output command_being_tested

  assert_output \
    "very long string that was generated by command_being_tested"
}
```

### General Test Function Guidance

- Avoid conditionals inside tests.
- One assertion per test is preferred, testing one behaviour at a time.

If using [parametrization](#parametrizing-test-functions), separate the test function definition, and the call to the parametrizer function by exactly one blank line.

### Parametrizing Test Functions

Use parametrization whenever possible to reuse test code in a readable manner.
Parametrizers are used to vary conditions in the test, while reusing the underlying test code.

#### Using Parametrizer Functions

Create parametrizers at the top of the test file, between the setup functions, and the test functions.

Parametrizers should adhere to the following format:

```bash
@parametrize_with_condition_name() {
  # $1: the test function being parametrized

  @parametrize
    "${1}"
    "TEST_VARIABLE_1;TEST_VARIABLE_2"
    "scenario_name;value1;value2;"
    "null_scenarios;;;"
}
```

These parametrizer functions then call tests with a `@vary` tag to mutate the condition in the test.

```bash
@parametrize_with_condition_name
  test_target_function_name__@vary__expected_resul
```

At run time the @vary tag is replaced with the scenario name of each scenario in the parametrizer, and the variables in the parametrizer are set and passed to the test.

The variables created by the parametrizer should be prefixed with `TEST_` unless they are overriding existing values of some sort.

These parametrizer calls should be separated from the test definition by a single blank line for readability.

##### Null Values in Parametrizers

It's important to understand how to pass null values to a parametrizer.  The parametrizer will look for a terminating semicolon to define each value.  An additional ';' tells the parametrizer that the last value is null.

```bash
@parametrize_with_example_of_null_values() {
  # $1: the test function being parametrized

  @parametrize
    "${1}"
    "TEST_VARIABLE_1;TEST_VARIABLE_2;TEST_VARIABLE_3"
    "all_values;value1;value2;value3"
    "first_null;;value2;value3"
    "second_null;value1;;value3"
    "third_null;value1;value2;;"
    "all_nulls;;;;"
}
```

##### Multiple Conditions in Parametrizers

If encoding multiple conditions in a parametrizer, separate the conditions in the scenario names by at least 2 underscores for readability.  Right justifying each condition is the preferred approach to creating scenario names and making the parametrizers readable.

```bash
@parametrize_with_multiple_conditions() {
  # $1: the test function being parametrized

  @parametrize
    "${1}"
    "TEST_VARIABLE_1;TEST_VARIABLE_2"
    "switch_1_on___switch_2_on_;1;1"
    "switch_1_on___switch_2_off;1;0"
    "switch_1_off__switch_2_on_;0;1"
    "switch_1_off__switch_2_off;0;0"
}
```

This is a useful pattern for creating truth tables.

##### Combining Parametrizer Functions

It is also possible call test functions with multiple parametrizers.
This strategy is helpful when asserting different behaviours for subsets of conditions.
###### @parametrize.apply

If we were to create two different parametrizers one that mutates conditions that succeed and one that mutates conditions that fails we could then use either or both against our tests.

The `@parametrize.apply` function allows us to combine parametrizer functions this way, to use both parametrizers against a single test function.

It's important to note that the target test should have *two* `@vary` tags.  One will be replaced with the parametrizer name, and the other with the scenario name.

```bash
@parametrize.apply
  test_function__@vary__@vary__occurs_for_both_passing_and_failing
  @parametrize_with_success_conditions
  @parametrize_with_failure_conditions
```

###### @parametrize.compose

If we instead have many independent variables that we want to mutate, we can split these out into different parametrizers as well.  These independent variable mutations can then be applied to a test.

The `@parametrize.compose` function allows us to combine parametrizers to create a product of the two.

It's important to note that the target test should have *multiple* `@vary` tags.  Each will be replaced with a scenario from each parametrizer being used to create the product test.

```bash
@parametrize.compose
  test_function__@vary__@vary__@vary__combination_of_variables_side_effec
  @parametrize_with_condition_set_1
  @parametrize_with_condition_set_2
  @parametrize_with_condition_set_3
```

#### Test Behaviour

##### Silencing Unwanted Output

Don't pollute the console with unnecessary stderr or stdout messages.  If your test is generating output that is not relevant to your test, please direct it to /dev/null to keep the interface clean.

##### Using STDLIB

Where possible, leverage the functions inside stdlib itself to simplify your tests.

###### Avoid calls to `read`

Avoid using read directly if possible.

The stdlib provides excellent read replacement candidates such as:
- `stdlib.array.make.from_string`
- `stdlib.array.make.from_file`
- `assert_array_equals`
- `assert_snapshot`

Frequently `stdlib.array.make.from_string` is used to encode arrays in parametrizers with the separator `|`.  When storing encoded arrays in parametrizers this way, it's customary to name the variables in a `TEST_<description>_DEFINITION` style, to make it clear that the values are encoded arrays.

A complete parametrized test example:

```bash
@parametrize_with_condition_name() {
  # $1: the test function being parametrized

  @parametrize
    "${1}"
     "TEST_VARIABLE_1;TEST_VARIABLE_2_DEFINITION"
     "scenario_name;value1;variable-2-value1|variable2-value-2-variable-2-value-3;"
     "null_scenarios;;;"
}


test_example_@vary__reads_parametrizer_array_values() {
  local example_received_array=()
  local example_received_array_value

  stdlib.array.make.from_string example_received_array "|" "${TEST_VARIABLE_2_DEFINITION}"

  example

  for example_received_array_value in "${example_received_array[@]}"; do
    assert_not_null "${example_received_array_value}"
  done
}

@parametrize_with_condition_name
  test_example_@vary__reads_parametrizer_array_values
```

###### Avoid `test -f` / `test -e` / `test -d`

It's preferable to use the stdlib for these sorts of conditional tests.

[stdlib.io.path.query.is.sh](src/io/path/query/is.sh) provides a suite of tools for this job.
