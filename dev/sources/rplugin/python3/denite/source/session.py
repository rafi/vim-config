# ============================================================================
# FILE: session.py
# AUTHOR: Rafael Bodill <justRafi at gmail.com>
# License: MIT license
# ============================================================================

import os

from denite.util import globruntime
from .base import Base


class Source(Base):
    """ Vim session loader source for Denite.nvim """

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'session'
        self.kind = 'session'
        self.vars = {
            'path': vim.vars.get('session_directory', None),
            'pattern': '*'
        }

    def on_init(self, context):
        if not self.vars.get('path'):
            raise AttributeError('Invalid session directory, please configure')

    def gather_candidates(self, context):
        candidates = []

        for path in globruntime(self.vars['path'], self.vars['pattern']):
            name = os.path.splitext(os.path.basename(path))[0]
            candidates.append({
                'word': name,
                'action__path': path
            })

        return candidates
