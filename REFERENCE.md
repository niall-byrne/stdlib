# STDLIB Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.array.assert.is_array](#stdlibarrayassertis_array)
* [stdlib.array.assert.is_contains](#stdlibarrayassertis_contains)
* [stdlib.array.assert.is_empty](#stdlibarrayassertis_empty)
* [stdlib.array.assert.is_equal](#stdlibarrayassertis_equal)
* [stdlib.array.assert.not_array](#stdlibarrayassertnot_array)
* [stdlib.array.assert.not_contains](#stdlibarrayassertnot_contains)
* [stdlib.array.assert.not_empty](#stdlibarrayassertnot_empty)
* [stdlib.array.assert.not_equal](#stdlibarrayassertnot_equal)
* [stdlib.array.get.last](#stdlibarraygetlast)
* [stdlib.array.get.length](#stdlibarraygetlength)
* [stdlib.array.get.longest](#stdlibarraygetlongest)
* [stdlib.array.get.shortest](#stdlibarraygetshortest)
* [stdlib.array.make.from_file](#stdlibarraymakefrom_file)
* [stdlib.array.make.from_string](#stdlibarraymakefrom_string)
* [stdlib.array.make.from_string_n](#stdlibarraymakefrom_string_n)
* [stdlib.array.map.format](#stdlibarraymapformat)
* [stdlib.array.map.fn](#stdlibarraymapfn)
* [stdlib.array.mutate.append](#stdlibarraymutateappend)
* [stdlib.array.mutate.fn](#stdlibarraymutatefn)
* [stdlib.array.mutate.filter](#stdlibarraymutatefilter)
* [stdlib.array.mutate.format](#stdlibarraymutateformat)
* [stdlib.array.mutate.insert](#stdlibarraymutateinsert)
* [stdlib.array.mutate.prepend](#stdlibarraymutateprepend)
* [stdlib.array.mutate.remove](#stdlibarraymutateremove)
* [stdlib.array.mutate.reverse](#stdlibarraymutatereverse)
* [stdlib.array.query.is_contains](#stdlibarrayqueryis_contains)
* [stdlib.array.query.is_equal](#stdlibarrayqueryis_equal)
* [stdlib.array.query.is_array](#stdlibarrayqueryis_array)
* [stdlib.array.query.is_empty](#stdlibarrayqueryis_empty)
* [stdlib.fn.args.require](#stdlibfnargsrequire)
* [stdlib.fn.assert.is_builtin](#stdlibfnassertis_builtin)
* [stdlib.fn.assert.is_fn](#stdlibfnassertis_fn)
* [stdlib.fn.assert.is_valid_name](#stdlibfnassertis_valid_name)
* [stdlib.fn.assert.not_builtin](#stdlibfnassertnot_builtin)
* [stdlib.fn.assert.not_fn](#stdlibfnassertnot_fn)
* [stdlib.fn.derive.clone](#stdlibfnderiveclone)
* [stdlib.fn.derive.pipeable](#stdlibfnderivepipeable)
* [stdlib.fn.derive.var](#stdlibfnderivevar)
* [stdlib.fn.query.is_builtin](#stdlibfnqueryis_builtin)
* [stdlib.fn.query.is_fn](#stdlibfnqueryis_fn)
* [stdlib.fn.query.is_valid_name](#stdlibfnqueryis_valid_name)
* [stdlib.io.path.assert.is_exists](#stdlibiopathassertis_exists)
* [stdlib.io.path.assert.is_file](#stdlibiopathassertis_file)
* [stdlib.io.path.assert.is_folder](#stdlibiopathassertis_folder)
* [stdlib.io.path.assert.not_exists](#stdlibiopathassertnot_exists)
* [stdlib.io.path.query.is_exists](#stdlibiopathqueryis_exists)
* [stdlib.io.path.query.is_file](#stdlibiopathqueryis_file)
* [stdlib.io.path.query.is_folder](#stdlibiopathqueryis_folder)
* [stdlib.io.stdin.confirmation](#stdlibiostdinconfirmation)
* [stdlib.io.stdin.pause](#stdlibiostdinpause)
* [stdlib.io.stdin.prompt](#stdlibiostdinprompt)
* [stdlib.logger.error_pipe](#stdlibloggererror_pipe)
* [stdlib.logger.warning_pipe](#stdlibloggerwarning_pipe)
* [stdlib.logger.info_pipe](#stdlibloggerinfo_pipe)
* [stdlib.logger.success_pipe](#stdlibloggersuccess_pipe)
* [stdlib.logger.notice_pipe](#stdlibloggernotice_pipe)
* [stdlib.logger.traceback](#stdlibloggertraceback)
* [stdlib.logger.error](#stdlibloggererror)
* [stdlib.logger.warning](#stdlibloggerwarning)
* [stdlib.logger.info](#stdlibloggerinfo)
* [stdlib.logger.notice](#stdlibloggernotice)
* [stdlib.logger.success](#stdlibloggersuccess)
* [stdlib.security.get.euid](#stdlibsecuritygeteuid)
* [stdlib.security.get.gid](#stdlibsecuritygetgid)
* [stdlib.security.get.uid](#stdlibsecuritygetuid)
* [stdlib.security.get.unused_uid](#stdlibsecuritygetunused_uid)
* [stdlib.security.path.assert.has_group](#stdlibsecuritypathasserthas_group)
* [stdlib.security.path.assert.has_owner](#stdlibsecuritypathasserthas_owner)
* [stdlib.security.path.assert.has_permissions](#stdlibsecuritypathasserthas_permissions)
* [stdlib.security.path.assert.is_secure](#stdlibsecuritypathassertis_secure)
* [stdlib.security.path.make.dir](#stdlibsecuritypathmakedir)
* [stdlib.security.path.make.file](#stdlibsecuritypathmakefile)
* [stdlib.security.path.query.has_group](#stdlibsecuritypathqueryhas_group)
* [stdlib.security.path.query.has_owner](#stdlibsecuritypathqueryhas_owner)
* [stdlib.security.path.query.has_permissions](#stdlibsecuritypathqueryhas_permissions)
* [stdlib.security.path.query.is_secure](#stdlibsecuritypathqueryis_secure)
* [stdlib.security.path.secure](#stdlibsecuritypathsecure)
* [stdlib.security.user.assert.is_root](#stdlibsecurityuserassertis_root)
* [stdlib.security.user.query.is_root](#stdlibsecurityuserqueryis_root)
* [stdlib.setting.colour.enable](#stdlibsettingcolourenable)
* [stdlib.setting.colour.disable](#stdlibsettingcolourdisable)
* [stdlib.setting.colour.state.disabled](#stdlibsettingcolourstatedisabled)
* [stdlib.setting.colour.state.enabled](#stdlibsettingcolourstateenabled)
* [stdlib.setting.colour.state.theme](#stdlibsettingcolourstatetheme)
* [stdlib.setting.theme.get_colour](#stdlibsettingthemeget_colour)
* [stdlib.setting.theme.load](#stdlibsettingthemeload)
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
* [stdlib.string.colour_n](#stdlibstringcolour_n)
* [stdlib.string.colour](#stdlibstringcolour)
* [stdlib.string.colour_n_pipe](#stdlibstringcolour_n_pipe)
* [stdlib.string.colour_var](#stdlibstringcolour_var)
* [stdlib.string.colour_pipe](#stdlibstringcolour_pipe)
* [stdlib.string.colour.substring_pipe](#stdlibstringcoloursubstring_pipe)
* [stdlib.string.colour.substring_var](#stdlibstringcoloursubstring_var)
* [stdlib.string.colour.substrings_pipe](#stdlibstringcoloursubstrings_pipe)
* [stdlib.string.colour.substrings_var](#stdlibstringcoloursubstrings_var)
* [stdlib.string.colour.substring](#stdlibstringcoloursubstring)
* [stdlib.string.colour.substrings](#stdlibstringcoloursubstrings)
* [stdlib.string.justify.left](#stdlibstringjustifyleft)
* [stdlib.string.justify.left_pipe](#stdlibstringjustifyleft_pipe)
* [stdlib.string.justify.left_var](#stdlibstringjustifyleft_var)
* [stdlib.string.justify.right](#stdlibstringjustifyright)
* [stdlib.string.justify.right_pipe](#stdlibstringjustifyright_pipe)
* [stdlib.string.justify.right_var](#stdlibstringjustifyright_var)
* [stdlib.string.lines.join](#stdlibstringlinesjoin)
* [stdlib.string.lines.join_pipe](#stdlibstringlinesjoin_pipe)
* [stdlib.string.lines.join_var](#stdlibstringlinesjoin_var)
* [stdlib.string.lines.map.format](#stdlibstringlinesmapformat)
* [stdlib.string.lines.map.format_pipe](#stdlibstringlinesmapformat_pipe)
* [stdlib.string.lines.map.format_var](#stdlibstringlinesmapformat_var)
* [stdlib.string.lines.map.fn](#stdlibstringlinesmapfn)
* [stdlib.string.lines.map.fn_pipe](#stdlibstringlinesmapfn_pipe)
* [stdlib.string.lines.map.fn_var](#stdlibstringlinesmapfn_var)
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
* [stdlib.trap.create.clean_up_fn](#stdlibtrapcreateclean_up_fn)
* [stdlib.trap.create.handler](#stdlibtrapcreatehandler)
* [stdlib.trap.fn.clean_up_on_exit](#stdlibtrapfnclean_up_on_exit)
* [stdlib.trap.handler.err.fn](#stdlibtraphandlererrfn)
* [stdlib.trap.handler.err.fn.register](#stdlibtraphandlererrfnregister)
* [stdlib.trap.handler.exit.fn](#stdlibtraphandlerexitfn)
* [stdlib.trap.handler.exit.fn.register](#stdlibtraphandlerexitfnregister)
* [stdlib.var.assert.is_valid_name](#stdlibvarassertis_valid_name)
* [stdlib.var.query.is_valid_name](#stdlibvarqueryis_valid_name)

### stdlib.array.assert.is_array

Asserts that a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_contains

Asserts that an array contains a value.

#### Arguments

* **$1** (string): The value to assert is present.
* **$2** (string): The name of the array.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_empty

Asserts that an array is empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.is_equal

Asserts that two arrays are equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_array

Asserts that a variable is not an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_contains

Asserts that an array does not contain a value.

#### Arguments

* **$1** (string): The value to assert is NOT present.
* **$2** (string): The name of the array.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_empty

Asserts that an array is not empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.assert.not_equal

Asserts that two arrays are not equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.array.get.last

Gets the last element of an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (string): The last element of the array.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The last element of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.length

Gets the length of an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the array.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.longest

Gets the length of the longest element in an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the longest element.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the longest element.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.get.shortest

Gets the length of the shortest element in an array.

#### Arguments

* **$1** (string): The name of the array.

#### Variables set

* **STDLIB_ARRAY_BUFFER** (integer): The length of the shortest element.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The length of the shortest element.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_file

Creates an array from a file using a separator.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (string): The separator character.
* **$3** (string): The path to the source file.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_string

Creates an array from a string using a separator.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (string): The separator character.
* **$3** (string): The source string.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.make.from_string_n

Creates an array by repeating a string a specified number of times.

#### Arguments

* **$1** (string): The name of the array to create.
* **$2** (integer): The number of times to repeat the string.
* **$3** (string): The string to repeat.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.map.format

Maps a format string over each element of an array and prints the result.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The name of the array to process.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The formatted elements of the array.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.map.fn

Maps a function over each element of an array.

#### Arguments

* **$1** (string): The name of the function to apply to each element.
* **$2** (string): The name of the array to process.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* Any output from the mapped function.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.append

Appends a string to each element of an array.

#### Arguments

* **$1** (string): The string to append.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.fn

Replaces each element of an array with the output of a function.

#### Arguments

* **$1** (string): The name of the function to apply to each element.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.filter

Filters an array in place using a filter function.

#### Arguments

* **$1** (string): The name of the filter function.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.format

Replaces each element of an array with a formatted version.

#### Arguments

* **$1** (string): A valid printf format string.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.insert

Inserts a string into an array at a specified index.

#### Arguments

* **$1** (string): The string to insert.
* **$2** (integer): The index at which to insert the string.
* **$3** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.prepend

Prepends a string to each element of an array.

#### Arguments

* **$1** (string): The string to prepend.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.remove

Removes an element from an array at a specified index.

#### Arguments

* **$1** (integer): The index of the element to remove.
* **$2** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.mutate.reverse

Reverses the elements of an array in place.

#### Arguments

* **$1** (string): The name of the array to modify.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_contains

Checks if an array contains a value.

#### Arguments

* **$1** (string): The value to query for.
* **$2** (string): The name of the array to query.

#### Exit codes

* **0**: If the array contains the value.
* **1**: If the array does not contain the value.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_equal

Checks if two arrays are equal.

#### Arguments

* **$1** (string): The name of the first array to compare.
* **$2** (string): The name of the second array to compare.

#### Exit codes

* **0**: If the arrays are equal.
* **1**: If the arrays are not equal.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_array

Checks if a variable is an array.

#### Arguments

* **$1** (string): The name of the variable to check.

#### Exit codes

* **0**: If the variable is an array.
* **1**: If the variable is not an array.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.array.query.is_empty

Checks if an array is empty.

#### Arguments

* **$1** (string): The name of the array to check.

#### Exit codes

* **0**: If the array is empty.
* **1**: If the array is not empty.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.args.require

Validates the presence and number of arguments for a function.
* STDLIB_ARGS_CALLER_FN_NAME: A string presented as the name of the calling function in logging messages (default="${FUNCNAME[1]}").
* STDLIB_ARGS_NULL_SAFE_ARRAY: An array of argument indexes that are null safe, meaning they can be empty values (default=()).

#### Arguments

* **$1** (integer): The number of required arguments.
* **$2** (integer): The number of optional arguments.
* **...** (array): The list of argument values to check.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.assert.is_builtin

Asserts that a command is a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.is_fn

Asserts that a function name is defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.is_valid_name

Asserts that a string is a valid function name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.not_builtin

Asserts that a command is not a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.assert.not_fn

Asserts that a function name is not defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.fn.derive.clone

Clones an existing function to a new name.

#### Arguments

* **$1** (string): The name of the function to clone.
* **$2** (string): The name for the new function clone.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The cloned function definition.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.derive.pipeable

Creates a pipeable version of an existing function.
* STDLIB_PIPEABLE_STDIN_SOURCE_SPECIFIER: A string used to specify the position of stdin in the arguments (default='-').

#### Arguments

* **$1** (string): The name of the function to make pipeable.
* **$2** (integer): The number of arguments the function requires.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.derive.var

Creates a version of a function that reads from and writes to a variable.

#### Arguments

* **$1** (string): The name of the source function.
* **$2** (string): (optional, default="${1}_var") The name of the new target function.
* **$3** (integer): (optional, default=-1) The argument index for the variable's existing value.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.fn.query.is_builtin

Checks if a command is a bash builtin.

#### Arguments

* **$1** (string): The command name to check.

#### Exit codes

* **0**: If the command is a builtin.
* **1**: If the command is not a builtin.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.fn.query.is_fn

Checks if a function name is defined.

#### Arguments

* **$1** (string): The function name to check.

#### Exit codes

* **0**: If the function is defined.
* **1**: If the function is not defined.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.fn.query.is_valid_name

Checks if a string is a valid function name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the name is valid.
* **1**: If the name is invalid.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.path.assert.is_exists

Asserts that a path exists.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.is_file

Asserts that a path is a file.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.is_folder

Asserts that a path is a folder.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.assert.not_exists

Asserts that a path does not exist.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.io.path.query.is_exists

Checks if a path exists.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path exists.
* **1**: If the path does not exist.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.path.query.is_file

Checks if a path is a file.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path is a file.
* **1**: If the path is not a file.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.path.query.is_folder

Checks if a path is a folder.

#### Arguments

* **$1** (string): The path to check.

#### Exit codes

* **0**: If the path is a folder.
* **1**: If the path is not a folder.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.io.stdin.confirmation

Prompts the user for a confirmation (Y/n).

#### Arguments

* **$1** (string): (optional, default=STDIN_DEFAULT_CONFIRMATION_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the user confirmed with 'Y'.
* **1**: If the user declined with 'n'.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input character.

#### Output on stdout

* The prompt and a newline after input.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.stdin.pause

Pauses the script until the user presses a key.

#### Arguments

* **$1** (string): (optional, default=STDIN_DEFAULT_PAUSE_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input character.

#### Output on stdout

* The prompt.

#### Output on stderr

* The error message if the operation fails.

### stdlib.io.stdin.prompt

Prompts the user for a value and saves it to a variable.
* STDLIB_STDIN_PASSWORD_MASK_BOOLEAN: Indicates if the input should be masked, i.e. for passwords (default="0").

#### Arguments

* **$1** (string): The variable name to save the input to.
* **$2** (string): (optional, default=STDIN_DEFAULT_VALUE_PROMPT) The prompt to display.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Input on stdin

* The user input.

#### Output on stdout

* The prompt.

#### Output on stderr

* The error message if the operation fails.

### stdlib.logger.error_pipe

A derivative of stdlib.logger.error that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stderr

* The error message.

### stdlib.logger.warning_pipe

A derivative of stdlib.logger.warning that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stderr

* The warning message.

### stdlib.logger.info_pipe

A derivative of stdlib.logger.info that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The informational message.

### stdlib.logger.success_pipe

A derivative of stdlib.logger.success that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The success message.

### stdlib.logger.notice_pipe

A derivative of stdlib.logger.notice that can read from stdin.

#### Arguments

* **$1** (string): (optional, default="-") The message to log, by default this function reads from stdin.

#### Exit codes

* **0**: If the operation succeeded.

#### Input on stdin

* The message to log.

#### Output on stdout

* The notice message.

### stdlib.logger.traceback

Prints a traceback of the current function calls.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The traceback information.

### stdlib.logger.error

Logs an error message.
* STDLIB_LOGGING_MESSAGE_PREFIX: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_ERROR: The colour to use for the message (default="LIGHT_RED").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The error message.

### stdlib.logger.warning

Logs a warning message.
* STDLIB_LOGGING_MESSAGE_PREFIX: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_WARNING: The colour to use for the message (default="YELLOW").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stderr

* The warning message.

### stdlib.logger.info

Logs an informational message.
* STDLIB_LOGGING_MESSAGE_PREFIX: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_INFO: The colour to use for the message (default="WHITE").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The informational message.

### stdlib.logger.notice

Logs a notice message.
* STDLIB_LOGGING_MESSAGE_PREFIX: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_NOTICE: The colour to use for the message (default="GREY").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The notice message.

### stdlib.logger.success

Logs a success message.
* STDLIB_LOGGING_MESSAGE_PREFIX: A prefix identifying the calling function (default="${FUNCNAME[2]}").
* STDLIB_THEME_LOGGER_SUCCESS: The colour to use for the message (default="GREEN").

#### Arguments

* **$1** (string): The message to log.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The success message.

### stdlib.security.get.euid

Gets the effective user ID.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The effective user ID.

### stdlib.security.get.gid

Gets the group ID for a given group name.

#### Arguments

* **$1** (string): The group name.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The group ID.

### stdlib.security.get.uid

Gets the user ID for a given username.

#### Arguments

* **$1** (string): The username.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The user ID.

### stdlib.security.get.unused_uid

Gets the next available (unused) user ID.

_Function has no arguments._

#### Exit codes

* **0**: If an unused UID was found.
* **1**: If an unused UID was not found.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The unused user ID.

### stdlib.security.path.assert.has_group

Asserts that a path has the specified group ownership.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required group name.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The informational message if the assertion fails.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.security.path.assert.has_owner

Asserts that a path has the specified user ownership.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required user name.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The informational message if the assertion fails.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.security.path.assert.has_permissions

Asserts that a path has the specified octal permissions.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required octal permission value.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stdout

* The informational message if the assertion fails.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.security.path.assert.is_secure

Asserts that a filesystem path is secure by checking its owner, group, and permissions.

#### Arguments

* **$1** (string): The filesystem path to check.
* **$2** (string): The required owner name.
* **$3** (string): The required group name.
* **$4** (string): The required octal permission value.

#### Exit codes

* **0**: If the assertion succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.security.path.make.dir

Creates a directory and sets its owner, group, and permissions.

#### Arguments

* **$1** (string): The path to the directory to create.
* **$2** (string): The owner name to set.
* **$3** (string): The group name to set.
* **$4** (string): The octal permission value to set.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.security.path.make.file

Creates a file and sets its owner, group, and permissions.

#### Arguments

* **$1** (string): The path to the file to create.
* **$2** (string): The owner name to set.
* **$3** (string): The group name to set.
* **$4** (string): The octal permission value to set.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.security.path.query.has_group

Checks if a path has the specified group ownership.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required group name.

#### Exit codes

* **0**: If the path has the specified group ownership.
* **1**: If the path does not have the specified group ownership.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.security.path.query.has_owner

Checks if a path has the specified user ownership.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required user name.

#### Exit codes

* **0**: If the path has the specified user ownership.
* **1**: If the path does not have the specified user ownership.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.security.path.query.has_permissions

Checks if a path has the specified octal permissions.

#### Arguments

* **$1** (string): The path to check.
* **$2** (string): The required octal permission value.

#### Exit codes

* **0**: If the path has the specified permissions.
* **1**: If the path does not have the specified permissions.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

### stdlib.security.path.query.is_secure

Checks if a filesystem path is secure by checking its owner, group, and permissions.

#### Arguments

* **$1** (string): The filesystem path to check.
* **$2** (string): The required owner name.
* **$3** (string): The required group name.
* **$4** (string): The required octal permission value.

#### Exit codes

* **0**: If the path is secure.
* **1**: If the path is not secure.
* **127**: If the wrong number of arguments were provided.

### stdlib.security.path.secure

Secures a filesystem path by setting its owner, group, and permissions.

#### Arguments

* **$1** (string): The filesystem path to secure.
* **$2** (string): The owner name to set.
* **$3** (string): The group name to set.
* **$4** (string): The octal permission value to set.

#### Exit codes

* **0**: If the operation succeeded.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.security.user.assert.is_root

Asserts that the current user is the root user.

_Function has no arguments._

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.security.user.query.is_root

Checks if the current user is the root user.

_Function has no arguments._

#### Exit codes

* **0**: If the current user is root.
* **1**: If the current user is not root.
* **127**: If the wrong number of arguments were provided.

### stdlib.setting.colour.enable

Enables terminal colours.
* STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN: Disables the error message on failure (default="0").

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.

#### Output on stderr

* The error message if the operation fails.

### stdlib.setting.colour.disable

Disables terminal colours.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.setting.colour.state.disabled

Sets all colour variables to empty strings to disable colours.

_Function has no arguments._

#### Variables set

* **STDLIB_COLOUR_NC** (string): The no-colour escape sequence.
* **STDLIB_COLOUR_BLACK** (string): The black escape sequence.
* **STDLIB_COLOUR_RED** (string): The red escape sequence.
* **STDLIB_COLOUR_GREEN** (string): The green escape sequence.
* **STDLIB_COLOUR_YELLOW** (string): The yellow escape sequence.
* **STDLIB_COLOUR_BLUE** (string): The blue escape sequence.
* **STDLIB_COLOUR_PURPLE** (string): The purple escape sequence.
* **STDLIB_COLOUR_CYAN** (string): The cyan escape sequence.
* **STDLIB_COLOUR_WHITE** (string): The white escape sequence.
* **STDLIB_COLOUR_GREY** (string): The grey escape sequence.
* **STDLIB_COLOUR_LIGHT_RED** (string): The light red escape sequence.
* **STDLIB_COLOUR_LIGHT_GREEN** (string): The light green escape sequence.
* **STDLIB_COLOUR_LIGHT_YELLOW** (string): The light yellow escape sequence.
* **STDLIB_COLOUR_LIGHT_BLUE** (string): The light blue escape sequence.
* **STDLIB_COLOUR_LIGHT_PURPLE** (string): The light purple escape sequence.
* **STDLIB_COLOUR_LIGHT_CYAN** (string): The light cyan escape sequence.
* **STDLIB_COLOUR_LIGHT_WHITE** (string): The light white escape sequence.

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.setting.colour.state.enabled

Sets all colour variables to their respective escape sequences.

_Function has no arguments._

#### Variables set

* **STDLIB_COLOUR_NC** (string): The no-colour escape sequence.
* **STDLIB_COLOUR_BLACK** (string): The black escape sequence.
* **STDLIB_COLOUR_RED** (string): The red escape sequence.
* **STDLIB_COLOUR_GREEN** (string): The green escape sequence.
* **STDLIB_COLOUR_YELLOW** (string): The yellow escape sequence.
* **STDLIB_COLOUR_BLUE** (string): The blue escape sequence.
* **STDLIB_COLOUR_PURPLE** (string): The purple escape sequence.
* **STDLIB_COLOUR_CYAN** (string): The cyan escape sequence.
* **STDLIB_COLOUR_WHITE** (string): The white escape sequence.
* **STDLIB_COLOUR_GREY** (string): The grey escape sequence.
* **STDLIB_COLOUR_LIGHT_RED** (string): The light red escape sequence.
* **STDLIB_COLOUR_LIGHT_GREEN** (string): The light green escape sequence.
* **STDLIB_COLOUR_LIGHT_YELLOW** (string): The light yellow escape sequence.
* **STDLIB_COLOUR_LIGHT_BLUE** (string): The light blue escape sequence.
* **STDLIB_COLOUR_LIGHT_PURPLE** (string): The light purple escape sequence.
* **STDLIB_COLOUR_LIGHT_CYAN** (string): The light cyan escape sequence.
* **STDLIB_COLOUR_LIGHT_WHITE** (string): The light white escape sequence.

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.setting.colour.state.theme

Sets the default theme colours for the logger.

_Function has no arguments._

#### Variables set

* **STDLIB_THEME_LOGGER_ERROR** (string): The colour for error messages.
* **STDLIB_THEME_LOGGER_WARNING** (string): The colour for warning messages.
* **STDLIB_THEME_LOGGER_INFO** (string): The colour for info messages.
* **STDLIB_THEME_LOGGER_NOTICE** (string): The colour for notice messages.
* **STDLIB_THEME_LOGGER_SUCCESS** (string): The colour for success messages.

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.setting.theme.get_colour

Gets the name of a colour variable from the theme.

#### Arguments

* **$1** (string): The name of the colour.

#### Exit codes

* **0**: If the operation succeeded.

#### Output on stdout

* The name of the colour variable.

#### Output on stderr

* The error message if the operation fails.

### stdlib.setting.theme.load

Loads the theme colours.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

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

### stdlib.trap.create.clean_up_fn

Creates a cleanup function that removes filesystem objects.

#### Arguments

* **$1** (string): The name of the cleanup function to create.
* **$2** (string): The name of the array tracking filesystem objects to cleanup.
* **$3** (boolean): (optional, default="0") Whether to perform recursive deletes.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.trap.create.handler

Creates a trap handler function and a registration function.

#### Arguments

* **$1** (string): The name of the handler function to create.
* **$2** (string): The name of the array to store registered handler functions.

#### Exit codes

* **0**: If the operation succeeded.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the operation fails.

### stdlib.trap.fn.clean_up_on_exit

A handler function that removes files when called (by default this handler is registered to the exit signal).
* STDLIB_CLEANUP_FN_TARGETS_ARRAY: An array used to store file names targeted by the clean_up_on_exit function (default=()).

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.trap.handler.err.fn

A handler function that is invoked on an error trap.
* STDLIB_HANDLER_ERR_FN_ARRAY: An array containing a list of functions that are run on error (default=()).

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.trap.handler.err.fn.register

Adds a function to the error handler, which will be invoked (without args) during an error.

_Function has no arguments._

#### Variables set

* **STDLIB_HANDLER_ERR_FN_ARRAY** (array): An array containing a list of functions that are run on error.

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.trap.handler.exit.fn

A handler function that is invoked on an exit trap.
* STDLIB_HANDLER_EXIT_FN_ARRAY: An array containing a list of functions that are run on an exit call (default=("stdlib.trap.fn.clean_up_on_exit")).

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.trap.handler.exit.fn.register

Adds a function to the exit handler, which will be invoked (without args) during an exit call.

_Function has no arguments._

#### Variables set

* **STDLIB_HANDLER_EXIT_FN_ARRAY** (array): An array containing a list of functions that are run on an exit call.

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.var.assert.is_valid_name

Asserts that a string is a valid variable name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the assertion succeeded.
* **1**: If the assertion failed.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.

#### Output on stderr

* The error message if the assertion fails.

### stdlib.var.query.is_valid_name

Checks if a string is a valid variable name.

#### Arguments

* **$1** (string): The string to check.

#### Exit codes

* **0**: If the string is a valid variable name.
* **1**: If the string is not a valid variable name.
* **126**: If an invalid argument has been provided.
* **127**: If the wrong number of arguments were provided.
