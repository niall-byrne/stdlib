# STDLIB Security Function Reference

<!-- markdownlint-disable MD024 -->

## Index

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
