# STDLIB String Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.string.assert.is_alpha](#stdlibstringassertis_alpha)
* [stdlib.string.assert.is_alpha_numeric](#stdlibstringassertis_alpha_numeric)
* [stdlib.string.assert.is_boolean](#stdlibstringassertis_boolean)
* [stdlib.string.assert.is_char](#stdlibstringassertis_char)
* [stdlib.string.assert.is_digit](#stdlibstringassertis_digit)
* [stdlib.string.assert.is_integer](#stdlibstringassertis_integer)
* [stdlib.string.assert.is_integer_with_range](#stdlibstringassertis_integer_with_range)
* [stdlib.string.assert.is_octal_permission](#stdlibstringassertis_octal_permission)
* [stdlib.string.assert.is_regex_match](#stdlibstringassertis_regex_match)
* [stdlib.string.assert.is_string](#stdlibstringassertis_string)
* [stdlib.string.assert.not_equal](#stdlibstringassertnot_equal)
* [stdlib.string.colour](#stdlibstringcolour)
* [stdlib.string.colour_n](#stdlibstringcolour_n)
* [stdlib.string.colour_n_pipe](#stdlibstringcolour_n_pipe)
* [stdlib.string.colour_pipe](#stdlibstringcolour_pipe)
* [stdlib.string.colour_var](#stdlibstringcolour_var)
* [stdlib.string.colour.substring](#stdlibstringcoloursubstring)
* [stdlib.string.colour.substring_pipe](#stdlibstringcoloursubstring_pipe)
* [stdlib.string.colour.substring_var](#stdlibstringcoloursubstring_var)
* [stdlib.string.colour.substrings](#stdlibstringcoloursubstrings)
* [stdlib.string.colour.substrings_pipe](#stdlibstringcoloursubstrings_pipe)
* [stdlib.string.colour.substrings_var](#stdlibstringcoloursubstrings_var)
* [stdlib.string.justify.left](#stdlibstringjustifyleft)
* [stdlib.string.justify.left_pipe](#stdlibstringjustifyleft_pipe)
* [stdlib.string.justify.left_var](#stdlibstringjustifyleft_var)
* [stdlib.string.justify.right](#stdlibstringjustifyright)
* [stdlib.string.justify.right_pipe](#stdlibstringjustifyright_pipe)
* [stdlib.string.justify.right_var](#stdlibstringjustifyright_var)
* [stdlib.string.lines.join](#stdlibstringlinesjoin)
* [stdlib.string.lines.join_pipe](#stdlibstringlinesjoin_pipe)
* [stdlib.string.lines.join_var](#stdlibstringlinesjoin_var)
* [stdlib.string.lines.map.fn](#stdlibstringlinesmapfn)
* [stdlib.string.lines.map.fn_pipe](#stdlibstringlinesmapfn_pipe)
* [stdlib.string.lines.map.fn_var](#stdlibstringlinesmapfn_var)
* [stdlib.string.lines.map.format](#stdlibstringlinesmapformat)
* [stdlib.string.lines.map.format_pipe](#stdlibstringlinesmapformat_pipe)
* [stdlib.string.lines.map.format_var](#stdlibstringlinesmapformat_var)
* [stdlib.string.pad.left](#stdlibstringpadleft)
* [stdlib.string.pad.left_pipe](#stdlibstringpadleft_pipe)
* [stdlib.string.pad.left_var](#stdlibstringpadleft_var)
* [stdlib.string.pad.right](#stdlibstringpadright)
* [stdlib.string.pad.right_pipe](#stdlibstringpadright_pipe)
* [stdlib.string.pad.right_var](#stdlibstringpadright_var)
* [stdlib.string.query.has_char_n](#stdlibstringqueryhas_char_n)
* [stdlib.string.query.has_substring](#stdlibstringqueryhas_substring)
* [stdlib.string.query.is_alpha](#stdlibstringqueryis_alpha)
* [stdlib.string.query.is_alpha_numeric](#stdlibstringqueryis_alpha_numeric)
* [stdlib.string.query.is_boolean](#stdlibstringqueryis_boolean)
* [stdlib.string.query.is_char](#stdlibstringqueryis_char)
* [stdlib.string.query.is_digit](#stdlibstringqueryis_digit)
* [stdlib.string.query.is_integer](#stdlibstringqueryis_integer)
* [stdlib.string.query.is_integer_with_range](#stdlibstringqueryis_integer_with_range)
* [stdlib.string.query.is_octal_permission](#stdlibstringqueryis_octal_permission)
* [stdlib.string.query.is_regex_match](#stdlibstringqueryis_regex_match)
* [stdlib.string.query.is_string](#stdlibstringqueryis_string)
* [stdlib.string.query.ends_with](#stdlibstringqueryends_with)
* [stdlib.string.query.first_char_is](#stdlibstringqueryfirst_char_is)
* [stdlib.string.query.last_char_is](#stdlibstringquerylast_char_is)
* [stdlib.string.query.starts_with](#stdlibstringquerystarts_with)
* [stdlib.string.trim.left](#stdlibstringtrimleft)
* [stdlib.string.trim.left_pipe](#stdlibstringtrimleft_pipe)
* [stdlib.string.trim.left_var](#stdlibstringtrimleft_var)
* [stdlib.string.trim.right](#stdlibstringtrimright)
* [stdlib.string.trim.right_pipe](#stdlibstringtrimright_pipe)
* [stdlib.string.trim.right_var](#stdlibstringtrimright_var)
* [stdlib.string.wrap](#stdlibstringwrap)
* [stdlib.string.wrap_pipe](#stdlibstringwrap_pipe)

### stdlib.string.assert.is_alpha

Asserts that a string contains only alphabetic characters.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_alpha_numeric

Asserts that a string contains only alphanumeric characters.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_boolean

Asserts that a string is a boolean (0 or 1).

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_char

Asserts that a string is a single character.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_digit

Asserts that a string contains only digits.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_integer

Asserts that a string is an integer.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_integer_with_range

Asserts that a string is an integer within a specified range.

#### Arguments

* **$1** (integer): The range start point.
* **$2** (integer): The range end point.
* **$3** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_octal_permission

Asserts that a string is a valid octal permission (3 or 4 digits).

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_regex_match

Asserts that a string matches a regular expression.

#### Arguments

* **$1** (string): The regular expression to use.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.is_string

Asserts that a value is a non-empty string.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.assert.not_equal

Asserts that two strings are not equal.

#### Arguments

* **$1** (string): The first string to compare.
* **$2** (string): The second string to compare.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.string.colour

Colours a string and prints it with a newline.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The string to colour.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The coloured string with a newline.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour_n

Colours a string and prints it without a newline.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The string to colour.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The coloured string without a newline.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour_n_pipe

A derivative of stdlib.string.colour_n that can read from stdin.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): (optional, default="-") The string to colour, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to colour.

#### Output on stdout

* The coloured string without a newline.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour_pipe

A derivative of stdlib.string.colour that can read from stdin.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): (optional, default="-") The string to colour, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to colour.

#### Output on stdout

* The coloured string with a newline.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour_var

A derivative of stdlib.string.colour_n that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substring

Colours the first occurrence of a substring in a string.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): The source string.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The string with the first occurrence of the substring coloured.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substring_pipe

A derivative of stdlib.string.colour.substring that can read from stdin.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): (optional, default="-") The source string, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The source string.

#### Output on stdout

* The string with the first occurrence of the substring coloured.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substring_var

A derivative of stdlib.string.colour.substring that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substrings

Colours all occurrences of a substring in a string.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): The source string.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The string with all occurrences of the substring coloured.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substrings_pipe

A derivative of stdlib.string.colour.substrings that can read from stdin.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): (optional, default="-") The source string, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The source string.

#### Output on stdout

* The string with all occurrences of the substring coloured.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.colour.substrings_var

A derivative of stdlib.string.colour.substrings that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the colour to use.
* **$2** (string): The substring to colour.
* **$3** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.left

Left-justifies a string to a specified width.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): The string to justify.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The left-justified string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.left_pipe

A derivative of stdlib.string.justify.left that can read from stdin.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): (optional, default="-") The string to justify, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to justify.

#### Output on stdout

* The left-justified string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.left_var

A derivative of stdlib.string.justify.left that can read from and write to a variable.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.right

Right-justifies a string to a specified width.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): The string to justify.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The right-justified string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.right_pipe

A derivative of stdlib.string.justify.right that can read from stdin.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): (optional, default="-") The string to justify, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to justify.

#### Output on stdout

* The right-justified string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.justify.right_var

A derivative of stdlib.string.justify.right that can read from and write to a variable.

#### Arguments

* **$1** (integer): The column width to justify to.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.join

Joins lines in a string by removing a delimiter.
* STDLIB_LINE_BREAK_DELIMITER: A line break char sequence which is replaced to join the string (default=$'\n').

#### Arguments

* **$1** (string): The string to process.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The joined string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.join_pipe

A derivative of stdlib.string.lines.join that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The string to process, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to process.

#### Output on stdout

* The joined string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.join_var

A derivative of stdlib.string.lines.join that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.fn

Maps a function over each line of a string.
* STDLIB_LINE_BREAK_DELIMITER: A line break char sequence to split the string with for processing (default=$'\n').

#### Arguments

* **$1** (string): The name of the function to apply to each line.
* **$2** (string): The input string to process.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The mapped lines.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.fn_pipe

A derivative of stdlib.string.lines.map.fn that can read from stdin.

#### Arguments

* **$1** (string): The name of the function to apply to each line.
* **$2** (string): (optional, default="-") The input string to process, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The input string to process.

#### Output on stdout

* The mapped lines.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.fn_var

A derivative of stdlib.string.lines.map.fn that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the function to apply to each line.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.format

Maps a format string over each line of a string.
* STDLIB_LINE_BREAK_DELIMITER: A line break char sequence to split the string with for processing (default=$'\n').

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The input string to process.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The formatted lines.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.format_pipe

A derivative of stdlib.string.lines.map.format that can read from stdin.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): (optional, default="-") The input string to process, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The input string to process.

#### Output on stdout

* The formatted lines.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.lines.map.format_var

A derivative of stdlib.string.lines.map.format that can read from and write to a variable.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.left

Pads a string on the left with a specified number of spaces.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): The string to pad.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The padded string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.left_pipe

A derivative of stdlib.string.pad.left that can read from stdin.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): (optional, default="-") The string to pad, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to pad.

#### Output on stdout

* The padded string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.left_var

A derivative of stdlib.string.pad.left that can read from and write to a variable.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.right

Pads a string on the right with a specified number of spaces.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): The string to pad.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The padded string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.right_pipe

A derivative of stdlib.string.pad.right that can read from stdin.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): (optional, default="-") The string to pad, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to pad.

#### Output on stdout

* The padded string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.pad.right_var

A derivative of stdlib.string.pad.right that can read from and write to a variable.

#### Arguments

* **$1** (integer): The number of spaces to pad with.
* **$2** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.query.has_char_n

Checks if a string has a specific character at a specific index.

#### Arguments

* **$1** (string): The character to check for.
* **$2** (integer): The index to check at.
* **$3** (string): The string to check.

#### Exit codes

* **0**: If the character is at the index.
* **1**: If the character is not at the index.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.has_substring

Checks if a string contains a substring.

#### Arguments

* **$1** (string): The substring to check for.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the string contains the substring.
* **1**: If the string does not contain the substring.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_alpha

Checks if a string contains only alphabetic characters.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string contains only alphabetic characters.
* **1**: If the string contains non-alphabetic characters.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_alpha_numeric

Checks if a string contains only alphanumeric characters.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string contains only alphanumeric characters.
* **1**: If the string contains non-alphanumeric characters.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_boolean

Checks if a string is a boolean (0 or 1).

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is a boolean.
* **1**: If the string is not a boolean.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_char

Checks if a string is a single character.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is a single character.
* **1**: If the string is not a single character.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_digit

Checks if a string contains only digits.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string contains only digits.
* **1**: If the string contains non-digit characters.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_integer

Checks if a string is an integer.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is an integer.
* **1**: If the string is not an integer.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_integer_with_range

Checks if a string is an integer within a specified range.

#### Arguments

* **$1** (integer): The range start point.
* **$2** (integer): The range end point.
* **$3** (string): The string to check.

#### Exit codes

* **0**: If the string is an integer within the range.
* **1**: If the string is not an integer within the range.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_octal_permission

Checks if a string is a valid octal permission (3 or 4 digits).

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is a valid octal permission.
* **1**: If the string is not a valid octal permission.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_regex_match

Checks if a string matches a regular expression.

#### Arguments

* **$1** (string): The regular expression to use.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the string matches the regular expression.
* **1**: If the string does not match the regular expression.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.is_string

Checks if a value is a non-empty string.

#### Arguments

* **$1** (string): The value to check.

#### Exit codes

* **0**: If the value is a non-empty string.
* **1**: If the value is an empty string.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.ends_with

Checks if a string ends with a specified substring.

#### Arguments

* **$1** (string): The substring to check for.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the string ends with the substring.
* **1**: If the string does not end with the substring.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.first_char_is

Checks if the first character of a string is a specified character.

#### Arguments

* **$1** (string): The character to check for.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the first character matches.
* **1**: If the first character does not match.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.last_char_is

Checks if the last character of a string is a specified character.

#### Arguments

* **$1** (string): The character to check for.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the last character matches.
* **1**: If the last character does not match.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.query.starts_with

Checks if a string starts with a specified substring.

#### Arguments

* **$1** (string): The substring to check for.
* **$2** (string): The string to check.

#### Exit codes

* **0**: If the string starts with the substring.
* **1**: If the string does not start with the substring.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.string.trim.left

Trims leading whitespace from a string.

#### Arguments

* **$1** (string): The string to trim.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The trimmed string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.trim.left_pipe

A derivative of stdlib.string.trim.left that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The string to trim, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to trim.

#### Output on stdout

* The trimmed string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.trim.left_var

A derivative of stdlib.string.trim.left that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.trim.right

Trims trailing whitespace from a string.

#### Arguments

* **$1** (string): The string to trim.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The trimmed string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.trim.right_pipe

A derivative of stdlib.string.trim.right that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The string to trim, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The string to trim.

#### Output on stdout

* The trimmed string.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.trim.right_var

A derivative of stdlib.string.trim.right that can read from and write to a variable.

#### Arguments

* **$1** (string): The name of the variable to read from and write to.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.wrap

Wraps text to a specified width with padding.
* STDLIB_LINE_BREAK_FORCE_CHAR: A char that 'forces' a line break in the output text (default="*").
* STDLIB_WRAP_PREFIX: A string to insert when wrapping text (default="").

#### Arguments

* **$1** (integer): The left-side padding.
* **$2** (integer): The right-side wrap limit.
* **$3** (string): The text to wrap.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The wrapped text.

#### Output on stderr

* The error message if the operation fails.

### stdlib.string.wrap_pipe

A derivative of stdlib.string.wrap that can read from stdin.

#### Arguments

* **$1** (integer): The left-side padding.
* **$2** (integer): The right-side wrap limit.
* **$3** (string): (optional, default="-") The text to wrap, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The text to wrap.

#### Output on stdout

* The wrapped text.

#### Output on stderr

* The error message if the operation fails.
