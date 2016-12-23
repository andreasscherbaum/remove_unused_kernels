
# Remove unused kernels

Remove unused Linux kernel packages to clean up disk space


## Description

Provide a list of unused kernel packages along with the proper 'remove' command for Debian/Ubuntu.

This excludes the currently running kernel, the newest installed kernel, and dependencies.

The output is suitable to run with backticks:

```
`./remove_unused_kernels.sh`
```
