# ============================================================================
# FILE: session.py
# AUTHOR: Rafael Bodill <justRafi at gmail.com>
# License: MIT license
# ============================================================================

import os

from .openable import Kind as Openable


class Kind(Openable):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'session'
        self.default_action = 'open'

    def action_open(self, context):
        target = context['targets'][0]
        path = target['action__path']

        current = self.vim.eval('v:this_session')
        if current and 'SessionLoad' not in self.vim.vars:
            self.vim.command('mksession! {}'.format(current))

        self.vim.command('bufdo bd')
        self.vim.command('source {}'.format(path))

    def action_delete(self, context):
        for target in context['targets']:
            file_path = target['action__path']
            if len(file_path) > 2 and os.path.isfile(file_path):
                os.remove(file_path)
            if self.vim.eval('v:this_session') == file_path:
                self.vim.command("let v:this_session = ''")

    def action_save(self, context):
        target = context['targets'][0]
        file_path = target['action__path']
        self.vim.command("mksession! '{}'".format(file_path))
        self.vim.command("let v:this_session = '{}'".format(file_path))
