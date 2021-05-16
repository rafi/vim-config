-- nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/kabouzeid/nvim-lspinstall
-- rafi settings

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', '<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', ',s', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', ',wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', ',rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<Leader>ce', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", ",f", '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", ",f", '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi! LspReferenceRead ctermbg=237 guibg=#373b41
      hi! LspReferenceText ctermbg=237 guibg=#373b41
      hi! LspReferenceWrite ctermbg=237 guibg=#373b41
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local lua_settings = {
  Lua = {
    runtime = { version = 'LuaJIT', path = vim.split(package.path, ';'), },
    diagnostics = {
      enable = true,
      globals = {'vim', 'use', 'describe', 'it', 'assert', 'before_each', 'after_each'},
    },
    workspace = {
      preloadFileSize = 400,
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

local diagnosticls = {
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'css',
    'scss',
    'html',
    'yaml',
    'lua',
    'vue',
    'markdown',
    'sh'
  },
  init_options = {
    linters = {
      shellcheck = {
        sourceName = "shellcheck",
        command = "shellcheck",
        debounce = 100,
        args = {"--format=gcc", "-"},
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {
          "^[^:]+:(\\d+):(\\d+):\\s+([^:]+):\\s+(.*)$",
          {line = 1, column = 2, message = 4, security = 3}
        },
        securities = {error = "error", warning = "warning", note = "info"}
      },
      eslint = {
        command = 'eslint',
        rootPatterns = {'.git'},
        debounce = 100,
        args = {'--stdin', '--stdin-filename', '%filepath', '--format', 'json'},
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {[2] = 'error', [1] = 'warning'}
      },
      scsslint = {
        command = 'scss-lint',
        rootPatterns = {'.git'},
        args = {'-f', 'Default', '%file', '-c', '/Users/vasco.nunes/.scss-lint.yml'},
        formatLines = 1,
        debounce = 100,
        formatPattern = {"^[^:]+:(\\d+) (.*)$", {line = 1, message = 2}},
        sourceName = 'scss-lint',
        securities = {[2] = 'error', [1] = 'warning'}
      },
      markdownlint = {
        command = 'markdownlint',
        rootPatterns = {'.git'},
        isStderr = true,
        debounce = 100,
        args = {'--stdin'},
        offsetLine = 0,
        offsetColumn = 0,
        sourceName = 'markdownlint',
        securities = {undefined = 'hint'},
        formatLines = 1,
        formatPattern = {'^.*:(\\d+)\\s+(.*)$', {line = 1, column = -1, message = 2}}
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
      markdown = {'markdownlint'},
      scss = 'scsslint',
      sh = "shellcheck",
    },
    formatters = {
      prettierEslint = {command = 'prettier-eslint', args = {'--stdin'}, rootPatterns = {'.git'}},
      eslint = {command = 'eslint', args = {'--stdin', '--fix'}, rootPatterns = {'.git'}},
      prettier = {command = 'prettier', args = {'--stdin-filepath', '%file'}},
      luaformat = {command = 'lua-format', args = {'%file', '-i'}, doesWriteToFile = true},
    },
    formatFiletypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      json = 'prettier',
      typescript = 'eslint',
      typescriptreact = 'eslint',
      markdown = 'prettier',
      scss = 'prettier',
      css = 'prettier',
      html = 'prettier',
      lua = 'luaformat',
      yaml = 'prettier',
      vue = 'prettier',
    },
  }
}

-- local lsp_status = require('lsp-status')
-- lsp_status.config({
--     indicator_errors = '  ',
--     indicator_warning = '  ',
--     indicator_info = '  ',
--     indicator_hint = '  ',
--     status_symbol = '',
--     current_function = false,
-- })

-- Enable diagnostics
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = false,
  }
)

local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    }
  }
  return {
    on_attach = on_attach,
  }
end

local function setup_servers()
  local lsp_config = require('lspconfig')
  local lsp_install = require('lspinstall')
  lsp_install.setup()
  local servers = lsp_install.installed_servers()
  for _, server in pairs(servers) do
    local config = make_config()

    if server == 'lua' then
      config.settings = lua_settings
    elseif server == 'diagnosticls' then
      config.init_options = diagnosticls.init_options
      config.filetypes = diagnosticls.filetypes
    end

    lsp_config[server].setup(config)
  end

  -- Reload if files were supplied in command-line arguments
  if vim.fn.argc() > 0 then
    vim.cmd('windo e') -- triggers the FileType autocmd that starts the server
  end
end

if vim.fn.has('vim_starting') then
  setup_servers()

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- reload installed servers
    vim.cmd('bufdo e') -- this triggers the FileType autocmd that starts the server
  end
end
