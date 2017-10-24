# Callback plugins

`no_cyan.py` is a stdout callback plugin that suppresses the display of "include" tasks and "skipped" tasks.
Basically, all cyan text is omitted. Also, if the output of a task would have only been cyan (i.e. everything
is an include or a skip), then the task banner is omitted as well.

## Inclusion of third-party software

This project contains source code from Andrew Gaffney's ["actionalble" stdout callback plugin](
https://github.com/ansible/ansible/blob/v2.3.1.0-1/lib/ansible/plugins/callback/actionable.py).
It is GPLv3-licensed. A copy of the GPLv3 license can be found in `/licenses/third-party/agaffney/`.

### Details of use

`no_cyan.py` is derived from `actionable.py`. Changes include:

1. Fix template expansion not occurring in task names.
1. Also display tasks that return "ok".
1. Verbosity level one (i.e. "-v") disables this plugin, in effect.
