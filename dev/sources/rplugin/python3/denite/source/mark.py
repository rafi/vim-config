import os
import re
import msgpack

from .base import Base

SHADA_MARK_GLOBAL = 7
SHADA_MARK_LOCAL = 10


class Source(Base):
    """ Vim marks source for Denite.nvim """

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'mark'
        self.kind = 'file'
        self._shada = vim.eval('&shada')
        self.vars = {
            'marks': 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ',
            'shada_path': None,
        }

    def on_init(self, context):
        """ Always set ShaDa path at initialization """
        if not self.vars.get('shada_path'):
            self.vars['shada_path'] = self._get_shada_path(self._shada)

    def gather_candidates(self, context):
        marks = self._load_shada_marks(self.vars['shada_path'])
        candidates = []
        for mark in marks:
            path = mark.get(b'f')
            name = chr(mark.get(b'n') or 46)
            if not (path and os.path.isfile(path) and name.isalnum()):
                continue

            path = path.decode()
            line = mark.get(b'l', 1)
            column = mark.get(b'c', 0)
            candidate = {
                'word': '{0}: {1}{2}: {3}'.format(
                    name, line,
                    (':' + str(column) if column and column != '0' else ''),
                    path),
                'action__path': path,
                'action__line': line,
                'action__col': column
            }

            candidates.append(candidate)
        return candidates

    def _load_shada_marks(self, path):
        """ Reads all marks from ShaDa file, local and global """
        f = open(path, 'rb')
        unpacker = msgpack.Unpacker(f)
        marks = []
        while True:
            try:
                # Read objects composed of 4 parts, see :h shada-format
                obj = [unpacker.unpack() for i in range(0, 4)]
                if obj[0] in [SHADA_MARK_GLOBAL, SHADA_MARK_LOCAL]:
                    marks.append(obj[3])
            except msgpack.exceptions.OutOfData:
                break

        f.close()
        return marks

    def _get_shada_path(self, shada_setting):
        """ Finds shada according to &shada or XDG specification """
        match = re.search(r'n(.+)$', shada_setting)
        if match:
            return match.group(1)
        else:
            xdg_data = os.path.expanduser(
                os.environ.get('XDG_DATA_HOME', '~/.local/share'))
            return os.path.join(xdg_data, 'nvim', 'shada', 'main.shada')
