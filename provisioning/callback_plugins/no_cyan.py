# (c) 2015, Andrew Gaffney <andrew@agaffney.org>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# This file was modified by Christian Ward-Garrison <cwardgar@ucar.edu>.
# See the sibling README.md for details.

# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.plugins.callback.default import CallbackModule as CallbackModule_default

class CallbackModule(CallbackModule_default):

    CALLBACK_VERSION = 2.0
    CALLBACK_TYPE = 'stdout'
    CALLBACK_NAME = 'no_cyan'

    def __init__(self):
        self.super_ref = super(CallbackModule, self)
        self.super_ref.__init__()

        self.task = None
        self.task_name = None
        self.shown_title = False

    def v2_playbook_on_handler_task_start(self, task):
        self.super_ref.v2_playbook_on_handler_task_start(task)
        self.shown_title = True

    def v2_playbook_on_task_start(self, task, is_conditional):
        self.task = task
        # For some reason, if I try to do 'self.task.get_name()' later in display_task_banner(),
        # templating in tasks names will have broken, e.g. I get stuff like:
        # "Assert that Nexus process was started by user '{{ nexus_os_user }}'". However, if we get the name now,
        # it works. I have no idea why.
        self.task_name = task.get_name()
        self.shown_title = False

    def display_task_banner(self):
        if not self.shown_title:
            self._display.banner("TASK [%s]" % self.task_name.strip())
            if self._display.verbosity > 2:
                path = self.task.get_path()
                if path:
                    self._display.display("task path: %s" % path, color='dark gray')
            self.shown_title = True

    def v2_runner_on_failed(self, result, ignore_errors=False):
        self.display_task_banner()
        self.super_ref.v2_runner_on_failed(result, ignore_errors)

    def v2_runner_on_ok(self, result):
        if self.task.action != 'include' or self._display.verbosity > 0:
            self.display_task_banner()
            self.super_ref.v2_runner_on_ok(result)

    def v2_runner_on_unreachable(self, result):
        self.display_task_banner()
        self.super_ref.v2_runner_on_unreachable(result)

    def v2_runner_on_skipped(self, result):
        if self._display.verbosity > 0:
            self.display_task_banner()
            self.super_ref.v2_runner_on_skipped(result)

    def v2_playbook_on_include(self, included_file):
        if self._display.verbosity > 0:
            self.display_task_banner()
            self.super_ref.v2_playbook_on_include(included_file)

    def v2_runner_item_on_ok(self, result):
        if self.task.action != 'include' or self._display.verbosity > 0:
            self.display_task_banner()
            self.super_ref.v2_runner_item_on_ok(result)

    def v2_runner_item_on_skipped(self, result):
        if self._display.verbosity > 0:
            self.display_task_banner()
            self.super_ref.v2_runner_item_on_skipped(result)

    def v2_runner_item_on_failed(self, result):
        self.display_task_banner()
        self.super_ref.v2_runner_item_on_failed(result)
