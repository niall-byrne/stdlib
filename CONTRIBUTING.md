# Contribution Guide

## General Setup Guidelines

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

## Documentation

To generate documentation, the library [shdoc](https://github.com/reconquest/shdoc) is being used.

All functions with names that are prefixed with **stdlib** inside files within the [src](./src) folder are to be documented.  There may be existing comments that document the arguments inside each function, they should be removed as part of the documentation process. They will look similar to "# $1: a description of this argument"

Please avoid documenting internal functions with double underscore `__` in their names.

### Required Fields

Please use capitalized proper sentences followed by a period as the content of each field.

Care should be taken to add comments that identify the following mandatory fields:
- @description
- @arg / @noargs
- @option (see [below](#global-variables))
- @set (if applicable)
- @exitcode (see [below](#exit-codes))
- @stdin (if applicable)
- @stdout (if applicable)
- @stderr (if applicable)

### Global Variables

Many of these functions consume global variables as "options" that modify their behaviour.

Please detail this with `@option` entries (if applicable)

### Exit Codes

<!-- vale off -->
In general the return codes should conform to:
- 0: operation succeeded
- 1: operation failed
- 126: An invalid argument was provided.
- 127: The wrong number of arguments was provided.
<!-- vale on -->
It should be possible to look at the code and decipher these return codes.
An entry for exit code 0 should ALWAYS be included for consistency.

If return codes are found that don't seem to conform to this pattern, please notify someone before proceeding further.

## Testing

There are two test runners to be aware of:
- the test runner [t](./dist/t) is a test runner meant for projects that are consuming stdlib, and should not be used for testing stdlib itself.
- the test runner [test.sh](./build/test.sh) is the one that should be used for testing stdlib.

The preferred way to run the tests is with [container.sh](./container.sh):
1. Build the test container first before running tests:
   - `./container.sh build`
2. Run the test suites themselves:
   - `./container.sh run build/test.sh src`
   - `./container.sh run build/test.sh src/logger`

If you are encountering TTY problems, try setting the environment variable TEST_CONTAINER_DISABLE_TTY to 1 before using the container script:
  - `TEST_CONTAINER_DISABLE_TTY=1 ./container.sh run build/test.sh src`

If you encounter docker permission problems the script has commands that are helpful:
  - `./container.sh docker_group` will add you to docker group which may resolve the problem
  - `./container.sh docker_permissions` will change the ownership of the docker socket which may also resolve the problem

If you cannot use docker it is also possible to run the tests with [test.sh](./build/test.sh) directly. This is the least preferred method as it provides no separation between the test environment and the host machine.

### File Names

Tests go in a testing folder next to the file being tested.
Each function being tested gets its own file, grouped together by a subfolder that is the name of the file being tested.

target.sh -> tests/target/test_target_function1.sh, tests/target/test_target_function1.sh

### Test Names

Each test name should contain the function name being tested, the condition being tested and the expected result:

- `test_target_function_name__condition__expected_result() {}`
- `test_target_function_name__condition_1__condition2__expected_result() {}`

### Test Contents

#### Assertions

Under the hood the project uses [bashunit](https://github.com/TypedDevs/bashunit), so it's assertions will work in tests, along with the assertions built into the [mocking system](src/testing/mock/mock.sh) and a group of included [custom assertions](src/testing/assertion).

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

#### Mocking

Use the [mocking framework](src/testing/mock/mock.sh) to create mocks in either the `setup`, or `setup_suite` test functions:

- `_mock.create my_new_mock`

It's also acceptable to create mocks in the test functions themselves if that is the required scope of the mock itself.

Use the mock object's builtin assertions to test each object's behaviour.  The assertions are typically broken into multiple lines for readability:

```bash
  my_mock.mock.assert_called_once_with \
    "1(argument1) 2(argument2) 3(argument3)"

  my_mock.mock.assert_calls_are \
    "1(call1-argument1) 2(call1-argument2) 3(call1-argument3)" \
    "1(call2-argument1) 2(call2-argument2) 3(call2-argument3)"
```

Be sure to refer to the [documentation](src/testing/mock/mock.sh) on the mock object's behaviour and to see the complete list of available assertions.

#### Test Layout

##### Local Variables

`local` variable definitions all go at the top of the function definition, separated from the rest of the test function by a blank line.

Avoid using `local -a` and instead define with an empty array:
- avoid: `local -a variable_name`
- instead: `local variable_name=()`

(Production code uses `builtin local -a` and differs from this testing requirement.)

##### AAA Testing Methodology

Please follow the Arrange, Act, Assert testing methodology, separated these three steps by at least one blank line in the test.

You may wish to create `_fixture_<name>` functions to do setup or mocking to reuse test code.
Place these _fixture functions at the start of the file after any setup functions and parametrizers.

Do not include comment to declare each Arrange, Act or Assert section.  Please just use a single blank line to separate these 3 stages from each other.

##### Important Details to Remember

- Avoid conditionals inside tests.
- One assertion per test is preferred, testing one behaviour at a time.

If using [parametrization](#parametrization), separate the test function definition, and the call to the parametrizer function by exactly one blank line.

#### Parametrization

Use parametrization whenever possible to reuse test code in a readable manner.
Parametrizers are used to vary conditions in the test, while reusing the underlying test code.

##### Parametrizer Functions

Create parametrizers at the top of the test file, between the setup functions, and the test functions.

Parametrizers should adhere to the following format:

```bash
@parametrize_with_condition_name() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_1;TEST_VARIABLE_2" \
    "scenario_name;value1;value2;" \
    "null_scenarios;;;"
}
```

These parametrizer functions then call tests with a `@vary` tag to mutate the condition in the test.

```bash
    @parametrize_with_condition_name \
        test_target_function_name__@vary__expected_result
```

At run time the @vary tag is replaced with the scenario name of each scenario in the parametrizer, and the variables in the parametrizer are set and passed to the test.

The variables created by the parametrizer should be prefixed with `TEST_` unless they are overriding existing values of some sort.

These parametrizer calls should be separated from the test definition by a single blank line for readability.

##### Null Values in Parametrizers

It's important to understand how to pass null values to a parametrizer.  The parametrizer will look for a terminating semicolon to define each value.  An additional ';' tells the parametrizer that the last value is null.

```bash
@parametrize_with_example_of_null_values() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_1;TEST_VARIABLE_2;TEST_VARIABLE_3" \
    "all_values;value1;value2;value3" \
    "first_null;;value2;value3" \
    "second_null;value1;;value3" \
    "third_null;value1;value2;;" \
    "all_nulls;;;;"
}
```

##### Multiple Conditions in Parametrizers

If encoding multiple conditions in a parametrizer, separate the conditions in the scenario names by at least 2 underscores for readability.  Right justifying each condition is the preferred approach to creating scenario names and making the parametrizers readable
.

```bash
@parametrize_with_multiple_conditions() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_1;TEST_VARIABLE_2" \
    "switch_1_on___switch_2_on_;1;1" \
    "switch_1_on___switch_2_off;1;0" \
    "switch_1_off__switch_2_on_;0;1" \
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
@parametrize.apply \
    test_function__@vary__@vary__occurs_for_both_passing_and_failing \
    @parametrize_with_success_conditions \
    @parametrize_with_failure_conditions
```

###### @parametrize.compose

If we instead have many independent variables that we want to mutate, we can split these out into different parametrizers as well.  These independent variable mutations can then be applied to a test.

The `@parametrize.compose` function allows us to combine parametrizers to create a product of the two.

It's important to note that the target test should have *multiple* `@vary` tags.  Each will be replaced with a scenario from each parametrizer being used to create the product test.

```bash
@parametrize.compose \
    test_function__@vary__@vary__@vary__combination_of_variables_side_effect \
    @parametrize_with_condition_set_1 \
    @parametrize_with_condition_set_2 \
    @parametrize_with_condition_set_3
```

#### Test Behaviour

##### Silencing Unwanted Output

Don't pollute the console with unnecessary stderr or stdout messages.  If your test is generating output that is not relevant to your test, please direct it to /dev/null to keep the interface clean.

##### Using STDLIB

###### read

Avoid using read directly if possible.

The stdlib provides excellent read replacement candidates such as:
- stdlib.array.make.from_string
- stdlib.array.make.from_file
- assert_array_equals
- assert_snapshot

Frequently `stdlib.array.make.from_string` is used to encode arrays in parametrizers with the separator `|`.  When storing encoded arrays in parametrizers this way, it's customary to name the variables in a `TEST_<description>_DEFINITION` style, to make it clear that the values are encoded arrays.

###### Test Example using STDLIB

```bash
@parametrize_with_condition_name() {
  # $1: the test function being parametrized

  @parametrize \
    "${1}" \
    "TEST_VARIABLE_1;TEST_VARIABLE_2_DEFINITION" \
    "scenario_name;value1;variable-2-value1|variable2-value-2-variable-2-value-3;" \
    "null_scenarios;;;"
}

test_example_@vary__reads_parametrizer_array_values() {
  local example_received_array=()
  local example_received_array_value

  stdlib.array.make.from_string example_received_array "|" "${TEST_VARIABLE_2_DEFINITION}"

  for example_received_array_value in "${example_received_array[@]}"; do
    assert_not_null "${example_received_array_value}"
  done
}

@parametrize_with_condition_name \
  test_example_@vary__reads_parametrizer_array_values

```

###### Migrating away from `test -f` / `test -e` / `test -d`

It's preferable to use the stdlib for these sorts of conditional tests.

[stdlib.io.path.query.is.sh](src/io/path/query/is.sh) provides a suite of tools for this job.
