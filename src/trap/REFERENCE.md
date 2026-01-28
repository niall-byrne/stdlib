# STDLIB Trap Function Reference

<!-- markdownlint-disable MD024 -->

## Index

* [stdlib.trap.create.cleanup_fn](#stdlibtrapcreatecleanup_fn)
* [stdlib.trap.create.handler](#stdlibtrapcreatehandler)
* [stdlib.trap.fn.cleanup_on_exit](#stdlibtrapfncleanup_on_exit)
* [stdlib.trap.handler.err.fn](#stdlibtraphandlererrfn)
* [stdlib.trap.handler.err.fn.register](#stdlibtraphandlererrfnregister)
* [stdlib.trap.handler.exit.fn](#stdlibtraphandlerexitfn)
* [stdlib.trap.handler.exit.fn.register](#stdlibtraphandlerexitfnregister)

### stdlib.trap.create.cleanup_fn

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

### stdlib.trap.fn.cleanup_on_exit

A handler function that removes files when called (by default this handler is registered to the exit signal).
* STDLIB_CLEANUP_FN_TARGETS_ARRAY: An array used to store file names targeted by the cleanup_on_exit function (default=()).

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
* STDLIB_HANDLER_EXIT_FN_ARRAY: An array containing a list of functions that are run on an exit call (default=("stdlib.trap.fn.cleanup_on_exit")).

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
