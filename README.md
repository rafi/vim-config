# Rafael Bodill's Neovim Config

Lean mean Neovim machine, 30-45ms startup time. Works best with [Neovim] ≥0.10

:gear: See "[Extending](#extending)" for customizing configuration and adding
plugins.

:triangular_flag_on_post: git tag [`vim`](https://github.com/rafi/vim-config/tree/vim)
tracks the last revision using Dein.nvim and plugins.yaml. Since then, the
entire configuration has been rewritten to use [lazy.nvim] and Lua.

> I encourage you to fork this repo and create your own experience.
> Learn how to tweak and change Neovim to the way YOU like it.
> This is my cultivation of years of tweaking, use it as a git remote
> and stay in-touch with upstream for reference or cherry-picking.

<details>
  <summary>
    <strong>Table of Contents</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Screenshot](#screenshot)
* [Prerequisites](#prerequisites)
* [Install](#install)
* [Install LSP, DAP, Linters, Formatters](#install-lsp-dap-linters-formatters)
  * [Language-Server Protocol (LSP)](#language-server-protocol-lsp)
  * [Recommended LSP](#recommended-lsp)
  * [Recommended Linters](#recommended-linters)
  * [Recommended Formatters](#recommended-formatters)
* [Recommended Fonts](#recommended-fonts)
* [Upgrade](#upgrade)
* [Structure](#structure)
* [Extending](#extending)
  * [Extend: Config](#extend-config)
  * [Extend: Plugins](#extend-plugins)
  * [Extend: Defaults](#extend-defaults)
  * [Extend: LSP Settings](#extend-lsp-settings)
* [Plugin Highlights](#plugin-highlights)
* [Plugins Included](#plugins-included)
  * [Completion & Code-Analysis](#completion--code-analysis)
  * [Editor Plugins](#editor-plugins)
  * [Coding Plugins](#coding-plugins)
  * [Colorscheme Plugins](#colorscheme-plugins)
  * [Git Plugins](#git-plugins)
  * [Misc Plugins](#misc-plugins)
  * [Treesitter & Syntax](#treesitter--syntax)
  * [UI Plugins](#ui-plugins)
* [Extra Plugins](#extra-plugins)
  * [Extra Plugins: Coding](#extra-plugins-coding)
  * [Extra Plugins: Editor](#extra-plugins-editor)
  * [Extra Plugins: Git](#extra-plugins-git)
  * [Extra Plugins: Lang](#extra-plugins-lang)
  * [Extra Plugins: Linting](#extra-plugins-linting)
  * [Extra Plugins: LSP](#extra-plugins-lsp)
  * [Extra Plugins: Org](#extra-plugins-org)
  * [Extra Plugins: Treesitter](#extra-plugins-treesitter)
  * [Extra Plugins: UI](#extra-plugins-ui)
  * [LazyVim Extras](#lazyvim-extras)
    * [Language](#language)
    * [DAP (Debugging)](#dap-debugging)
    * [Test](#test)
* [Custom Key-mappings](#custom-key-mappings)
  * [Navigation](#navigation)
  * [Selection](#selection)
  * [Jump To](#jump-to)
  * [Buffers](#buffers)
  * [Clipboard](#clipboard)
  * [Auto-Completion](#auto-completion)
  * [LSP](#lsp)
  * [Diagnostics](#diagnostics)
  * [Coding](#coding)
  * [Search, Substitute, Diff](#search-substitute-diff)
  * [Command & History](#command--history)
  * [File Operations](#file-operations)
  * [Editor UI](#editor-ui)
  * [Window Management](#window-management)
  * [Plugins](#plugins)
    * [Plugin: Mini.Surround](#plugin-minisurround)
    * [Plugin: Gitsigns](#plugin-gitsigns)
    * [Plugin: Diffview](#plugin-diffview)
    * [Plugin: Telescope](#plugin-telescope)
    * [Plugin: Neo-Tree](#plugin-neo-tree)
    * [Plugin: Spectre](#plugin-spectre)
    * [Plugin: Marks](#plugin-marks)
    * [Plugin: Zk](#plugin-zk)

<!-- vim-markdown-toc -->
</details>

## Features

* Fast startup time — plugins are almost entirely lazy-loaded!
* Robust, yet light-weight
* Plugin management with [folke/lazy.nvim]. Use with `:Lazy` or <kbd>Space</kbd>+<kbd>l</kbd>
* Install LSP, DAP, linters, and formatters. Use with `:Mason` or <kbd>Space</kbd>+<kbd>mm</kbd>
* LSP configuration with [nvim-lspconfig]
* [telescope.nvim] centric work-flow with lists (try <kbd>;</kbd>+<kbd>f</kbd>…)
* Custom context-menu (try it! <kbd>;</kbd>+<kbd>c</kbd>)
* Auto-complete extensive setup with [nvim-cmp]
  (try <kbd>Tab</kbd> or <kbd>Ctrl</kbd>+<kbd>Space</kbd> in insert-mode)
* Structure view with [hedyhli/outline.nvim]
* Git features using [lewis6991/gitsigns.nvim], [sindrets/diffview.nvim], and [more](#git-plugins)
* Session management with [folke/persistence.nvim]
* Unobtrusive, yet informative status & tab lines
* Premium color-schemes
* Remembers last-used colorscheme

## Screenshot

![Vim screenshot](http://rafi.io/img/project/vim-config/features.png)

## Prerequisites

* [git](https://git-scm.com/) ≥ 2.19.0 (`brew install git`)
* [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) ≥ v0.10.0
  (`brew install neovim`)

**Optional**, but highly recommended:

* [bat](https://github.com/sharkdp/bat) (`brew install bat`)
* [fd](https://github.com/sharkdp/fd) (`brew install fd`)
* [fzf](https://github.com/junegunn/fzf) (`brew install fzf`)
* [ripgrep](https://github.com/BurntSushi/ripgrep) (`brew install ripgrep`)
* [zoxide](https://github.com/ajeetdsouza/zoxide) (`brew install zoxide`)

## Install

1. Let's clone this repo! Clone to `~/.config/nvim`

    ```bash
    mkdir -p ~/.config
    git clone git@github.com:rafi/vim-config.git ~/.config/nvim
    cd ~/.config/nvim
    ```

1. Run `nvim` (will install all plugins the first time).

    It's highly recommended running `:checkhealth` to ensure your system is healthy
    and meet the requirements.

1. Inside Neovim, run `:LazyExtras` and use <kbd>x</kbd> to install extras.

Enjoy! :smile:

## Install LSP, DAP, Linters, Formatters

Use `:Mason` (or <kbd>Space</kbd>+<kbd>mm</kbd>) to install and manage LSP
servers, DAP servers, linters and formatters. See `:h mason.nvim` and
[williamboman/mason.nvim] for more information.

### Language-Server Protocol (LSP)

You can install LSP servers using `:Mason` UI, or `:MasonInstall <name>`,
or `:LspInstall <name>` (use <kbd>Tab</kbd> to list available servers).
See Mason's [PACKAGES.md](https://mason-registry.dev/registry/list)
for the official list, and the [Language server mapping](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)
list. You can also view at `:h mason-lspconfig-server-map`

You'll need utilities like `npm` and `curl` to install some extensions, see
[requirements](https://github.com/williamboman/mason.nvim#requirements)
(or `:h mason-requirements`) for more information.

See [lua/rafi/plugins/lsp/init.lua] for custom key-mappings and configuration
for some language-servers.

### Recommended LSP

```vim
:MasonInstall ansible-language-server bash-language-server css-lsp
:MasonInstall dockerfile-language-server gopls html-lsp json-lsp
:MasonInstall lua-language-server marksman pyright sqlls
:MasonInstall svelte-language-server typescript-language-server
:MasonInstall tailwindcss-language-server
:MasonInstall vim-language-server yaml-language-server
```

and [more](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)…

### Recommended Linters

```vim
:MasonInstall vint shellcheck editorconfig-checker flake8 gitlint hadolint
:MasonInstall markdownlint mypy selene shellharden write-good yamllint
```

### Recommended Formatters

```vim
:MasonInstall black fixjson gofumpt golines isort
:MasonInstall shfmt sql-formatter stylua
```

## Recommended Fonts

* [Pragmata Pro] (€19 — €1,990): My preferred font
* Any of the [Nerd Fonts]

On macOS with Homebrew, choose one of the [Nerd Fonts],
for example, here are some popular fonts:

```sh
brew tap homebrew/cask-fonts
brew search nerd-font
brew install --cask font-victor-mono-nerd-font
brew install --cask font-iosevka-nerd-font-mono
brew install --cask font-hack-nerd-font
brew install --cask font-fira-code
```

[Pragmata Pro]: https://www.fsd.it/shop/fonts/pragmatapro/
[Nerd Fonts]: https://www.nerdfonts.com

## Upgrade

To upgrade packages and plugins:

* Neovim plugins: `:Lazy update`
* Mason packages: `:Mason` and press <kbd>U</kbd>

To update Neovim configuration from my repo:

```bash
git pull --ff --ff-only
```

## Structure

* [after/](./after) — Language specific custom settings and plugins.
* [lua/](./lua) — Lua configurations
  * **`config/`** — Custom user configuration
  * **`plugins/`** — Custom user plugins (or `lua/plugins.lua`)
  * [rafi/](./lua/rafi)
    * [config/](./lua/config) — Neovim configurations
      * [autocmd.lua](./lua/rafi/config/autocmd.lua) — Auto-commands
      * [init.lua](./lua/rafi/config/init.lua) — Initialization
      * [keymaps.lua](./lua/rafi/config/keymaps.lua) — Key-mappings
      * [lazy.lua](./lua/rafi/config/lazy.lua) — Entry-point initialization
      * [options.lua](./lua/rafi/config/options.lua) — Editor settings
    * [plugins/](./lua/plugins) — Plugins and configurations
    * [util/](./lua/rafi/util) — Utility library
* [snippets/](./snippets) — Personal code snippets

## Extending

### Extend: Config

Fork this repository and create a directory
`lua/config` with one or more of these files: (Optional)

* `lua/config/autocmds.lua` — Custom auto-commands
* `lua/config/options.lua` — Custom options
* `lua/config/keymaps.lua` — Custom key-mappings
* `lua/config/setup.lua` — Override config,
  see [extend defaults](#extend-defaults).

Adding plugins or override existing options:

* `lua/plugins/*.lua` or `lua/plugins.lua` — Plugins (See [lazy.nvim] specs
  for syntax)

### Extend: Plugins

Install "extras" plugins using `:LazyExtras` and installing with <kbd>x</kbd>.
This saves choices in `lazyvim.json` which you can also edit manually, here's a
recommended starting point:

```json
{
  "extras": [
    "lazyvim.plugins.extras.dap.core",
    "lazyvim.plugins.extras.dap.nlua",
    "lazyvim.plugins.extras.editor.mini-files",
    "lazyvim.plugins.extras.lang.json",
    "lazyvim.plugins.extras.lang.markdown",
    "lazyvim.plugins.extras.test.core",
    "rafi.plugins.extras.coding.align",
    "rafi.plugins.extras.coding.cmp-git",
    "rafi.plugins.extras.coding.copilot",
    "rafi.plugins.extras.editor.harpoon",
    "rafi.plugins.extras.editor.miniclue",
    "rafi.plugins.extras.lang.ansible",
    "rafi.plugins.extras.lang.docker",
    "rafi.plugins.extras.lang.go",
    "rafi.plugins.extras.lang.helm",
    "rafi.plugins.extras.lang.python",
    "rafi.plugins.extras.lang.yaml",
    "rafi.plugins.extras.org.zk",
    "rafi.plugins.extras.ui.alpha",
    "rafi.plugins.extras.ui.deadcolumn"
  ],
  "news": [],
  "version": 2
}
```

For installing/overriding/disabling plugins, create a `lua/plugins/foo.lua`
file (or `lua/plugins/foo/bar.lua` or simply `lua/plugins.lua`) and manage your
own plugin collection. You can add or override existing plugins' options, or
just disable them all-together. Here's an example:

```lua
return {

  -- Disable default tabline
  { 'akinsho/bufferline.nvim', enabled = false },

  -- And choose a different one!
  -- { 'itchyny/lightline.vim' },
  -- { 'vim-airline/vim-airline' },
  -- { 'glepnir/galaxyline.nvim' },
  -- { 'glepnir/spaceline.vim' },
  -- { 'liuchengxu/eleline.vim' },

  -- Enable GitHub's Copilot
  { import = 'rafi.plugins.extras.coding.copilot' },

  -- Enable incline, displaying filenames on each window
  { import = 'rafi.plugins.extras.ui.incline' },

  -- Disable built-in plugins
  { 'shadmansaleh/lualine.nvim', enabled = false },
  { 'limorris/persisted.nvim', enabled = false },

  -- Change built-in plugins' options
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'bash', 'comment', 'css', 'diff', 'dockerfile', 'fennel', 'fish',
        'gitcommit', 'gitignore', 'gitattributes', 'git_rebase', 'go', 'gomod',
        'gosum', 'gowork', 'graphql', 'hcl', 'html', 'javascript', 'jsdoc',
        'json', 'json5', 'jsonc', 'jsonnet', 'lua', 'make', 'markdown',
        'markdown_inline', 'nix', 'perl', 'php', 'pug', 'python', 'regex',
        'rst', 'ruby', 'rust', 'scss', 'sql', 'svelte', 'terraform', 'toml',
        'tsx', 'typescript', 'vim', 'vimdoc', 'vue', 'yaml', 'zig',
      },
    },
  },

}
```

### Extend: Defaults

1. Create `lua/config/options.lua` and set any Neovim/RafiVim/LazyVim features:
    (Default values are shown)

    ```lua
    -- Auto format on-save
    vim.g.autoformat = false

    -- Elite-mode (hjkl mode. arrow-keys resize window)
    vim.g.elite_mode = false

    -- When enabled, 'q' closes any window
    vim.g.window_q_mapping = true

    -- Display structure in statusline by default
    vim.g.structure_status = false
    ```

1. You can override LazyVim options. For example in `lua/plugins/core.lua`:

    ```lua
    return {
      {
        'LazyVim/LazyVim',
        opts = {
          icons = {
            diagnostics = {
              Error = '',
              Warn  = '',
              Info  = '',
            },
            status = {
              diagnostics = {
                error = 'E',
                warn  = 'W',
                info  = 'I',
                hint  = 'H',
              },
            },
          },
        },
      },
    }
    ```

1. You can override lazy.nvim (package-manager) global options.
   Create `lua/config/setup.lua` and return this function:

    * `lazy_opts()` — override LazyVim setup options

    For example:

    ```lua
    local M = {}

    ---@return table
    function M.lazy_opts()
      return {
        -- See https://github.com/folke/lazy.nvim/#%EF%B8%8F-configuration
        concurrency = jit.os:find('Windows') and (vim.uv.available_parallelism() * 2) or nil,
      }
    end

    return M
    ```

1. You can completely override lazy.nvim setup by creating `lua/config/lazy.lua`
   to replace `lua/rafi/config/lazy.lua` with your own procedure.

### Extend: LSP Settings

To override **LSP configurations**, you can either:

1. Customize per project's `.neoconf.json`

1. Or, override server options with [nvim-lspconfig] plugin, for example:

   ```lua
   {
     'neovim/nvim-lspconfig',
     opts = {
       servers = {
         yamlls = {
           filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
         },
         lua_ls = {
           settings = {
             Lua = {
               workspace = { checkThirdParty = false },
               completion = { callSnippet = 'Replace' },
             },
           },
         },
       },
     }
   }
   ```

## Plugin Highlights

* Plugin management with cache and lazy loading for speed
* Auto-completion with Language-Server Protocol (LSP)
* Project-aware tabline
* Extensive syntax highlighting with [nvim-treesitter].

_Note_ that 95% of the plugins are **lazy-loaded**.

## Plugins Included

<details open>
  <summary><strong>List of plugins</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

### Completion & Code-Analysis

| Name           | Description
| -------------- | ----------------------
| [neovim/nvim-lspconfig] | Quickstart configurations for the Nvim LSP client
| [folke/neoconf.nvim] | Manage global and project-local settings
| [folke/neodev.nvim] | Neovim setup for init.lua and plugin development
| [williamboman/mason.nvim] | Portable package manager for Neovim
| [williamboman/mason-lspconfig.nvim] | Mason extension for easier lspconfig integration
| [stevearc/conform.nvim] | Lightweight yet powerful formatter plugin
| [mfussenegger/nvim-lint] | Asynchronous linter plugin

### Editor Plugins

| Name           | Description
| -------------- | ----------------------
| [folke/lazy.nvim] | Modern plugin manager for Neovim
| [nmac427/guess-indent.nvim] | Automatic indentation style detection
| [tweekmonster/helpful.vim] | Display vim version numbers in docs
| [lambdalisue/suda.vim] | An alternative sudo for Vim and Neovim
| [folke/persistence.nvim] | Simple lua plugin for automated session management
| [mbbill/undotree] | Ultimate undo history visualizer
| [folke/flash.nvim] | Search labels, enhanced character motions
| [haya14busa/vim-edgemotion] | Jump to the edge of block
| [folke/zen-mode.nvim] | Distraction-free coding for Neovim
| [folke/todo-comments.nvim] | Highlight, list and search todo comments in your projects
| [folke/trouble.nvim] | Pretty lists to help you solve all code diagnostics
| [akinsho/toggleterm.nvim] | Persist and toggle multiple terminals
| [hedyhli/outline.nvim] | Code outline sidebar powered by LSP
| [s1n7ax/nvim-window-picker] | Fancy Window picker
| [dnlhc/glance.nvim] | Pretty window for navigating LSP locations
| [nvim-pack/nvim-spectre] | Find the enemy and replace them with dark power
| [echasnovski/mini.bufremove] | Helper for removing buffers
| [mzlogin/vim-markdown-toc] | Generate table of contents for Markdown files

### Coding Plugins

| Name           | Description
| -------------- | ----------------------
| [hrsh7th/nvim-cmp] | Completion plugin for neovim written in Lua
| [hrsh7th/cmp-nvim-lsp] | nvim-cmp source for neovim builtin LSP client
| [hrsh7th/cmp-buffer] | nvim-cmp source for buffer words
| [hrsh7th/cmp-path] | nvim-cmp source for path
| [hrsh7th/cmp-emoji] | nvim-cmp source for emoji
| [L3MON4D3/LuaSnip] | Snippet Engine written in Lua
| [rafamadriz/friendly-snippets] | Preconfigured snippets for different languages
| [saadparwaiz1/cmp_luasnip] | Luasnip completion source for nvim-cmp
| [windwp/nvim-autopairs] | Powerful auto-pair plugin with multiple characters support
| [echasnovski/mini.surround] | Fast and feature-rich surround actions
| [JoosepAlviste/nvim-ts-context-commentstring] | Set the commentstring based on the cursor location
| [numToStr/Comment.nvim] | Powerful line and block-wise commenting
| [echasnovski/mini.splitjoin] | Split and join arguments
| [echasnovski/mini.trailspace] | Trailing whitespace highlight and remove
| [AndrewRadev/linediff.vim] | Perform diffs on blocks of code
| [AndrewRadev/dsf.vim] | Delete surrounding function call
| [echasnovski/mini.ai] | Extend and create `a`/`i` textobjects

### Colorscheme Plugins

| Name           | Description
| -------------- | ----------------------
| [rafi/theme-loader.nvim] | Use last-used colorscheme
| [rafi/neo-hybrid.vim] | Modern dark colorscheme, hybrid improved
| [rafi/awesome-colorschemes] | Awesome color-schemes

### Git Plugins

| Name           | Description
| -------------- | ----------------------
| [lewis6991/gitsigns.nvim] | Git signs written in pure lua
| [sindrets/diffview.nvim] | Tabpage interface for cycling through diffs
| [NeogitOrg/neogit] | Magit clone for Neovim
| [FabijanZulj/blame.nvim] | Git blame visualizer
| [rhysd/git-messenger.vim] | Reveal the commit messages under the cursor
| [ruifm/gitlinker.nvim] | Browse git repositories
| [rhysd/committia.vim] | Pleasant editing on Git commit messages

### Misc Plugins

| Name           | Description
| -------------- | ----------------------
| [hoob3rt/lualine.nvim] | Statusline plugin written in pure lua
| [nvim-neo-tree/neo-tree.nvim] | File explorer written in Lua
| [nvim-telescope/telescope.nvim] | Find, Filter, Preview, Pick. All lua.
| [jvgrootveld/telescope-zoxide] | Telescope extension for Zoxide
| [rafi/telescope-thesaurus.nvim] | Browse synonyms for a word
| [nvim-lua/plenary.nvim] | Lua functions library

### Treesitter & Syntax

| Name           | Description
| -------------- | ----------------------
| [nvim-treesitter/nvim-treesitter] | Nvim Treesitter configurations and abstraction layer
| [nvim-treesitter/nvim-treesitter-textobjects] | Textobjects using treesitter queries
| [nvim-treesitter/nvim-treesitter-context] | Show code context
| [RRethy/nvim-treesitter-endwise] | Wisely add "end" in various filetypes
| [windwp/nvim-ts-autotag] | Use treesitter to auto close and auto rename html tag
| [andymass/vim-matchup] | Modern matchit and matchparen
| [iloginow/vim-stylus] | Better vim plugin for stylus
| [mustache/vim-mustache-handlebars] | Mustache and handlebars syntax
| [lifepillar/pgsql.vim] | PostgreSQL syntax and indent
| [MTDL9/vim-log-highlighting] | Syntax highlighting for generic log files
| [reasonml-editor/vim-reason-plus] | Reason syntax and indent

### UI Plugins

| Name           | Description
| -------------- | ----------------------
| [nvim-tree/nvim-web-devicons] | Lua fork of vim-devicons
| [MunifTanjim/nui.nvim] | UI Component Library
| [rcarriga/nvim-notify] | Fancy notification manager
| [stevearc/dressing.nvim] | Improve the default vim-ui interfaces
| [akinsho/bufferline.nvim] | Snazzy tab/bufferline
| [folke/noice.nvim] | Replaces the UI for messages, cmdline and the popupmenu
| [SmiteshP/nvim-navic] | Shows your current code context in winbar/statusline
| [chentau/marks.nvim] | Interacting with and manipulating marks
| [lukas-reineke/indent-blankline.nvim] | Visually display indent levels
| [echasnovski/mini.indentscope] | Visualize and operate on indent scope
| [folke/which-key.nvim] | Create key bindings that stick
| [tenxsoydev/tabs-vs-spaces.nvim] | Hint and fix deviating indentation
| [t9md/vim-quickhl] | Highlight words quickly
| [kevinhwang91/nvim-bqf] | Better quickfix window
| [uga-rosa/ccc.nvim] | Super powerful color picker/colorizer plugin
| [itchyny/calendar.vim] | Calendar application

[neovim/nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[folke/neoconf.nvim]: https://github.com/folke/neoconf.nvim
[folke/neodev.nvim]: https://github.com/folke/neodev.nvim
[williamboman/mason.nvim]: https://github.com/williamboman/mason.nvim
[williamboman/mason-lspconfig.nvim]: https://github.com/williamboman/mason-lspconfig.nvim
[stevearc/conform.nvim]: https://github.com/stevearc/conform.nvim
[mfussenegger/nvim-lint]: https://github.com/mfussenegger/nvim-lint

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[nmac427/guess-indent.nvim]: https://github.com/nmac427/guess-indent.nvim
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[lambdalisue/suda.vim]: https://github.com/lambdalisue/suda.vim
[folke/persistence.nvim]: https://github.com/folke/persistence.nvim
[mbbill/undotree]: https://github.com/mbbill/undotree
[folke/flash.nvim]: https://github.com/folke/flash.nvim
[haya14busa/vim-edgemotion]: https://github.com/haya14busa/vim-edgemotion
[folke/zen-mode.nvim]: https://github.com/folke/zen-mode.nvim
[folke/todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[folke/trouble.nvim]: https://github.com/folke/trouble.nvim
[akinsho/toggleterm.nvim]: https://github.com/akinsho/toggleterm.nvim
[s1n7ax/nvim-window-picker]: https://github.com/s1n7ax/nvim-window-picker
[dnlhc/glance.nvim]: https://github.com/dnlhc/glance.nvim
[nvim-pack/nvim-spectre]: https://github.com/nvim-pack/nvim-spectre
[echasnovski/mini.bufremove]: https://github.com/echasnovski/mini.bufremove
[mzlogin/vim-markdown-toc]: https://github.com/mzlogin/vim-markdown-toc

[hrsh7th/nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[hrsh7th/cmp-nvim-lsp]: https://github.com/hrsh7th/cmp-nvim-lsp
[hrsh7th/cmp-buffer]: https://github.com/hrsh7th/cmp-buffer
[hrsh7th/cmp-path]: https://github.com/hrsh7th/cmp-path
[hrsh7th/cmp-emoji]: https://github.com/hrsh7th/cmp-emoji
[L3MON4D3/LuaSnip]: https://github.com/L3MON4D3/LuaSnip
[rafamadriz/friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[saadparwaiz1/cmp_luasnip]: https://github.com/saadparwaiz1/cmp_luasnip
[windwp/nvim-autopairs]: https://github.com/windwp/nvim-autopairs
[echasnovski/mini.surround]: https://github.com/echasnovski/mini.surround
[JoosepAlviste/nvim-ts-context-commentstring]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
[numToStr/Comment.nvim]: https://github.com/numToStr/Comment.nvim
[echasnovski/mini.splitjoin]: https://github.com/echasnovski/mini.splitjoin
[echasnovski/mini.trailspace]: https://github.com/echasnovski/mini.trailspace
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[AndrewRadev/dsf.vim]: https://github.com/AndrewRadev/dsf.vim
[echasnovski/mini.ai]: https://github.com/echasnovski/mini.ai

[rafi/theme-loader.nvim]: https://github.com/rafi/theme-loader.nvim
[rafi/neo-hybrid.vim]: https://github.com/rafi/neo-hybrid.vim
[rafi/awesome-colorschemes]: https://github.com/rafi/awesome-vim-colorschemes

[lewis6991/gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[sindrets/diffview.nvim]: https://github.com/sindrets/diffview.nvim
[NeogitOrg/neogit]: https://github.com/NeogitOrg/neogit
[FabijanZulj/blame.nvim]: https://github.com/FabijanZulj/blame.nvim
[rhysd/git-messenger.vim]: https://github.com/rhysd/git-messenger.vim
[ruifm/gitlinker.nvim]: https://github.com/ruifm/gitlinker.nvim
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim

[hoob3rt/lualine.nvim]: https://github.com/hoob3rt/lualine.nvim
[nvim-neo-tree/neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[nvim-telescope/telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[jvgrootveld/telescope-zoxide]: https://github.com/jvgrootveld/telescope-zoxide
[rafi/telescope-thesaurus.nvim]: https://github.com/rafi/telescope-thesaurus.nvim
[nvim-lua/plenary.nvim]: https://github.com/nvim-lua/plenary.nvim

[nvim-treesitter/nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-treesitter/nvim-treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
[nvim-treesitter/nvim-treesitter-context]: https://github.com/nvim-treesitter/nvim-treesitter-context
[RRethy/nvim-treesitter-endwise]: https://github.com/RRethy/nvim-treesitter-endwise
[windwp/nvim-ts-autotag]: https://github.com/windwp/nvim-ts-autotag
[andymass/vim-matchup]: https://github.com/andymass/vim-matchup
[iloginow/vim-stylus]: https://github.com/iloginow/vim-stylus
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[lifepillar/pgsql.vim]: https://github.com/lifepillar/pgsql.vim
[MTDL9/vim-log-highlighting]: https://github.com/MTDL9/vim-log-highlighting
[reasonml-editor/vim-reason-plus]: https://github.com/reasonml-editor/vim-reason-plus

[nvim-tree/nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons
[MunifTanjim/nui.nvim]: https://github.com/MunifTanjim/nui.nvim
[rcarriga/nvim-notify]: https://github.com/rcarriga/nvim-notify
[stevearc/dressing.nvim]: https://github.com/stevearc/dressing.nvim
[akinsho/bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[folke/noice.nvim]: https://github.com/folke/noice.nvim
[SmiteshP/nvim-navic]: https://github.com/SmiteshP/nvim-navic
[chentau/marks.nvim]: https://github.com/chentau/marks.nvim
[lukas-reineke/indent-blankline.nvim]: https://github.com/lukas-reineke/indent-blankline.nvim
[echasnovski/mini.indentscope]: https://github.com/echasnovski/mini.indentscope
[folke/which-key.nvim]: https://github.com/folke/which-key.nvim
[tenxsoydev/tabs-vs-spaces.nvim]: https://github.com/tenxsoydev/tabs-vs-spaces.nvim
[t9md/vim-quickhl]: https://github.com/t9md/vim-quickhl
[kevinhwang91/nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[uga-rosa/ccc.nvim]: https://github.com/uga-rosa/ccc.nvim
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim

</details>

## Extra Plugins

<details open>
  <summary><strong>List of extras</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

You can view all LazyVim's extras at [www.lazyvim.org/extras].

These plugins aren't enabled by default. You'll have to install them using
`:LazyExtras` and installing with <kbd>x</kbd>. (Or import them using specs)
See [Extend: Plugins](#extend-plugins) on how to add plugins and examples.

Following are extra-extras available with Rafi's Neovim on-top of LazyVim's:

### Extra Plugins: Coding

Spec: `rafi.plugins.extras.coding.<name>`

| Name           | Repository     | Description
| -------------- | -------------- | ----------------------
| `align`        | [echasnovski/mini.align] | Align text interactively
| `chainsaw`     | [chrisgrieser/nvim-chainsaw] | Create log statements on the fly
| `cmp-git`      | [petertriho/cmp-git] | Git source for nvim-cmp
| `copilot`      | [zbirenbaum/copilot.lua] | Fully featured & enhanced copilot
| `editorconfig` | [sgur/vim-editorconfig] | EditorConfig plugin written entirely in Vimscript
| `emmet`        | [mattn/emmet-vim] | Provides support for expanding abbreviations alá emmet
| `mini.comment` | [echasnovski/mini.comment] | Fast and familiar per-line commenting
| `minipairs`    | [echasnovski/mini.pairs] | Automatically manage character pairs
| `neogen`       | [danymat/neogen] | Annotation generator
| `sandwich`     | [machakann/vim-sandwich] | Search, select, and edit sandwich text objects

[echasnovski/mini.align]: https://github.com/echasnovski/mini.align
[chrisgrieser/nvim-chainsaw]: https://github.com/chrisgrieser/nvim-chainsaw
[petertriho/cmp-git]: https://github.com/petertriho/cmp-git
[zbirenbaum/copilot.lua]: https://github.com/zbirenbaum/copilot.lua
[sgur/vim-editorconfig]: https://github.com/sgur/vim-editorconfig
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[echasnovski/mini.comment]: https://github.com/echasnovski/mini.comment
[echasnovski/mini.pairs]: https://github.com/echasnovski/mini.pairs
[danymat/neogen]: https://github.com/danymat/neogen
[machakann/vim-sandwich]: https://github.com/machakann/vim-sandwich

### Extra Plugins: Colorscheme

Spec: `rafi.plugins.extras.colorscheme.<name>`

| Name           | Repository     | Description
| -------------- | -------------- | ----------------------
| `nordic`       | [AlexvZyl/nordic.nvim] | Nord for Neovim, but warmer and darker
| `tokyonight`   | [folke/tokyonight.nvim] | Clean, dark Neovim theme
| `kanagawa`     | [rebelot/kanagawa.nvim] | Inspired by the colors of the famous painting by Katsushika Hokusai
| `onedarkpro`   | [olimorris/onedarkpro.nvim] | OneDarkPro theme
| `nightfox`     | [EdenEast/nightfox.nvim] | Highly customizable theme
| `oxocarbon`    | [nyoom-engineering/oxocarbon.nvim] | Dark and light theme inspired by IBM Carbon
| `bamboo`       | [ribru17/bamboo.nvim] | Warm green theme
| `catppuccin`   | [catppuccin/nvim] | Soothing pastel theme

[AlexvZyl/nordic.nvim]: https://github.com/AlexvZyl/nordic.nvim
[folke/tokyonight.nvim]: https://github.com/folke/tokyonight.nvim
[rebelot/kanagawa.nvim]: https://github.com/rebelot/kanagawa.nvim
[olimorris/onedarkpro.nvim]: https://github.com/olimorris/onedarkpro.nvim
[EdenEast/nightfox.nvim]: https://github.com/EdenEast/nightfox.nvim
[nyoom-engineering/oxocarbon.nvim]: https://github.com/nyoom-engineering/oxocarbon.nvim
[ribru17/bamboo.nvim]: https://github.com/ribru17/bamboo.nvim
[catppuccin/nvim]: https://github.com/catppuccin/nvim

### Extra Plugins: Editor

Spec: `rafi.plugins.extras.editor.<name>`

| Name          | Repository     | Description
| --------------| -------------- | ----------------------
| `anyjump`     | [pechorin/any-jump.vim] | Jump to any definition and references without overhead
| `flybuf`      | [glepnir/flybuf.nvim]   | List buffers in a float window
| `harpoon`     | [ThePrimeagen/harpoon]  | Marks for navigating your project
| `minivisits`  | [echasnovski/mini.visits] | Track and reuse file system visits
| `rest`        | [rest-nvim/rest.nvim] | Fast Neovim http client written in Lua
| `sidebar`     | [sidebar-nvim/sidebar.nvim] | Generic and modular lua sidebar
| `ufo`         | [kevinhwang91/nvim-ufo] | Make folds look modern and keep a high performance

[pechorin/any-jump.vim]: https://github.com/pechorin/any-jump.vim
[glepnir/flybuf.nvim]: https://github.com/glepnir/flybuf.nvim
[ThePrimeagen/harpoon]: https://github.com/ThePrimeagen/harpoon
[echasnovski/mini.visits]: https://github.com/echasnovski/mini.visits
[rest-nvim/rest.nvim]: https://github.com/rest-nvim/rest.nvim
[sidebar-nvim/sidebar.nvim]: https://github.com/sidebar-nvim/sidebar.nvim
[kevinhwang91/nvim-ufo]: https://github.com/kevinhwang91/nvim-ufo

### Extra Plugins: Git

Spec: `rafi.plugins.extras.git.<name>`

| Name         | Repository     | Description
| -------------| -------------- | ----------------------
| `fugitive`   | [tpope/vim-fugitive] | Git client, including [junegunn/gv.vim]

[tpope/vim-fugitive]: https://github.com/tpope/vim-fugitive
[junegunn/gv.vim]: https://github.com/junegunn/gv.vim

### Extra Plugins: Lang

Spec: `rafi.plugins.extras.lang.<name>`

| Name             | Description
| ---------------- | ----------------------
| `ansible`        | syntax [pearofducks/ansible-vim], lsp, lint
| `docker`         | syntax, lsp, lint
| `go`             | syntax, lsp, formatter, dap [leoluz/nvim-dap-go], test [nvim-neotest/neotest-go]
| `helm`           | syntax, lsp
| `markdown`       | syntax, lsp, browser preview [iamcco/markdown-preview.nvim]
| `python`         | syntax, lsp, dap [mfussenegger/nvim-dap-python], test, [rafi/neoconf-venom.nvim]
| `tmux`           | syntax, completion [andersevenrud/cmp-tmux], keymaps [christoomey/tmux-navigator]
| `yaml`           | syntax, lsp, schemas, [b0o/SchemaStore.nvim]

[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim
[leoluz/nvim-dap-go]: https://github.com/leoluz/nvim-dap-go
[nvim-neotest/neotest-go]: https://github.com/nvim-neotest/neotest-go
[iamcco/markdown-preview.nvim]: https://github.com/iamcco/markdown-preview.nvim
[mfussenegger/nvim-dap-python]: https://github.com/mfussenegger/nvim-dap-python
[rafi/neoconf-venom.nvim]: https://github.com/rafi/neoconf-venom.nvim
[b0o/SchemaStore.nvim]: https://github.com/b0o/SchemaStore.nvim
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[andersevenrud/cmp-tmux]: https://github.com/andersevenrud/cmp-tmux

### Extra Plugins: Linting

Spec: `rafi.plugins.extras.linting.<name>`

| Name           | Description
| -------------- | ----------------------
| `ruff`         | ruff for python

### Extra Plugins: LSP

Spec: `rafi.plugins.extras.lsp.<name>`

| Key              | Name           | Description
| ---------------- | -------------- | ----------------------
| `gtd`            | [hrsh7th/nvim-gtd] | LSP's go-to definition plugin
| `inlayhints`     | [lvimuser/lsp-inlayhints.nvim] | Partial implementation of LSP inlay hint
| `lightbulb`      | [kosayoda/nvim-lightbulb] | VSCode 💡 for neovim's built-in LSP
| `yaml-companion` | [yaml-companion.nvim] | Get, set and autodetect YAML schemas in your buffers

[hrsh7th/nvim-gtd]: https://github.com/hrsh7th/nvim-gtd
[lvimuser/lsp-inlayhints.nvim]: https://github.com/lvimuser/lsp-inlayhints.nvim
[kosayoda/nvim-lightbulb]: https://github.com/kosayoda/nvim-lightbulb
[yaml-companion.nvim]: https://github.com/someone-stole-my-name/yaml-companion.nvim

### Extra Plugins: Org

Spec: `rafi.plugins.extras.org.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `kiwi`         | [serenevoid/kiwi.nvim] | Stripped down VimWiki
| `telekasten`   | [renerocksai/telekasten.nvim] | Manage text-based, markdown zettelkasten or wiki with telescope
| `vimwiki`      | [vimwiki/vimwiki] | Personal Wiki for Vim
| `zk-nvim`      | [zk-org/zk-nvim] | Extension for the zk plain text note-taking assistant

[serenevoid/kiwi.nvim]: https://github.com/serenevoid/kiwi.nvim
[renerocksai/telekasten.nvim]: https://github.com/renerocksai/telekasten.nvim
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki
[zk-org/zk-nvim]: https://github.com/zk-org/zk-nvim

### Extra Plugins: Treesitter

Spec: `rafi.plugins.extras.treesitter.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `treesj`       | [Wansmer/treesj] | Splitting and joining blocks of code

[Wansmer/treesj]: https://github.com/Wansmer/treesj

### Extra Plugins: UI

Spec: `rafi.plugins.extras.ui.<name>`

| Key               | Name           | Description
| ----------------- | -------------- | ----------------------
| `alpha`           | [goolord/alpha-nvim] | Fast and fully programmable greeter
| `barbecue`        | [utilyre/barbecue.nvim] | VS Code like winbar
| `cursorword`      | [itchyny/cursorword] | Underlines word under cursor
| `cybu`            | [ghillb/cybu.nvim] | Cycle buffers with a customizable notification window
| `deadcolumn`      | [Bekaboo/deadcolumn.nvim] | Show colorcolumn dynamically
| `goto-preview`    | [rmagatti/goto-preview] | Preview definitions using floating windows
| `headlines`       | [lukas-reineke/headlines.nvim] | Adds horizontal highlights for headlines and code background.
| `illuminate`      | [RRethy/vim-illuminate] | Highlights other uses of the word under the cursor
| `incline`         | [b0o/incline.nvim] | Floating statuslines
| `miniclue`        | [echasnovski/mini.clue] | Show next key clues
| `minimap`         | [echasnovski/mini.map] | Window with buffer text overview, scrollbar and highlights
| `render-markdown` | [MeanderingProgrammer/markdown.nvim] | Improve viewing Markdown files
| `symbols-outline` | [simrat39/symbols-outline.nvim] | Tree like view for symbols using LSP

[goolord/alpha-nvim]: https://github.com/goolord/alpha-nvim
[utilyre/barbecue.nvim]: https://github.com/utilyre/barbecue.nvim
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword
[ghillb/cybu.nvim]: https://github.com/ghillb/cybu.nvim
[Bekaboo/deadcolumn.nvim]: https://github.com/Bekaboo/deadcolumn.nvim
[rmagatti/goto-preview]: https://github.com/rmagatti/goto-preview
[lukas-reineke/headlines.nvim]: https://github.com/lukas-reineke/headlines.nvim
[RRethy/vim-illuminate]: https://github.com/RRethy/vim-illuminate
[b0o/incline.nvim]: https://github.com/b0o/incline.nvim
[echasnovski/mini.clue]: https://github.com/echasnovski/mini.clue
[echasnovski/mini.map]: https://github.com/echasnovski/mini.map
[MeanderingProgrammer/markdown.nvim]: https://github.com/MeanderingProgrammer/markdown.nvim
[simrat39/symbols-outline.nvim]: https://github.com/simrat39/symbols-outline.nvim

### LazyVim Extras

LazyVim is imported in specs (see [lua/rafi/config/lazy.lua](./lua/rafi/config/lazy.lua))
Therefore, you can import any of the "Extras" plugins defined at
[LazyVim/LazyVim](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras)
and documented in [lazyvim.org](https://www.lazyvim.org).

**These are only highlights:**

#### Language

* `lazyvim.plugins.extras.lang.json`
* `lazyvim.plugins.extras.lang.markdown`
* `lazyvim.plugins.extras.lang.terraform`
* `lazyvim.plugins.extras.lang.typescript`

#### DAP (Debugging)

* Spec: `lazyvim.plugins.extras.dap.<name>`
* See [lazyvim/plugins/extras/dap](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras/dap)

#### Test

* Spec: `lazyvim.plugins.extras.test.<name>`
* See [lazyvim/plugins/extras/test](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/extras/test)

</details>

## Custom Key-mappings

Note that,

* **Leader** key set as <kbd>Space</kbd>
* **Local-Leader** key set as <kbd>;</kbd> and used for navigation and search
  (Telescope and Neo-tree)
* Disable <kbd>←</kbd> <kbd>↑</kbd> <kbd>→</kbd> <kbd>↓</kbd> in normal mode by enabling `elite_mode`.

<details open>
  <summary>
    <strong>Key-mappings</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<center>Modes: 𝐍=normal 𝐕=visual 𝐒=select 𝐈=insert 𝐎=operator 𝐂=command</center>

### Navigation

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>j</kbd> / <kbd>k</kbd> | 𝐍 𝐕 | Cursor moves through display-lines | <small>`g` `j/k`</small>
| <kbd>gj</kbd> / <kbd>gk</kbd> | 𝐍 𝐕 𝐒 | Jump to edge upward/downward | <small>[haya14busa/vim-edgemotion]</small>
| <kbd>gh</kbd> / <kbd>gl</kbd> | 𝐍 𝐕 | Easier line-wise movement | <small>`g^` `g$`</small>
| <kbd>zl</kbd> / <kbd>zh</kbd> | 𝐍 | Scroll horizontally and vertically wider | <small>`z4` `l/h`</small>
| <kbd>Ctrl</kbd>+<kbd>j</kbd> | 𝐍 | Move to split below | <small>`<C-w>j` or [christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>k</kbd> | 𝐍 | Move to upper split | <small>`<C-w>k` or [christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐍 | Move to left split | <small>`<C-w>h` or [christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐍 | Move to right split | <small>`<C-w>l` or [christoomey/tmux-navigator]</small>
| <kbd>Return</kbd> | 𝐍 | Toggle fold under cursor | <small>`za`</small>
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐍 | Focus the current fold by closing all others | <small>`zMzv`</small>
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | 𝐂 | Move cursor forwards in command | <kbd>Right</kbd>
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | 𝐂 | Move cursor backwards in command | <kbd>Left</kbd>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐂 | Move cursor to the beginning in command | <kbd>Home</kbd>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐂 | Move cursor to the end in command | <kbd>End</kbd>
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | 𝐍 | Go to next tab | <small>`:tabnext`</small>
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd><kbd>Tab</kbd> | 𝐍 | Go to previous tab | <small>`:tabprevious`</small>
| <kbd>Alt</kbd>+<kbd>j</kbd> or <kbd>]</kbd> | 𝐍 | Go to next tab | <small>`:tabnext`</small>
| <kbd>Alt</kbd>+<kbd>k</kbd> or <kbd>[</kbd> | 𝐍 | Go to previous tab | <small>`:tabprevious`</small>
| <kbd>Alt</kbd>+<kbd>{</kbd> | 𝐍 | Move tab backward | <small>`:-tabmove`</small>
| <kbd>Alt</kbd>+<kbd>}</kbd> | 𝐍 | Move tab forward | <small>`:+tabmove`</small>

### Selection

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>Space</kbd> | 𝐍 𝐕 | Toggle visual-line mode | <small>`V` / <kbd>Escape</kbd></small>
| <kbd>v</kbd> / <kbd>V</kbd> | 𝐕 | Increment/shrink selection | <small>[nvim-treesitter]</small>
| <kbd>gpp</kbd> | 𝐍 | Select last paste |
| <kbd>sg</kbd> | 𝐕 | Replace within selected area |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | 𝐕 | Replace selection with step-by-step confirmation |
| <kbd>></kbd> / <kbd><</kbd> | 𝐕 | Indent and re-select |
| <kbd>Tab</kbd> / <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐕 | Indent and re-select |
| <kbd>I</kbd> / <kbd>gI</kbd> / <kbd>A</kbd> | 𝐕 | Force blockwise operation |

### Jump To

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>],</kbd> or <kbd>[,</kbd> | 𝐍 | Next/previous parameter | <small>[akinsho/bufferline.nvim]</small>
| <kbd>]q</kbd> or <kbd>[q</kbd> | 𝐍 | Next/previous on quick-fix | <small>`:cnext` / `:cprev`</small>
| <kbd>]a</kbd> or <kbd>[a</kbd> | 𝐍 | Next/previous on location-list | <small>`:lnext` / `:lprev`</small>
| <kbd>]d</kbd> or <kbd>[d</kbd> | 𝐍 | Next/previous diagnostics |
| <kbd>]e</kbd> or <kbd>[e</kbd> | 𝐍 | Next/previous error |
| <kbd>]w</kbd> or <kbd>[w</kbd> | 𝐍 | Next/previous warning |
| <kbd>]b</kbd> or <kbd>[b</kbd> | 𝐍 | Next/previous buffer | <small>[akinsho/bufferline.nvim]</small>
| <kbd>]f</kbd> or <kbd>[f</kbd> | 𝐍 | Next/previous function start | <small>[echasnovski/mini.ai]</small>
| <kbd>]F</kbd> or <kbd>[F</kbd> | 𝐍 | Next/previous function end | <small>[echasnovski/mini.ai]</small>
| <kbd>]c</kbd> or <kbd>[c</kbd> | 𝐍 | Next/previous class start | <small>[echasnovski/mini.ai]</small>
| <kbd>]C</kbd> or <kbd>[C</kbd> | 𝐍 | Next/previous class end | <small>[echasnovski/mini.ai]</small>
| <kbd>]m</kbd> or <kbd>[m</kbd> | 𝐍 | Next/previous method start | <small>[echasnovski/mini.ai]</small>
| <kbd>]M</kbd> or <kbd>[M</kbd> | 𝐍 | Next/previous method end | <small>[echasnovski/mini.ai]</small>
| <kbd>]g</kbd> or <kbd>[g</kbd> | 𝐍 | Next/previous Git hunk | <small>[lewis6991/gitsigns.nvim]</small>
| <kbd>]i</kbd> or <kbd>[i</kbd> | 𝐍 | Next/previous indent scope | <small>[echasnovski/mini.indentscope]</small>
| <kbd>]s</kbd> or <kbd>[s</kbd> | 𝐍 | Next/previous misspelled word
| <kbd>]t</kbd> or <kbd>[t</kbd> | 𝐍 | Next/previous TODO | <small>[folke/todo-comments.nvim]</small>
| <kbd>]z</kbd> or <kbd>[z</kbd> | 𝐍 | Next/previous whitespace error | <small>[config/keymaps.lua]</small>

### Buffers

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>bd</kbd> | 𝐍 | Delete buffer | <small>[echasnovski/mini.bufremove]</small>


### Clipboard

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>p</kbd> or <kbd>P</kbd> | 𝐕 | Paste without yank | <small>`:let @+=@0`</small>
| <kbd>Space</kbd>+<kbd>y</kbd> | 𝐍 | Copy relative file-path to clipboard | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd>+<kbd>Y</kbd> | 𝐍 | Copy absolute file-path to clipboard | <small>[config/keymaps.lua]</small>

### Auto-Completion

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 𝐒 | Navigate/open completion-menu | <small>[nvim-cmp]</small>
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 𝐒 | Navigate snippet placeholders | <small>[L3MON4D3/LuaSnip]</small>
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 𝐈 | Open completion menu | <small>[nvim-cmp]</small>
| <kbd>Enter</kbd> | 𝐈 | Select completion item or expand snippet | <small>[nvim-cmp]</small>
| <kbd>Shift</kbd>+<kbd>Enter</kbd> | 𝐈 | Select and replace with completion item | <small>[nvim-cmp]</small>
| <kbd>Ctrl</kbd>+<kbd>n</kbd>/<kbd>p</kbd> | 𝐈 | Movement in completion pop-up | <small>[nvim-cmp]</small>
| <kbd>Ctrl</kbd>+<kbd>f</kbd>/<kbd>b</kbd> | 𝐈 | Scroll documentation | <small>[nvim-cmp]</small>
| <kbd>Ctrl</kbd>+<kbd>d</kbd>/<kbd>u</kbd> | 𝐈 | Scroll candidates | <small>[nvim-cmp]</small>
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | 𝐈 | Abort selection and close pop-up | <small>[nvim-cmp]</small>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐈 | Expand snippet at cursor | <small>[L3MON4D3/LuaSnip]</small>
| <kbd>Ctrl</kbd>+<kbd>c</kbd> | 𝐈 | Close completion menu | <small>[nvim-cmp]</small>

### LSP

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>gr</kbd> | 𝐍 | Go to references | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gR</kbd> | 𝐍 | List references with Trouble | <small>[folke/trouble.nvim]</small>
| <kbd>gd</kbd> | 𝐍 | Go to definition | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gD</kbd> | 𝐍 | Go to declaration | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gI</kbd> | 𝐍 | Go to implementation | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gy</kbd> | 𝐍 | Go to type definition | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>K</kbd>  | 𝐍 | Show hover help or collapsed fold | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gK</kbd> | 𝐍 | Show signature help | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>cl</kbd>  | 𝐍 | Open LSP info window | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>cr</kbd>  | 𝐍 | Rename | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>ce</kbd>  | 𝐍 | Open diagnostics window | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>co</kbd>  | 𝐍 | Formatter menu selection | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>ca</kbd>  | 𝐍 𝐕 | Code action | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>cA</kbd>  | 𝐍 | Source action | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>chi</kbd>  | 𝐍 | LSP incoming calls | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>cho</kbd>  | 𝐍 | LSP outgoing calls | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>ud</kbd>  | 𝐍 | Toggle buffer diagnostics | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>uD</kbd>  | 𝐍 | Toggle global diagnostics | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>fwa</kbd> | 𝐍 | Add workspace folder | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>fwr</kbd> | 𝐍 | Remove workspace folder | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>fwl</kbd> | 𝐍 | List workspace folders | <small>[plugins/lsp/keymaps.lua]</small>
| <kbd>gpd</kbd> | 𝐍 | Glance definitions | <small>[dnlhc/glance.nvim]</small>
| <kbd>gpr</kbd> | 𝐍 | Glance references | <small>[dnlhc/glance.nvim]</small>
| <kbd>gpy</kbd> | 𝐍 | Glance type definitions | <small>[dnlhc/glance.nvim]</small>
| <kbd>gpi</kbd> | 𝐍 | Glance implementations | <small>[dnlhc/glance.nvim]</small>

### Diagnostics

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd> <kbd>xt</kbd> | 𝐍 | List TODO with Trouble | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd> <kbd>xT</kbd> | 𝐍 | List TODO/FIXME with Trouble | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd> <kbd>st</kbd> | 𝐍 | Select TODO with Telescope | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd> <kbd>sT</kbd> | 𝐍 | Select TODO/FIXME with Telescope | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd> <kbd>xx</kbd> | 𝐍 | Toggle Trouble | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd> <kbd>xd</kbd> | 𝐍 | Toggle Trouble document | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd> <kbd>xw</kbd> | 𝐍 | Toggle Trouble workspace | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd> <kbd>xq</kbd> | 𝐍 | Toggle Quickfix via Trouble | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd> <kbd>xl</kbd> | 𝐍 | Toggle Locationlist via Trouble | <small>[folke/trouble.nvim]</small>

### Coding

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | 𝐍 | Start recording macro | <small>`q`</small>
| <kbd>Space</kbd> <kbd>cf</kbd> | 𝐍 𝐕 | Format | <small>[plugins/formatting.lua]</small>
| <kbd>Space</kbd> <kbd>cF</kbd> | 𝐍 𝐕 | Format injected langs | <small>[plugins/formatting.lua]</small>
| <kbd>Space</kbd> <kbd>cc</kbd> | 𝐍 | Generate doc annotations | <small>[danymat/neogen]</small>
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐈 | Start new line from any cursor position | <small>`<C-o>o`</small>
| <kbd>]</kbd> <kbd>Space</kbd> | 𝐍 | Add new line below | <small>`o<Esc>`</small>
| <kbd>[</kbd> <kbd>Space</kbd> | 𝐍 | Add new line above | <small>`O<Esc>`</small>
| <kbd>gc</kbd> | 𝐍 𝐕 | Comment prefix | <small>[numToStr/Comment.nvim]</small>
| <kbd>gcc</kbd> | 𝐍 𝐕 | Toggle comments | <small>[numToStr/Comment.nvim]</small>
| <kbd>Space</kbd>+<kbd>j</kbd> or <kbd>k</kbd> | 𝐍 𝐕 | Move lines down/up | <small>`:m` …
| <kbd>Space</kbd>+<kbd>v</kbd> | 𝐍 𝐕 | Toggle line-wise comments | <small>[numToStr/Comment.nvim]</small>
| <kbd>Space</kbd>+<kbd>V</kbd> | 𝐍 𝐕 | Toggle block-wise comments | <small>[numToStr/Comment.nvim]</small>
| <kbd>Space</kbd>+<kbd>dd</kbd> | 𝐍 𝐕 | Duplicate line or selection | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd>+<kbd>p</kbd> | 𝐍 | Duplicate paragraph | <small>`yap<S-}>p`</small>
| <kbd>Space</kbd>+<kbd>cw</kbd> | 𝐍 | Remove all spaces at EOL | <small>[echasnovski/mini.trailspace]</small>
| <kbd>sj</kbd> / <kbd>sk</kbd> | 𝐍 | Join/split arguments | <small>[echasnovski/mini.splitjoin]</small>
| <kbd>dsf</kbd> / <kbd>csf</kbd> | 𝐍 | Delete/change surrounding function call | <small>[AndrewRadev/dsf.vim]</small>

### Search, Substitute, Diff

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>\*</kbd> / <kbd>#</kbd> | 𝐍 𝐕 | Search partial words | <small>`g*` / `g#`</small>
| <kbd>g\*</kbd> / <kbd>g#</kbd> | 𝐍 𝐕 | Search whole-word forward/backward | <small>`*` / `#`</small>
| <kbd>Escape</kbd> | 𝐍 | Clear search highlight | <small>`:nohlsearch`</small>
| <kbd>Backspace</kbd> | 𝐍 | Match bracket | <small>`%`</small>
| <kbd>Space</kbd>+<kbd>bf</kbd> | 𝐍 | Diff current windows in tab | <small>`windo diffthis`</small>
| <kbd>ss</kbd> | 𝐍 𝐕 𝐎 | Flash jump | <small>[folke/flash.nvim]</small>
| <kbd>S</kbd> | 𝐍 𝐕 𝐎 | Flash treesitter | <small>[folke/flash.nvim]</small>
| <kbd>r</kbd> | 𝐎 | Flash remote | <small>[folke/flash.nvim]</small>
| <kbd>R</kbd> | 𝐕 𝐎 | Flash treesitter search | <small>[folke/flash.nvim]</small>
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | 𝐂 | Toggle flash in search input | <small>[folke/flash.nvim]</small>

### Command & History

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>!</kbd> | 𝐍 | Shortcut for shell command | <small>`:!`</small>
| <kbd>g!</kbd> | 𝐍 | Read vim command into buffer | <small>`:put=execute('⌴')`</small>
| <kbd>Ctrl</kbd>+<kbd>n</kbd> / <kbd>p</kbd> | 𝐂 | Switch history search pairs | <kbd>↓</kbd> / <kbd>↑</kbd>
| <kbd>↓</kbd> / <kbd>↑</kbd> | 𝐂 | Switch history search pairs | <small>`Ctrl` `n`/`p`</small>

### File Operations

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>cd</kbd> | 𝐍 | Switch tab to the directory of current buffer | <small>`:tcd %:p:h`</small>
| <kbd>Space</kbd>+<kbd>w</kbd> | 𝐍 | Write buffer to file | <small>`:write`</small>
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | 𝐍 𝐕 𝐂 | Write buffer to file | <small>`:write`</small>

### Editor UI

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd> <kbd>ub</kbd> | 𝐍 | Toggle structure scope in winbar | <small>[SmiteshP/nvim-navic]</small>
| <kbd>Space</kbd> <kbd>uf</kbd> | 𝐍 | Toggle format on Save | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>us</kbd> | 𝐍 | Toggle spell-checker | <small>`:setlocal spell!`</small>
| <kbd>Space</kbd> <kbd>ul</kbd> | 𝐍 | Toggle line numbers | <small>`:setlocal nonumber!`</small>
| <kbd>Space</kbd> <kbd>uL</kbd> | 𝐍 | Toggle relative line numbers | <small>`:setlocal norelativenumber!`</small>
| <kbd>Space</kbd> <kbd>uo</kbd> | 𝐍 | Toggle hidden characters | <small>`:setlocal nolist!`</small>
| <kbd>Space</kbd> <kbd>uu</kbd> | 𝐍 | Toggle highlighted search | <small>`:set hlsearch!`</small>
| <kbd>Space</kbd> <kbd>uw</kbd> | 𝐍 | Toggle wrap | <small>`:setlocal wrap!`</small> …
| <kbd>Space</kbd> <kbd>ue</kbd> | 𝐍 | Toggle indentation lines | <small>[lukas-reineke/indent-blankline.nvim]</small>
| <kbd>Space</kbd> <kbd>uh</kbd> | 𝐍 | Toggle inlay-hints | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>ui</kbd> | 𝐍 | Show highlight groups for word | <small>`vim.show_pos`</small>
| <kbd>Space</kbd> <kbd>up</kbd> | 𝐍 | Disable auto-pairs | <small>[windwp/nvim-autopairs]</small>
| <kbd>Space</kbd> <kbd>ur</kbd> | 𝐍 | Redraw, clear hlsearch, and diff update | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>un</kbd> | 𝐍 | Dismiss all notifications | <small>[rcarriga/nvim-notify]</small>

### Window Management

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>q</kbd> | 𝐍 | Quit window (if last window, quit nvim) | <small>`:quit`</small>
| <kbd>Ctrl</kbd>+<kbd>x</kbd> | 𝐍 | Rotate window placement | <small>`C-w` `x`</small>
| <kbd>sp</kbd> | 𝐍 | Choose a window to edit | <small>[s1n7ax/nvim-window-picker]</small>
| <kbd>sw</kbd> | 𝐍 | Switch editing window with selected | <small>[s1n7ax/nvim-window-picker]</small>
| <kbd>sv</kbd> | 𝐍 | Horizontal split | <small>`:split`</small>
| <kbd>sg</kbd> | 𝐍 | Vertical split | <small>`:vsplit`</small>
| <kbd>st</kbd> | 𝐍 | Open new tab | <small>`:tabnew`</small>
| <kbd>so</kbd> | 𝐍 | Close other windows | <small>`:only`</small>
| <kbd>sb</kbd> | 𝐍 | Previous buffer | <small>`:b#`</small>
| <kbd>sc</kbd> | 𝐍 | Close current buffer | <small>`:close`</small>
| <kbd>sd</kbd> | 𝐍 | Delete buffer | <small>`:bdelete`</small>
| <kbd>sq</kbd> | 𝐍 | Quit window | <small>`:quit`</small>
| <kbd>sx</kbd> | 𝐍 | Delete buffer, leave blank window | <small>`:enew │ bdelete`</small>
| <kbd>sz</kbd> | 𝐍 | Toggle window zoom | <small>`:vertical resize │ resize`</small>
| <kbd>sh</kbd> | 𝐍 | Toggle colorscheme background=dark/light | <small>`:set background` …

### Plugins

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>;</kbd>+<kbd>c</kbd> | 𝐍 | Open context-menu | <small>[lua/rafi/util/contextmenu.lua]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>o</kbd> | 𝐍 | Navigate to previous file on jumplist | <small>[util/edit.lua]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>i</kbd> | 𝐍 | Navigate to next file on jumplist | <small>[util/edit.lua]</small>
| <kbd>Ctrl</kbd>+<kbd>/</kbd> | 𝐍 | Toggle terminal | <small>[akinsho/toggleterm.nvim]</small>
| <kbd>Space</kbd> <kbd>l</kbd> | 𝐍 | Open Lazy | <small>[folke/lazy.nvim]</small>
| <kbd>Space</kbd> <kbd>o</kbd> | 𝐍 | Open Outline side | <small>[hedyhli/outline.nvim]</small>
| <kbd>Space</kbd> <kbd>?</kbd> | 𝐍 | Open the macOS dictionary on current word | <small>`:!open dict://`</small>
| <kbd>Space</kbd> <kbd>cp</kbd> | 𝐍 | Toggle Markdown preview | <small>iamcco/markdown-preview.nvim</small>
| <kbd>Space</kbd> <kbd>P</kbd> | 𝐍 | Use Marked 2 for real-time Markdown preview | <small>[Marked 2]</small>
| <kbd>Space</kbd> <kbd>mc</kbd> | 𝐍 | Open color-picker | <small>[uga-rosa/ccc.nvim]</small>
| <kbd>Space</kbd> <kbd>tt</kbd> | 𝐍 | Open terminal (root dir) | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>tT</kbd> | 𝐍 | Open terminal (cwd) | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>tg</kbd> | 𝐍 | Open Lazygit (root dir) | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>tG</kbd> | 𝐍 | Open Lazygit (cwd) | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>gu</kbd> | 𝐍 | Open undo-tree | <small>[mbbill/undotree]</small>
| <kbd>Space</kbd> <kbd>gb</kbd> | 𝐍 | Git blame | <small>[FabijanZulj/blame.nvim]</small>
| <kbd>Space</kbd> <kbd>gB</kbd> | 𝐍 | Git blame in window | <small>[FabijanZulj/blame.nvim]</small>
| <kbd>Space</kbd> <kbd>gm</kbd> | 𝐍 | Reveal commit under cursor | <small>[rhysd/git-messenger.vim]</small>
| <kbd>Space</kbd> <kbd>go</kbd> | 𝐍 𝐕 | Open SCM detailed URL in browser | <small>[ruifm/gitlinker.nvim]</small>
| <kbd>Space</kbd> <kbd>mg</kbd> | 𝐍 | Open Neogit | <small>[NeogitOrg/neogit]</small>
| <kbd>Space</kbd> <kbd>ml</kbd> | 𝐍 | Append modeline to end of buffer | <small>[config/keymaps.lua]</small>
| <kbd>Space</kbd> <kbd>mda</kbd> | 𝐕 | Sequentially mark region for diff | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd> <kbd>mdf</kbd> | 𝐕 | Mark region for diff and compare if more than one | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd> <kbd>mds</kbd> | 𝐍 | Shows the comparison for all marked regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd> <kbd>mdr</kbd> | 𝐍 | Removes the signs denoting the diff regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd> <kbd>mh</kbd> | 𝐍 | Open HTTP Rest UI | <small>[rest-nvim/rest.nvim]</small>
| <kbd>Space</kbd> <kbd>mt</kbd> | 𝐍 𝐕 | Toggle highlighted word | <small>[t9md/vim-quickhl]</small>
| <kbd>Space</kbd> <kbd>mo</kbd> | 𝐍 | Update Markdown TOC | <small>[mzlogin/vim-markdown-toc]</small>
| <kbd>Space</kbd> <kbd>zz</kbd> | 𝐍 | Toggle distraction-free writing | <small>[folke/zen-mode.nvim]</small>

#### Plugin: Mini.Surround

See [echasnovski/mini.surround] for more mappings and usage information.

| Key            | Mode  | Action                       |
| -------------- |:-----:| ---------------------------- |
| <kbd>sa</kbd> & movement  | 𝐍 𝐕 | Add surrounding |
| <kbd>cs</kbd> & movement  | 𝐍   | Replace surrounding |
| <kbd>ds</kbd> & movement  | 𝐍   | Delete surrounding |
| <kbd>gzf</kbd> & movement | 𝐍   | Find surrounding (to the right) |
| <kbd>gzF</kbd> & movement | 𝐍   | Find surrounding (to the left) |
| <kbd>gzh</kbd> & movement | 𝐍   | Highlight surrounding |
| <kbd>gzn</kbd> & movement | 𝐍   | Update neighbor lines |

#### Plugin: Gitsigns

See [lewis6991/gitsigns.nvim] for more mappings and usage information.

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>]g</kbd> or <kbd>]g</kbd> | 𝐍 | Next/previous Git hunk |
| <kbd>gs</kbd>                  | 𝐍 | Preview hunk |
| <kbd>Space</kbd> <kbd>hp</kbd> | 𝐍 | Preview hunk inline |
| <kbd>Space</kbd> <kbd>hb</kbd> | 𝐍 | Blame line |
| <kbd>Space</kbd> <kbd>hs</kbd> | 𝐍 𝐕 | Stage hunk |
| <kbd>Space</kbd> <kbd>hr</kbd> | 𝐍 𝐕 | Reset hunk |
| <kbd>Space</kbd> <kbd>hu</kbd> | 𝐍 | Undo stage hunk |
| <kbd>Space</kbd> <kbd>hS</kbd> | 𝐍 | Stage buffer |
| <kbd>Space</kbd> <kbd>hR</kbd> | 𝐍 | Reset buffer |
| <kbd>Space</kbd> <kbd>hd</kbd> | 𝐍 | Diff against the index |
| <kbd>Space</kbd> <kbd>hD</kbd> | 𝐍 | Diff against the last commit |
| <kbd>Space</kbd> <kbd>hw</kbd> | 𝐍 | Toggle word diff |
| <kbd>Space</kbd> <kbd>hl</kbd> | 𝐍 | Publish hunks to location-list |
| <kbd>Space</kbd> <kbd>htb</kbd> | 𝐍 | Toggle git current line blame |
| <kbd>Space</kbd> <kbd>htd</kbd> | 𝐍 | Toggle git deleted |
| <kbd>Space</kbd> <kbd>htw</kbd> | 𝐍 | Toggle git word diff |
| <kbd>Space</kbd> <kbd>htl</kbd> | 𝐍 | Toggle git line highlight |
| <kbd>Space</kbd> <kbd>htn</kbd> | 𝐍 | Toggle git number highlight |
| <kbd>Space</kbd> <kbd>hts</kbd> | 𝐍 | Toggle git signs |
| <kbd>ih</kbd>                  | 𝐎 | Select inner hunk operator |

#### Plugin: Diffview

See [sindrets/diffview.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd> <kbd>gd</kbd> | 𝐍 | Diff view file history
| <kbd>Space</kbd> <kbd>gv</kbd> | 𝐍 | Diff view open
| **Within _diffview_ "view" window** ||
| <kbd>Tab</kbd> / <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐍 | Select next/previous entry
| <kbd>;</kbd> <kbd>a</kbd>    | 𝐍 | Focus file
| <kbd>;</kbd> <kbd>e</kbd>    | 𝐍 | Toggle files panel
| **Within _diffview_ "file" panel** ||
| <kbd>q</kbd>                 | 𝐍 | Close
| <kbd>h</kbd>                 | 𝐍 | Previous entry
| <kbd>o</kbd>                 | 𝐍 | Focus entry
| <kbd>gf</kbd>                | 𝐍 | Open file
| <kbd>sg</kbd>                | 𝐍 | Open file in split
| <kbd>st</kbd>                | 𝐍 | Open file in new tab
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | 𝐍 | Refresh files
| <kbd>;</kbd> <kbd>e</kbd>    | 𝐍 | Toggle panel
| **Within _diffview_ "history" panel** ||
| <kbd>q</kbd>                 | 𝐍 | Close diffview
| <kbd>o</kbd>                 | 𝐍 | Focus entry
| <kbd>O</kbd>                 | 𝐍 | Show options

#### Plugin: Telescope

See [telescope.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;r</kbd> | 𝐍 | Results of the previous picker
| <kbd>;p</kbd> | 𝐍 | List of the previous pickers
| <kbd>;f</kbd> | 𝐍 | File search
| <kbd>;g</kbd> | 𝐍 | Grep search
| <kbd>;b</kbd> | 𝐍 | Buffers
| <kbd>;h</kbd> | 𝐍 | Highlights
| <kbd>;j</kbd> | 𝐍 | Jump points
| <kbd>;m</kbd> | 𝐍 | Marks
| <kbd>;o</kbd> | 𝐍 | Vim options
| <kbd>;t</kbd> | 𝐍 | LSP workspace symbols
| <kbd>;v</kbd> | 𝐍 𝐕 | Yank history
| <kbd>;n</kbd> | 𝐍 | Plugins
| <kbd>;k</kbd> | 𝐍 | Thesaurus
| <kbd>;u</kbd> | 𝐍 | Spelling suggestions
| <kbd>;x</kbd> | 𝐍 | Old files
| <kbd>;w</kbd> | 𝐍 | Zk notes
| <kbd>;z</kbd> | 𝐍 | Zoxide directories
| <kbd>;;</kbd> | 𝐍 | Command history
| <kbd>;:</kbd> | 𝐍 | Commands
| <kbd>;/</kbd> | 𝐍 | Search history
| <kbd>;dd</kbd> | 𝐍 | LSP definitions
| <kbd>;di</kbd> | 𝐍 | LSP implementations
| <kbd>;dr</kbd> | 𝐍 | LSP references
| <kbd>;da</kbd> | 𝐍 𝐕 | LSP code actions
| <kbd>Space</kbd> <kbd>/</kbd> | 𝐍 | Buffer fuzzy find
| <kbd>Space</kbd> <kbd>gs</kbd> | 𝐍 | Git status
| <kbd>Space</kbd> <kbd>gr</kbd> | 𝐍 | Git branches
| <kbd>Space</kbd> <kbd>gl</kbd> | 𝐍 | Git commits
| <kbd>Space</kbd> <kbd>gL</kbd> | 𝐍 | Git buffer commits
| <kbd>Space</kbd> <kbd>gh</kbd> | 𝐍 | Git stashes
| <kbd>Space</kbd> <kbd>gt</kbd> | 𝐍 | Find symbols matching word under cursor
| <kbd>Space</kbd> <kbd>gf</kbd> | 𝐍 | Find files matching word under cursor
| <kbd>Space</kbd> <kbd>gg</kbd> | 𝐍 𝐕 | Grep word under cursor
| <kbd>Space</kbd> <kbd>sc</kbd> | 𝐍 | Colorschemes
| <kbd>Space</kbd> <kbd>sd</kbd> | 𝐍 | Document diagnostics
| <kbd>Space</kbd> <kbd>sD</kbd> | 𝐍 | Workspace diagnostics
| <kbd>Space</kbd> <kbd>sh</kbd> | 𝐍 | Help tags
| <kbd>Space</kbd> <kbd>sk</kbd> | 𝐍 | Key-maps
| <kbd>Space</kbd> <kbd>sm</kbd> | 𝐍 | Man pages
| <kbd>Space</kbd> <kbd>ss</kbd> | 𝐍 | LSP document symbols
| <kbd>Space</kbd> <kbd>sS</kbd> | 𝐍 | LSP workspace symbols
| <kbd>Space</kbd> <kbd>st</kbd> | 𝐍 | Todo list
| <kbd>Space</kbd> <kbd>sT</kbd> | 𝐍 | Todo/Fix/Fixme list
| <kbd>Space</kbd> <kbd>sw</kbd> | 𝐍 | Grep string
| **Within _Telescope_ window** ||
| <kbd>?</kbd> | 𝐍 | Keymaps help screen
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 𝐍 | Move from none fuzzy search to fuzzy
| <kbd>jj</kbd> or <kbd>Escape</kbd> | 𝐈 | Leave Insert mode
| <kbd>i</kbd> | 𝐍 | Enter Insert mode (filter input)
| <kbd>q</kbd> or <kbd>Escape</kbd> | 𝐍 | Exit Telescope
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐍 𝐈 | Next/previous candidate
| <kbd>Ctrl</kbd>+<kbd>d</kbd>/<kbd>u</kbd> | 𝐍 𝐈 | Scroll down/upwards
| <kbd>Ctrl</kbd>+<kbd>f</kbd>/<kbd>b</kbd> | 𝐍 𝐈 | Scroll preview down/upwards
| <kbd>Ctrl</kbd>+<kbd>j</kbd>/<kbd>k</kbd> | 𝐍 𝐈 | Scroll preview vertically
| <kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>l</kbd> | 𝐍 𝐈 | Scroll preview horizontally
| <kbd>J</kbd> or <kbd>K</kbd> | 𝐍 | Select candidates up/downwards
| <kbd>st</kbd> | 𝐍 | Open in a new tab
| <kbd>sg</kbd> | 𝐍 | Open in a vertical split
| <kbd>sv</kbd> | 𝐍 | Open in a split
| <kbd>*</kbd>  | 𝐍 | Toggle selection
| <kbd>u</kbd>  | 𝐍 | Drop all
| <kbd>w</kbd>  | 𝐍 | Smart send to quickfix list
| <kbd>e</kbd>  | 𝐍 | Send to quickfix list
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | 𝐈 | Send to quickfix list
| <kbd>dd</kbd> | 𝐍 | Delete entry (buffer list)
| <kbd>!</kbd> | 𝐍 | Edit in command line

#### Plugin: Neo-Tree

See [nvim-neo-tree/neo-tree.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>fe</kbd> / <kbd>Space</kbd><kbd>e</kbd> | 𝐍 | Toggle file explorer (root)
| <kbd>fE</kbd> / <kbd>Space</kbd><kbd>E</kbd> | 𝐍 | Toggle file explorer (cwd)
| <kbd>ge</kbd> | 𝐍 | Open Git explorer
| <kbd>be</kbd> | 𝐍 | Open Buffer explorer
| <kbd>xe</kbd> | 𝐍 | Open Document explorer
| <kbd>;a</kbd> | 𝐍 | Focus current file in file-explorer
| **Within _Neo-Tree_ window** ||
| <kbd>g?</kbd> | 𝐍 | Show help
| <kbd>q</kbd> | 𝐍 | Close window
| <kbd>j</kbd> or <kbd>k</kbd> | 𝐍 | Move up and down the tree
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐍 | Next or previous source
| <kbd>]g</kbd> or <kbd>[g</kbd> | 𝐍 | Jump to next/previous git modified node
| <kbd>l</kbd> | 𝐍 | Toggle collapse/expand directory or open file
| <kbd>h</kbd> | 𝐍 | Collapse directory tree
| <kbd>Return</kbd> | 𝐍 | Select window to open file
| <kbd>gr</kbd> | 𝐍 | Grep in current position
| <kbd>gf</kbd> | 𝐍 | Find files in current position
| <kbd>.</kbd> | 𝐍 | Set as root directory
| <kbd>Backspace</kbd> | 𝐍 | Change into parent directory
| <kbd>sv</kbd> or <kbd>S</kbd> | 𝐍 | Open file in a horizontal split
| <kbd>sg</kbd> or <kbd>s</kbd> | 𝐍 | Open file in a vertical split
| <kbd>st</kbd> or <kbd>t</kbd> | 𝐍 | Open file in new tab
| <kbd>p</kbd> | 𝐍 | Preview toggle
| <kbd>a</kbd> | 𝐍 | Create new directories and/or files
| <kbd>N</kbd> | 𝐍 | Create new directory
| <kbd>r</kbd> | 𝐍 | Rename file or directory
| <kbd>dd</kbd> | 𝐍 | Delete
| <kbd>c</kbd> / <kbd>m</kbd> | 𝐍 | Copy/move
| <kbd>y</kbd> / <kbd>x</kbd> / <kbd>P</kbd> | 𝐍 | Clipboard copy/cut/paste
| <kbd>!</kbd> | 𝐍 | Filter
| <kbd>D</kbd> | 𝐍 | Filter directories
| <kbd>#</kbd> | 𝐍 | Fuzzy sorter
| <kbd>F</kbd> | 𝐍 | Filter on submit
| <kbd>Ctrl</kbd>+<kbd>c</kbd> | 𝐍 | Clear filter
| <kbd>Ctrl</kbd>+<kbd>r</kbd> or <kbd>R</kbd> | 𝐍 | Refresh
| <kbd>fi</kbd> / <kbd>fe</kbd> | 𝐍 | Include/exclude
| <kbd>H</kbd> | 𝐍 | Toggle hidden files
| <kbd>e</kbd> | 𝐍 | Toggle auto-expand window width
| <kbd>w</kbd> | 𝐍 | Toggle window width
| <kbd>z</kbd> | 𝐍 | Collapse all nodes

#### Plugin: Spectre

See [nvim-pack/nvim-spectre] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>sp</kbd> | 𝐍 | Open Spectre window (search & replace)
| <kbd>Space</kbd>+<kbd>sp</kbd> | 𝐕 | Open Spectre with selection

#### Plugin: Marks

See [chentau/marks.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>m,</kbd> | 𝐍 | Set the next available alphabetical (lowercase) mark
| <kbd>m;</kbd> | 𝐍 | Toggle the next available mark at the current line
| <kbd>m</kbd> <kbd>a-z</kbd> | 𝐍 | Set mark
| <kbd>dm</kbd> <kbd>a-z</kbd> | 𝐍 | Remove mark
| <kbd>dm-</kbd> | 𝐍 | Delete all marks on the current line
| <kbd>dm\<Space></kbd> | 𝐍 | Delete all marks in the current buffer
| <kbd>m]</kbd> | 𝐍 | Move to next mark
| <kbd>m[</kbd> | 𝐍 | Move to previous mark
| <kbd>m:</kbd> <kbd>a-z</kbd> | 𝐍 | Preview mark
| <kbd>m/</kbd> | 𝐍 | List marks from all opened buffers

#### Plugin: Zk

See [zk-org/zk-nvim] and [zk](https://github.com/zk-org/zk) for
more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>zn</kbd> | 𝐍 | Ask for title and create new note
| <kbd>Space</kbd>+<kbd>zo</kbd> | 𝐍 | Browse notes sorted by modification time
| <kbd>Space</kbd>+<kbd>zt</kbd> | 𝐍 | Browse tags
| <kbd>Space</kbd>+<kbd>zf</kbd> | 𝐍 | Search notes
| <kbd>Space</kbd>+<kbd>zf</kbd> | 𝐕 | Search notes with selection
| <kbd>Space</kbd>+<kbd>zb</kbd> | 𝐍 | Show backlinks
| <kbd>Space</kbd>+<kbd>zl</kbd> | 𝐍 | Show links

</details>

[Neovim]: https://github.com/neovim/neovim
[lazy.nvim]: https://github.com/folke/lazy.nvim
[lua/rafi/plugins/lsp/init.lua]: ./lua/rafi/plugins/lsp/init.lua
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[config/keymaps.lua]: ./lua/rafi/config/keymaps.lua
[util/edit.lua]: ./lua/rafi/util/edit.lua
[plugins/lsp/keymaps.lua]: ./lua/rafi/plugins/lsp/keymaps.lua
[lua/rafi/util/contextmenu.lua]: ./lua/rafi/util/contextmenu.lua
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Marked 2]: https://marked2app.com
[www.lazyvim.org/extras]: https://www.lazyvim.org/extras
