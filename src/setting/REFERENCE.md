# STDLIB Setting Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.setting.colour.disable](#stdlibsettingcolourdisable)
* [stdlib.setting.colour.enable](#stdlibsettingcolourenable)
* [stdlib.setting.colour.state.disabled](#stdlibsettingcolourstatedisabled)
* [stdlib.setting.colour.state.enabled](#stdlibsettingcolourstateenabled)
* [stdlib.setting.colour.state.theme](#stdlibsettingcolourstatetheme)
* [stdlib.setting.theme.get_colour](#stdlibsettingthemeget_colour)
* [stdlib.setting.theme.load](#stdlibsettingthemeload)

### stdlib.setting.colour.disable

Disables terminal colours.

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.

### stdlib.setting.colour.enable

Enables terminal colours.
* STDLIB_COLOUR_SILENT_FALLBACK_BOOLEAN: Disables the error message on failure (default="0").

_Function has no arguments._

#### Exit codes

* **0**: If the operation succeeded.
* **1**: If the operation failed.

#### Output on stderr

* The error message if the operation fails.

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
