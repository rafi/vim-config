# Rafael Bodill's Neovim Config

Lean mean Neovim machine, 30-45ms startup time. Works best with [Neovim] ≥0.8

:warning: **BREAKING CHANGES:** The last major update uses [lazy.nvim] for
plugin management, and an entire Lua rewrite.
Please read "[Extending](#extending)" to learn how to customize and modify.

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
  * [Extend: Disable some features](#extend-disable-some-features)
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
  * [Extra Plugins: Diagnostics](#extra-plugins-diagnostics)
  * [Extra Plugins: Editor](#extra-plugins-editor)
  * [Extra Plugins: Formatting](#extra-plugins-formatting)
  * [Extra Plugins: LSP](#extra-plugins-lsp)
  * [Extra Plugins: Org](#extra-plugins-org)
  * [Extra Plugins: Treesitter](#extra-plugins-treesitter)
  * [Extra Plugins: UI](#extra-plugins-ui)
* [Custom Key-mappings](#custom-key-mappings)
  * [Navigation](#navigation)
  * [File Operations](#file-operations)
  * [Auto-Completion](#auto-completion)
  * [Edit](#edit)
  * [Search & Replace](#search--replace)
  * [Clipboard](#clipboard)
  * [Command & History](#command--history)
  * [Diagnostics](#diagnostics)
  * [Editor UI](#editor-ui)
  * [Custom Tools & Plugins](#custom-tools--plugins)
  * [Window Management](#window-management)
  * [Plugin: Mini.Bracketed](#plugin-minibracketed)
  * [Plugin: Mini.Surround](#plugin-minisurround)
  * [Plugin: Gitsigns](#plugin-gitsigns)
  * [Plugin: Fugitive](#plugin-fugitive)
  * [Plugin: Telescope](#plugin-telescope)
  * [Plugin: Neo-Tree](#plugin-neo-tree)
  * [Plugin: Spectre](#plugin-spectre)
  * [Plugin: Marks](#plugin-marks)

<!-- vim-markdown-toc -->
</details>

## Features

* Fast startup time — plugins are almost entirely lazy-loaded!
* Robust, yet light-weight
* Plugin management with [folke/lazy.nvim]. Use with `:Lazy` or <kbd>Space</kbd>+<kbd>l</kbd>
* Install LSP, DAP, linters, and formatters. Use with `:Mason` or <kbd>Space</kbd>+<kbd>mm</kbd>
* LSP configuration with [nvim-lspconfig] and [folke/neoconf.nvim] (see [neoconf.json])
* [telescope.nvim] centric work-flow with lists (try <kbd>;</kbd>+<kbd>f</kbd>…)
* Custom context-menu (try it! <kbd>;</kbd>+<kbd>c</kbd>)
* Auto-complete extensive setup with [nvim-cmp]
  (try <kbd>Tab</kbd> or <kbd>Ctrl</kbd>+<kbd>Space</kbd> in insert-mode)
* Structure view with [simrat39/symbols-outline.nvim]
* Git features using [tpope/vim-fugitive] and [lewis6991/gitsigns.nvim]
* Auto-save and restore sessions with [olimorris/persisted.nvim]
* Unobtrusive, yet informative status & tab lines
* Premium color-schemes
* Remembers last-used colorscheme

## Screenshot

![Vim screenshot](http://rafi.io/static/img/project/vim-config/features.png)

## Prerequisites

* [git](https://git-scm.com/) ≥ 2.19.0 (`brew install git`)
* [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) ≥ v0.8.0
  (`brew install neovim`)

**Optional**, but highly recommended:

* [bat](https://github.com/sharkdp/bat) (`brew install bat`)
* [fd](https://github.com/sharkdp/fd) (`brew install fd`)
* [fzf](https://github.com/junegunn/fzf) (`brew install fzf`)
* [ripgrep](https://github.com/BurntSushi/ripgrep) (`brew install ripgrep`)
* [zoxide](https://github.com/ajeetdsouza/zoxide) (`brew install zoxide`)

## Install

**_1._** Let's clone this repo! Clone to `~/.config/nvim`

```bash
mkdir -p ~/.config
git clone git@github.com:rafi/vim-config.git ~/.config/nvim
cd ~/.config/nvim
```

**_2._** Run `nvim` (will install all plugins the first time).

It's highly recommended running `:checkhealth` to ensure your system is healthy
and meet the requirements.

Enjoy! :smile:

## Install LSP, DAP, Linters, Formatters

Use `:Mason` to install and manage LSP servers, DAP servers, linters and
formatters. See `:h mason.nvim` and [williamboman/mason.nvim] for more
information.

### Language-Server Protocol (LSP)

You can install LSP servers using `:Mason` UI, or `:MasonInstall <name>`,
or `:LspInstall <name>` (use <kbd>Tab</kbd> to list available servers).
See Mason's [PACKAGES.md](https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md)
for the official list, and the [Language server mapping](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)
list. You can also view at `:h mason-lspconfig-server-map`

You'll need utilities like `npm` and `curl` to install some extensions, see
[requirements](https://github.com/williamboman/mason.nvim#requirements)
(or `:h mason-requirements`) for more information.

See [neoconf.json] and [lua/rafi/plugins/lsp/init.lua] for custom key-mappings
and configuration for some language-servers.

### Recommended LSP

```viml
:MasonInstall ansible-language-server bash-language-server css-lsp
:MasonInstall dockerfile-language-server gopls html-lsp json-lsp
:MasonInstall lua-language-server marksman pyright sqlls
:MasonInstall svelte-language-server typescript-language-server
:MasonInstall tailwindcss-language-server
:MasonInstall vim-language-server yaml-language-server
```

and [more](https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)…

### Recommended Linters

```viml
:MasonInstall vint shellcheck editorconfig-checker flake8 gitlint hadolint
:MasonInstall markdownlint mypy selene shellharden write-good yamllint
```

### Recommended Formatters

```viml
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

* [init.lua](./init.lua) — Entry-point, plugin initialization.
* [neoconf.json](./neoconf.json) — LSP servers options.
* [after/](./after) — Language specific custom settings and plugins.
* [lua/](./lua) — Lua configurations
  * **config/** — Custom user configuration
  * **plugins/** — Custom user plugins (or `lua/plugins.lua`)
  * **lsp/** — Custom user LSP configurations
  * [rafi/](./lua/rafi)
    * [config/](./lua/config) — Neovim configurations
      * [autocmd.lua](./lua/rafi/config/autocmd.lua) — Auto-commands
      * [init.lua](./lua/rafi/config/init.lua) — initialization
      * [keymaps.lua](./lua/rafi/config/keymaps.lua) — Key-mappings
      * [options.lua](./lua/rafi/config/options.lua) — Editor settings
    * [lib/](./lua/lib) — Libraries
    * [plugins/](./lua/plugins) — Plugins and configurations
* [snippets/](./snippets) — Personal code snippets
* [themes/](./themes) — Colorscheme overrides

## Extending

### Extend: Config

There are 2 distinct ways to extend configuration:

1. The second option is to fork this repository and create a directory
   `lua/config` with one or more of these files:

   * `lua/config/autocmds.lua` — Custom auto-commands
   * `lua/config/options.lua` — Custom options
   * `lua/config/keymaps.lua` — Custom key-mappings

   Adding plugins or override existing options:
   * `lua/plugins/*.lua` or `lua/plugins.lua` — Plugins (See [lazy.nvim] for
     syntax)

   This option is recommended if you're not planning on customizing a lot, or
   you'd like to keep a close look of source-code.

2. Create your own clean `~/.config/nvim`, and leverage [lazy.nvim] to import
   my configuration specs. You can use [LazyVim/starter] and just change
   `lua/plugins/example.lua` to:

   ```lua
   return {
     {
       "rafi/vim-config",      -- Will load ALL my plugins and config/*
       opts = true,
     },
     { import = "plugins" },   -- Your local lua/plugins*
   }
   ```

   This will import and set up my `lua/config/*` and `lua/plugins/*`, and
   then yours. You can import specific plugin bundles, for example:

   ```lua
   return {
    {
      "rafi/vim-config",
      import = "rafi.plugins.colorscheme"
    },
    { import = "rafi.plugins.editor" },
    { import = "rafi.plugins.ui" },

    { import = "plugins" },  -- Your local lua/plugins*
   }
   ```

   This example will **NOT** load my `lua/config/*`, and only install plugins
   categorically from `colorscheme.lua`, `editor.lua`, and `ui.lua`. At last,
   it will load your plugins defined in `lua/plugins.lua` or `lua/plugins/*`.

   This option has the advantage of partially importing different "plugin
   specs" from various sources.

### Extend: Plugins

For installing/overriding/disabling plugins, create a `lua/plugins/foo.lua`
file (or `lua/plugins/foo/bar.lua` or simply `lua/plugins.lua`) and manage your
own plugin collection. You can add or override existing plugins' options, or
just disable them all-together. Here's an example:

```lua
return {
  { 'shadmansaleh/lualine.nvim', enabled = false },

  { 'limorris/persisted.nvim', enabled = false },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = {
        'bash', 'c', 'clojure', 'cmake', 'comment', 'commonlisp', 'cpp',
        'css', 'dart', 'diff', 'dockerfile', 'dot', 'elixir', 'elm',
        'erlang', 'fennel', 'fish', 'gitcommit', 'gitignore', 'gitattributes',
        'git_rebase', 'go', 'gomod', 'gosum', 'gowork', 'graphql', 'hack',
        'haskell', 'hcl', 'help', 'html', 'http', 'java', 'javascript',
        'jsdoc', 'json', 'json5', 'jsonc', 'jsonnet', 'julia', 'kotlin',
        'latex', 'llvm', 'lua', 'make', 'markdown', 'markdown_inline',
        'ninja', 'nix', 'norg', 'perl', 'php', 'pug', 'python', 'query', 'r',
        'regex', 'rst', 'ruby', 'rust', 'scala', 'scheme', 'scss', 'solidity',
        'sql', 'svelte', 'swift', 'terraform', 'todotxt', 'toml', 'tsx',
        'typescript', 'vala', 'vim', 'vue', 'yaml', 'zig',
      },
    },
  },

  -- Choose only ONE of these statuslines ;)
  { 'itchyny/lightline.vim' },
  { 'vim-airline/vim-airline' },
  { 'glepnir/galaxyline.nvim' },
  { 'glepnir/spaceline.vim' },
  { 'liuchengxu/eleline.vim' },
}
```

### Extend: Disable some features

You can set & toggle **global specific features** by defining in your local
`/.vault.vim`:

```vim
let g:elite_mode = 1                     " Set arrow-keys to window resize
let g:disable_mappings = 0               " Disable lua/rafi/config/keymaps.lua
let g:enable_universal_quit_mapping = 0  " Disable normal 'q' mapping
```

### Extend: LSP Settings

To override **LSP configurations**, you can do either:

1. Customize `neoconf.json` or per project's `.neoconf.json`

2. Or, override server options with nvim-lspconfig plugin, for example:

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

3. Or, create a `lua/lsp/<server_name>.lua` file. Must return a table with
   `config` function. For example, create `lua/lsp/go.lua`:

   ```lua
   local config = {
     settings = {
       gopls = {
         staticcheck = true
       }
     }
   }

   return {
     config = function()
       return config
     end
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
  <summary><strong>List</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

### Completion & Code-Analysis

| Name           | Description
| -------------- | ----------------------
| [neovim/nvim-lspconfig] | Quickstart configurations for the Nvim LSP client
| [folke/neoconf.nvim] | Manage global and project-local settings
| [folke/neodev.nvim] | Neovim setup for init.lua and plugin development
| [williamboman/mason.nvim] | Portable package manager for Neovim
| [williamboman/mason-lspconfig.nvim] | Mason extension for easier lspconfig integration
| [hrsh7th/cmp-nvim-lsp] | nvim-cmp source for neovim builtin LSP client
| [b0o/SchemaStore.nvim] | JSON schemas for Neovim
| [jose-elias-alvarez/null-ls.nvim] | Inject LSP diagnostics, code actions, and more

### Editor Plugins

| Name           | Description
| -------------- | ----------------------
| [folke/lazy.nvim] | Modern plugin manager for Neovim
| [christoomey/tmux-navigator] | Seamless navigation between tmux panes and vim splits
| [tweekmonster/helpful.vim] | Display vim version numbers in docs
| [lambdalisue/suda.vim] | An alternative sudo for Vim and Neovim
| [tpope/vim-sleuth] | Heuristically set buffer indent options
| [olimorris/persisted.nvim] | Simple session management for Neovim with git branching
| [RRethy/vim-illuminate] | Highlights other uses of the word under the cursor
| [mbbill/undotree] | Ultimate undo history visualizer
| [ggandor/flit.nvim] | Enhanced f/t motions for Leap
| [ggandor/leap.nvim] | General-purpose motion plugin
| [kana/vim-niceblock] | Make blockwise Visual mode more useful
| [haya14busa/vim-edgemotion] | Jump to the edge of block
| [folke/zen-mode.nvim] | Distraction-free coding for Neovim
| [folke/which-key.nvim] | Create key bindings that stick
| [tversteeg/registers.nvim] | Preview the contents of the registers
| [folke/todo-comments.nvim] | Highlight, list and search todo comments in your projects
| [folke/trouble.nvim] | Pretty lists to help you solve all code diagnostics
| [sindrets/diffview.nvim] | Tabpage interface for cycling through diffs
| [simrat39/symbols-outline.nvim] | Tree like view for symbols using LSP
| [s1n7ax/nvim-window-picker] | Window picker
| [rest-nvim/rest.nvim] | Fast Neovim http client written in Lua
| [mickael-menu/zk-nvim] | Extension for the zk plain text note-taking assistant
| [windwp/nvim-spectre] | Find the enemy and replace them with dark power
| [echasnovski/mini.bufremove] | Helper for removing buffers
| [mzlogin/vim-markdown-toc] | Generate table of contents for Markdown files

### Coding Plugins

| Name           | Description
| -------------- | ----------------------
| [sbdchd/neoformat] | Format code with numerous tools
| [hrsh7th/nvim-cmp] | Completion plugin for neovim written in Lua
| [hrsh7th/cmp-buffer] | nvim-cmp source for buffer words
| [hrsh7th/cmp-path] | nvim-cmp source for path
| [hrsh7th/cmp-emoji] | nvim-cmp source for emoji
| [saadparwaiz1/cmp_luasnip] | Luasnip completion source for nvim-cmp
| [andersevenrud/compe-tmux] | Tmux completion source for nvim-compe/cmp
| [L3MON4D3/LuaSnip] | Snippet Engine written in Lua
| [rafamadriz/friendly-snippets] | Preconfigured snippets for different languages
| [ziontee113/SnippetGenie] | Snippet creation tool
| [echasnovski/mini.pairs] | Automatically manage character pairs
| [echasnovski/mini.surround] | Fast and feature-rich surround actions
| [JoosepAlviste/nvim-ts-context-commentstring] | Set the commentstring based on the cursor location
| [echasnovski/mini.comment] | Fast and familiar per-line commenting
| [echasnovski/mini.trailspace] | Trailing whitespace highlight and remove
| [echasnovski/mini.bracketed] | Go forward/backward with square brackets
| [echasnovski/mini.ai] | Extend and create `a`/`i` textobjects
| [echasnovski/mini.splitjoin] | Split and join arguments
| [AndrewRadev/linediff.vim] | Perform diffs on blocks of code
| [AndrewRadev/dsf.vim] | Delete surrounding function call

### Colorscheme Plugins

| Name           | Description
| -------------- | ----------------------
| [rafi/awesome-colorschemes] | Awesome color-schemes
| [AlexvZyl/nordic.nvim] | Nord for Neovim, but warmer and darker
| [folke/tokyonight.nvim] | Clean, dark Neovim theme
| [rebelot/kanagawa.nvim] | Inspired by the colors of the famous painting by Katsushika Hokusai
| [olimorris/onedarkpro.nvim] | OneDarkPro theme
| [EdenEast/nightfox.nvim] | Highly customizable theme
| [catppuccin/nvim] | Soothing pastel theme
| [nyoom-engineering/oxocarbon.nvim] | Dark and light theme inspired by IBM Carbon

### Git Plugins

| Name           | Description
| -------------- | ----------------------
| [lewis6991/gitsigns.nvim] | Git signs written in pure lua
| [TimUntersberger/neogit] | Magit clone for Neovim
| [tpope/vim-fugitive] | Git client
| [junegunn/gv.vim] | Git log browser
| [rhysd/committia.vim] | Pleasant editing on Git commit messages

### Misc Plugins

| Name           | Description
| -------------- | ----------------------
| [hoob3rt/lualine.nvim] | statusline plugin written in pure lua
| [nvim-neo-tree/neo-tree.nvim] | File explorer written in Lua
| [nvim-telescope/telescope.nvim] | Find, Filter, Preview, Pick. All lua.
| [nvim-telescope/telescope-ui-select.nvim] | Sets vim.ui.select to telescope
| [jvgrootveld/telescope-zoxide] | Telescope extension for Zoxide
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
| [kevinhwang91/nvim-ufo] | Make folds look modern and keep a high performance
| [iloginow/vim-stylus] | Better vim plugin for stylus
| [chrisbra/csv.vim] | Handling column separated data
| [towolf/vim-helm] | Syntax for Helm templates (yaml + gotmpl + sprig)
| [mustache/vim-mustache-handlebars] | Mustache and handlebars syntax
| [lifepillar/pgsql.vim] | PostgreSQL syntax and indent
| [MTDL9/vim-log-highlighting] | Syntax highlighting for generic log files
| [tmux-plugins/vim-tmux] | Plugin for tmux.conf
| [reasonml-editor/vim-reason-plus] | Reason syntax and indent
| [vmchale/just-vim] | Syntax highlighting for Justfiles
| [pearofducks/ansible-vim] | Improved YAML support for Ansible

### UI Plugins

| Name           | Description
| -------------- | ----------------------
| [nvim-tree/nvim-web-devicons] | Lua fork of vim-devicons
| [MunifTanjim/nui.nvim] | UI Component Library
| [folke/noice.nvim] | Replaces the UI for messages, cmdline and the popupmenu
| [SmiteshP/nvim-navic] | Shows your current code context in winbar/statusline
| [rcarriga/nvim-notify] | Fancy notification manager for NeoVim
| [chentau/marks.nvim] | Interacting with and manipulating marks
| [lukas-reineke/indent-blankline.nvim] | Visually display indent levels
| [t9md/vim-quickhl] | Highlight words quickly
| [kevinhwang91/nvim-bqf] | Better quickfix window in Neovim
| [uga-rosa/ccc.nvim] | Super powerful color picker/colorizer plugin
| [dnlhc/glance.nvim] | Pretty window for navigating LSP locations
| [itchyny/calendar.vim] | Calendar application

[neovim/nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[folke/neoconf.nvim]: https://github.com/folke/neoconf.nvim
[folke/neodev.nvim]: https://github.com/folke/neodev.nvim
[williamboman/mason.nvim]: https://github.com/williamboman/
[williamboman/mason-lspconfig.nvim]: https://github.com/williamboman/mason-lspconfig.nvim
[hrsh7th/cmp-nvim-lsp]: https://github.com/hrsh7th/cmp-nvim-lsp
[b0o/SchemaStore.nvim]: https://github.com/b0o/SchemaStore.nvim
[jose-elias-alvarez/null-ls.nvim]: https://github.com/jose-elias-alvarez/null-ls.nvim

[folke/lazy.nvim]: https://github.com/folke/lazy.nvim
[christoomey/tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[lambdalisue/suda.vim]: https://github.com/lambdalisue/suda.vim
[tpope/vim-sleuth]: https://github.com/tpope/vim-sleuth
[olimorris/persisted.nvim]: https://github.com/olimorris/persisted.nvim
[RRethy/vim-illuminate]: https://github.com/RRethy/vim-illuminate
[mbbill/undotree]: https://github.com/mbbill/undotree
[ggandor/flit.nvim]: https://github.com/ggandor/flit.nvim
[ggandor/leap.nvim]: https://github.com/ggandor/leap.nvim
[kana/vim-niceblock]: https://github.com/kana/vim-niceblock
[haya14busa/vim-edgemotion]: https://github.com/haya14busa/vim-edgemotion
[folke/zen-mode.nvim]: https://github.com/folke/zen-mode.nvim
[folke/which-key.nvim]: https://github.com/folke/which-key.nvim
[tversteeg/registers.nvim]: https://github.com/tversteeg/registers.nvim
[folke/todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[folke/trouble.nvim]: https://github.com/folke/trouble.nvim
[sindrets/diffview.nvim]: https://github.com/sindrets/diffview.nvim
[simrat39/symbols-outline.nvim]: https://github.com/simrat39/symbols-outline.nvim
[s1n7ax/nvim-window-picker]: https://github.com/s1n7ax/nvim-window-picker
[rest-nvim/rest.nvim]: https://github.com/rest-nvim/rest.nvim
[mickael-menu/zk-nvim]: https://github.com/mickael-menu/zk-nvim
[windwp/nvim-spectre]: https://github.com/windwp/nvim-spectre
[echasnovski/mini.bufremove]: https://github.com/echasnovski/mini.bufremove
[mzlogin/vim-markdown-toc]: https://github.com/mzlogin/vim-markdown-toc

[sbdchd/neoformat]: https://github.com/sbdchd/neoformat
[hrsh7th/nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[hrsh7th/cmp-buffer]: https://github.com/hrsh7th/cmp-buffer
[hrsh7th/cmp-path]: https://github.com/hrsh7th/cmp-path
[hrsh7th/cmp-emoji]: https://github.com/hrsh7th/cmp-emoji
[saadparwaiz1/cmp_luasnip]: https://github.com/saadparwaiz1/cmp_luasnip
[andersevenrud/compe-tmux]: https://github.com/andersevenrud/compe-tmux
[L3MON4D3/LuaSnip]: https://github.com/L3MON4D3/LuaSnip
[rafamadriz/friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[ziontee113/SnippetGenie]: https://github.com/ziontee113/SnippetGenie
[echasnovski/mini.pairs]: https://github.com/echasnovski/mini.pairs
[echasnovski/mini.surround]: https://github.com/echasnovski/mini.surround
[JoosepAlviste/nvim-ts-context-commentstring]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
[echasnovski/mini.comment]: https://github.com/echasnovski/mini.comment
[echasnovski/mini.trailspace]: https://github.com/echasnovski/mini.trailspace
[echasnovski/mini.bracketed]: https://github.com/echasnovski/mini.bracketed
[echasnovski/mini.ai]: https://github.com/echasnovski/mini.ai
[echasnovski/mini.splitjoin]: https://github.com/echasnovski/mini.splitjoin
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[AndrewRadev/dsf.vim]: https://github.com/AndrewRadev/dsf.vim

[rafi/awesome-colorschemes]: https://github.com/rafi/awesome-vim-colorschemes
[AlexvZyl/nordic.nvim]: https://github.com/AlexvZyl/nordic.nvim
[folke/tokyonight.nvim]: https://github.com/folke/tokyonight.nvim
[rebelot/kanagawa.nvim]: https://github.com/rebelot/kanagawa.nvim
[olimorris/onedarkpro.nvim]: https://github.com/olimorris/onedarkpro.nvim
[EdenEast/nightfox.nvim]: https://github.com/EdenEast/nightfox.nvim
[catppuccin/nvim]: https://github.com/catppuccin/nvim
[nyoom-engineering/oxocarbon.nvim]: https://github.com/nyoom-engineering/oxocarbon.nvim

[lewis6991/gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[TimUntersberger/neogit]: https://github.com/TimUntersberger/neogit
[tpope/vim-fugitive]: https://github.com/tpope/vim-fugitive
[junegunn/gv.vim]: https://github.com/junegunn/gv.vim
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim

[hoob3rt/lualine.nvim]: https://github.com/hoob3rt/lualine.nvim
[nvim-neo-tree/neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[nvim-telescope/telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[nvim-telescope/telescope-ui-select.nvim]: https://github.com/nvim-telescope/telescope-ui-select.nvim
[jvgrootveld/telescope-zoxide]: https://github.com/jvgrootveld/telescope-zoxide
[nvim-lua/plenary.nvim]: https://github.com/nvim-lua/plenary.nvim

[nvim-treesitter/nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[nvim-treesitter/nvim-treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
[nvim-treesitter/nvim-treesitter-context]: https://github.com/nvim-treesitter/nvim-treesitter-context
[RRethy/nvim-treesitter-endwise]: https://github.com/RRethy/nvim-treesitter-endwise
[windwp/nvim-ts-autotag]: https://github.com/windwp/nvim-ts-autotag
[andymass/vim-matchup]: https://github.com/andymass/vim-matchup
[kevinhwang91/nvim-ufo]: https://github.com/kevinhwang91/nvim-ufo
[iloginow/vim-stylus]: https://github.com/iloginow/vim-stylus
[chrisbra/csv.vim]: https://github.com/chrisbra/csv.vim
[towolf/vim-helm]: https://github.com/towolf/vim-helm
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[lifepillar/pgsql.vim]: https://github.com/lifepillar/pgsql.vim
[MTDL9/vim-log-highlighting]: https://github.com/MTDL9/vim-log-highlighting
[tmux-plugins/vim-tmux]: https://github.com/tmux-plugins/vim-tmux
[reasonml-editor/vim-reason-plus]: https://github.com/reasonml-editor/vim-reason-plus
[vmchale/just-vim]: https://github.com/vmchale/just-vim
[pearofducks/ansible-vim]: https://github.com/pearofducks/ansible-vim

[nvim-tree/nvim-web-devicons]: https://github.com/nvim-tree/nvim-web-devicons
[MunifTanjim/nui.nvim]: https://github.com/MunifTanjim/nui.nvim
[folke/noice.nvim]: https://github.com/folke/noice.nvim
[SmiteshP/nvim-navic]: https://github.com/SmiteshP/nvim-navic
[rcarriga/nvim-notify]: https://github.com/rcarriga/nvim-notify
[chentau/marks.nvim]: https://github.com/chentau/marks.nvim
[lukas-reineke/indent-blankline.nvim]: https://github.com/lukas-reineke/indent-blankline.nvim
[t9md/vim-quickhl]: https://github.com/t9md/vim-quickhl
[kevinhwang91/nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[uga-rosa/ccc.nvim]: https://github.com/uga-rosa/ccc.nvim
[dnlhc/glance.nvim]: https://github.com/dnlhc/glance.nvim
[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim

## Extra Plugins

These plugins aren't enabled by default. You'll have to import them using specs.

For example:

```lua
return {
  { import = 'rafi.plugins.extras.ui.incline' },
  { import = 'rafi.plugins.extras.org.vimwiki' },
}
```

### Extra Plugins: Coding

Spec: `rafi.plugins.extras.coding.<name>`

| Name           | Repository     | Description
| -------------- | -------------- | ----------------------
| `autopairs`    | [windwp/nvim-autopairs] | Autopairs for neovim written by lua
| `copilot`      | [zbirenbaum/copilot.lua] | Fully featured & enhanced replacement for copilot.vim
| `editorconfig` | [sgur/vim-editorconfig] | EditorConfig plugin written entirely in Vimscript
| `emmet`        | [mattn/emmet-vim] | Provides support for expanding abbreviations alá emmet
| `kommentary`   | [b3nj5m1n/kommentary] | Commenting plugin, written in Lua
| `sandwich`     | [machakann/vim-sandwich] | Search, select, and edit sandwich text objects

### Extra Plugins: Diagnostics

Spec: `rafi.plugins.extras.diagnostics.<name>`

| Name           | Description
| -------------- | ----------------------
| `proselint`    | proselint: null-ls source and mason package
| `write-good`   | write-good: null-ls source and mason package

### Extra Plugins: Editor

Spec: `rafi.plugins.extras.editor.<name>`

| Key       | Name           | Description
| ----------| -------------- | ----------------------
| `anyjump` | [pechorin/any-jump.vim] | Jump to any definition and references without overhead

### Extra Plugins: Formatting

Spec: `rafi.plugins.extras.formatting.<name>`

| Name           | Description
| -------------- | ----------------------
| `prettier`     | prettier: null-ls source and mason package

### Extra Plugins: LSP

Spec: `rafi.plugins.extras.lsp.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `lightbulb`    | [kosayoda/nvim-lightbulb] | VSCode 💡 for neovim's built-in LSP

### Extra Plugins: Org

Spec: `rafi.plugins.extras.org.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `vimwiki`      | [vimwiki/vimwiki] | Personal Wiki for Vim

### Extra Plugins: Treesitter

Spec: `rafi.plugins.extras.treesitter.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `treesj`       | [Wansmer/treesj] | Splitting and joining blocks of code

### Extra Plugins: UI

Spec: `rafi.plugins.extras.ui.<name>`

| Key            | Name           | Description
| -------------- | -------------- | ----------------------
| `bufferline`   | [akinsho/bufferline.nvim] | Snazzy tab/bufferline
| `cursorword`   | [itchyny/cursorword] | Underlines word under cursor
| `cybu`         | [ghillb/cybu.nvim] | Cycle buffers with a customizable notification window
| `deadcolumn`   | [Bekaboo/deadcolumn.nvim] | Show colorcolumn dynamically
| `cool`         | [romainl/vim-cool] | Simple plugin that makes hlsearch more useful
| `goto-preview` | [rmagatti/goto-preview] | Preview definitions using floating windows
| `incline`      | [b0o/incline.nvim] | Floating statuslines
| `minimap`      | [echasnovski/mini.map] | Window with buffer text overview, scrollbar, and highlights
| `statuscol`    | [luukvbaal/statuscol.nvim] | Configurable 'statuscolumn' and click handlers

[windwp/nvim-autopairs]: https://github.com/windwp/nvim-autopairs
[zbirenbaum/copilot.lua]: https://github.com/zbirenbaum/copilot.lua
[sgur/vim-editorconfig]: https://github.com/sgur/vim-editorconfig
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[b3nj5m1n/kommentary]: https://github.com/b3nj5m1n/kommentary
[machakann/vim-sandwich]: https://github.com/machakann/vim-sandwich
[pechorin/any-jump.vim]: https://github.com/pechorin/any-jump.vim
[kosayoda/nvim-lightbulb]: https://github.com/kosayoda/nvim-lightbulb
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki
[Wansmer/treesj]: https://github.com/Wansmer/treesj
[akinsho/bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[itchyny/cursorword]: https://github.com/itchyny/vim-cursorword
[ghillb/cybu.nvim]: https://github.com/ghillb/cybu.nvim
[Bekaboo/deadcolumn.nvim]: https://github.com/Bekaboo/deadcolumn.nvim
[romainl/vim-cool]: https://github.com/romainl/vim-cool
[rmagatti/goto-preview]: https://github.com/rmagatti/goto-preview
[b0o/incline.nvim]: https://github.com/b0o/incline.nvim
[echasnovski/mini.map]: https://github.com/echasnovski/mini.map
[luukvbaal/statuscol.nvim]: https://github.com/luukvbaal/statuscol.nvim

</details>

## Custom Key-mappings

Note that,

* **Leader** key set as <kbd>Space</kbd>
* **Local-Leader** key set as <kbd>;</kbd> and used for navigation and search
  (Telescope and Neo-tree)
* Disable <kbd>←</kbd> <kbd>↑</kbd> <kbd>→</kbd> <kbd>↓</kbd> in normal mode by enabling `g:elite_mode` in `.vault.vim`

<details open>
  <summary>
    <strong>Key-mappings</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

<center>Modes: 𝐍=normal 𝐕=visual 𝐒=select 𝐈=insert 𝐎=operator 𝐂=command</center>

### Navigation

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>j</kbd> / <kbd>k</kbd> | 𝐍 𝐕 | Cursor moves through display-lines | `g` `j/k`
| <kbd>g</kbd>+<kbd>j</kbd> / <kbd>k</kbd> | 𝐍 𝐕 𝐒 | Jump to edge upward/downward | <small>[haya14busa/vim-edgemotion]</small>
| <kbd>gh</kbd> / <kbd>gl</kbd> | 𝐍 𝐕 | Easier line-wise movement | `g` `^/$`
| <kbd>Space</kbd>+<kbd>Space</kbd> | 𝐍 𝐕 | Toggle visual-line mode | `V` / <kbd>Escape</kbd>
| <kbd>zl</kbd> / <kbd>zh</kbd> | 𝐍 | Scroll horizontally and vertically wider | `z4` `l/h`
| <kbd>Ctrl</kbd>+<kbd>j</kbd> | 𝐍 | Move to split below | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>k</kbd> | 𝐍 | Move to upper split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐍 | Move to left split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐍 | Move to right split | <small>[christoomey/tmux-navigator]</small>
| <kbd>Return</kbd> | 𝐍 | Toggle fold | `za`
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐍 | Focus the current fold by closing all others | `zMzvzt`
| <kbd>]a</kbd> or <kbd>[a</kbd> | 𝐍 | Next/previous on location-list | `:lnext` / `:lprev`
| <kbd>]m</kbd> or <kbd>[m</kbd> | 𝐍 | Next/previous function | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small>
| <kbd>]s</kbd> or <kbd>[s</kbd> | 𝐍 | Next/previous whitespace error | <small>[lua/rafi/config/keymaps.lua]</small>
| <kbd>]g</kbd> or <kbd>[g</kbd> | 𝐍 | Next/previous Git hunk | <small>[lewis6991/gitsigns.nvim]</small>
| <kbd>]]</kbd> or <kbd>[[</kbd> | 𝐍 | Next/previous reference | <small>[RRethy/vim-illuminate]</small>
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | 𝐂 | Move cursor forwards in command | <kbd>Right</kbd>
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | 𝐂 | Move cursor backwards in command | <kbd>Left</kbd>
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | 𝐂 | Move cursor to the beginning in command | <kbd>Home</kbd>
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐂 | Move cursor to the end in command | <kbd>End</kbd>

### File Operations

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>cd</kbd> | 𝐍 | Switch to the directory of opened buffer | `:lcd %:p:h`
| <kbd>gf</kbd> | 𝐍 | Open file under the cursor in a vsplit | `:rightbelow wincmd f`
| <kbd>Space</kbd>+<kbd>w</kbd> | 𝐍 | Write buffer to file | `:write`
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | 𝐍 𝐕 𝐂 | Write buffer to file | `:write`

### Auto-Completion

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 | Navigate completion-menu
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | 𝐈 𝐒 | Navigate snippet placeholders
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 𝐈 | Open completion menu
| <kbd>Enter</kbd> | 𝐈 | Select completion or expand snippet
| <kbd>Ctrl</kbd>+<kbd>p</kbd>/<kbd>n</kbd> | 𝐈 | Movement in completion pop-up
| <kbd>Ctrl</kbd>+<kbd>b</kbd>/<kbd>f</kbd> | 𝐈 | Scroll documentation
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | 𝐈 | Abort selection and close pop-up
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | 𝐈 | Expand snippet at cursor

### Edit

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Shift</kbd>+<kbd>Return</kbd> | 𝐈 | Start new line from any cursor position | `<C-o>o`
| <kbd><</kbd> | 𝐕 | Indent to left and re-select | `<gv`
| <kbd>></kbd> | 𝐕 | Indent to right and re-select | `>gv|`
| <kbd>Tab</kbd> | 𝐕 | Indent to right and re-select | `>gv|`
| <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐕 | Indent to left and re-select | `<gv`
| <kbd>gc</kbd> | 𝐍 𝐕 | Comment prefix | <small>[echasnovski/mini.comment]</small>
| <kbd>gcc</kbd> | 𝐍 𝐕 | Toggle comments | <small>[echasnovski/mini.comment]</small>
| <kbd>Space</kbd>+<kbd>v</kbd> | 𝐍 𝐕 | Toggle single-line comments | <small>[echasnovski/mini.comment]</small>
| <kbd>Space</kbd>+<kbd>j</kbd> or <kbd>k</kbd> | 𝐍 𝐕 | Move lines down/up | `:m` …
| <kbd>Space</kbd>+<kbd>d</kbd> | 𝐍 𝐕 | Duplicate line or selection |
| <kbd>Space</kbd>+<kbd>cp</kbd> | 𝐍 | Duplicate paragraph | `yap<S-}>p`
| <kbd>Space</kbd>+<kbd>cw</kbd> | 𝐍 | Remove all spaces at EOL | <small>[echasnovski/mini.trailspace]</small>
| <kbd>sj</kbd> / <kbd>sk</kbd> | 𝐍 | Join/split arguments | <small>[echasnovski/mini.splitjoin]</small>
| <kbd>dsf</kbd> / <kbd>csf</kbd> | 𝐍 | Delete/change surrounding function call | <small>[AndrewRadev/dsf.vim]</small>
| <kbd>I</kbd> / <kbd>gI</kbd> | 𝐕 | Blockwise insert | <small>[kana/vim-niceblock]</small>
| <kbd>A</kbd> | 𝐕 | Blockwise append | <small>[kana/vim-niceblock]</small>

### Search & Replace

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>\*</kbd> / <kbd>#</kbd> | 𝐍 𝐕 | Search partial words | `g*` / `g#`
| <kbd>g\*</kbd> / <kbd>g#</kbd> | 𝐍 𝐕 | Search whole-word forward/backward | `*` / `#`
| <kbd>Backspace</kbd> | 𝐍 | Match bracket | `%`
| <kbd>gpp</kbd> | 𝐍 | Select last paste |
| <kbd>sg</kbd> | 𝐕 | Replace within selected area | `:s/⌴/gc`
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | 𝐕 | Replace selection with step-by-step confirmation | `:%s/\V/⌴/gc`
| <kbd>ss</kbd> / <kbd>SS</kbd> | 𝐍 𝐕 | Leap forward/backward | <small>[ggandor/leap.nvim]</small>
| <kbd>f</kbd> / <kbd>F</kbd> / <kbd>t</kbd> / <kbd>T</kbd> | 𝐍 𝐕 | Enhanced motions | <small>[ggandor/flit.nvim]</small>

### Clipboard

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>p</kbd> or <kbd>P</kbd> | 𝐕 | Paste without yank | `:let @+=@0`
| <kbd>Space</kbd>+<kbd>y</kbd> | 𝐍 | Copy relative file-path to clipboard |
| <kbd>Space</kbd>+<kbd>Y</kbd> | 𝐍 | Copy absolute file-path to clipboard |

### Command & History

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>!</kbd> | 𝐍 | Shortcut for shell command | `:!`
| <kbd>g!</kbd> | 𝐍 | Read vim command into buffer | `:put=execute('⌴')`
| <kbd>Ctrl</kbd>+<kbd>n</kbd> / <kbd>p</kbd> | 𝐂 | Switch history search pairs | <kbd>↓</kbd> / <kbd>↑</kbd>
| <kbd>↓</kbd> / <kbd>↑</kbd> | 𝐂 | Switch history search pairs | `Ctrl` `n`/`p`

### Diagnostics

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>;</kbd>+<kbd>dt</kbd> | 𝐍 | Open TODO Telescope list | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd>+<kbd>xt</kbd> | 𝐍 | Open TODO list | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd>+<kbd>xT</kbd> | 𝐍 | Open TODO/FIXME list | <small>[folke/todo-comments.nvim]</small>
| <kbd>Space</kbd>+<kbd>xq</kbd> | 𝐍 | Open Quickfix via Trouble | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd>+<kbd>xl</kbd> | 𝐍 | Open Locationlist via Trouble | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd>+<kbd>e</kbd> | 𝐍 | Open Trouble document | <small>[folke/trouble.nvim]</small>
| <kbd>Space</kbd>+<kbd>r</kbd> | 𝐍 | Open Trouble workspace | <small>[folke/trouble.nvim]</small>

### Editor UI

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>Space</kbd>+<kbd>ts</kbd> | 𝐍 | Toggle spell-checker | <small>`:setlocal spell!`</small>
| <kbd>Space</kbd>+<kbd>tn</kbd> | 𝐍 | Toggle line numbers | <small>`:setlocal nonumber!`</small>
| <kbd>Space</kbd>+<kbd>tl</kbd> | 𝐍 | Toggle hidden characters | <small>`:setlocal nolist!`</small>
| <kbd>Space</kbd>+<kbd>th</kbd> | 𝐍 | Toggle highlighted search | <small>`:set hlsearch!`</small>
| <kbd>Space</kbd>+<kbd>tw</kbd> | 𝐍 | Toggle wrap | <small>`:setlocal wrap!`</small> …
| <kbd>Space</kbd>+<kbd>ti</kbd> | 𝐍 | Toggle indentation lines | <small>[lukas-reineke/indent-blankline.nvim]</small>
| <kbd>Space</kbd>+<kbd>tt</kbd> | 𝐍 | Show highlight groups for word |
| <kbd>g1</kbd> | 𝐍 | Go to first tab | `:tabfirst`
| <kbd>g9</kbd> | 𝐍 | Go to last tab | `:tablast`
| <kbd>g5</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | 𝐍 | Go to next tab | `:tabnext`
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd><kbd>Tab</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Alt</kbd>+<kbd>j</kbd> | 𝐍 | Go to next tab | `:tabnext`
| <kbd>Alt</kbd>+<kbd>k</kbd> | 𝐍 | Go to previous tab | `:tabprevious`
| <kbd>Alt</kbd>+<kbd>{</kbd> | 𝐍 | Move tab backward | `:-tabmove`
| <kbd>Alt</kbd>+<kbd>}</kbd> | 𝐍 | Move tab forward | `:+tabmove`

### Custom Tools & Plugins

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>;</kbd>+<kbd>c</kbd> | 𝐍 | Open context-menu | <small>[lua/rafi/lib/contextmenu.lua]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>o</kbd> | 𝐍 | Navigate to previous file on jumplist | <small>[lua/rafi/lib/edit.lua]</small>
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>i</kbd> | 𝐍 | Navigate to next file on jumplist | <small>[lua/rafi/lib/edit.lua]</small>
| <kbd>s</kbd>+<kbd>p</kbd> | 𝐍 | Choose a window to edit | <small>[s1n7ax/nvim-window-picker]</small>
| <kbd>s</kbd>+<kbd>w</kbd> | 𝐍 | Switch editing window with selected | <small>[s1n7ax/nvim-window-picker]</small>
| <kbd>Space</kbd>+<kbd>l</kbd> | 𝐍 | Open Lazy | <small>[folke/lazy.nvim]</small>
| <kbd>Space</kbd>+<kbd>o</kbd> | 𝐍 | Open structure window | <small>[simrat39/symbols-outline.nvim]</small>
| <kbd>Space</kbd>+<kbd>f</kbd> | 𝐍 | Show current structure scope in winbar | <small>[SmiteshP/nvim-navic]</small>
| <kbd>Space</kbd>+<kbd>?</kbd> | 𝐍 | Open the macOS dictionary on current word | `:!open dict://`
| <kbd>Space</kbd>+<kbd>P</kbd> | 𝐍 | Use Marked 2 for real-time Markdown preview | <small>[Marked 2]</small>
| <kbd>Space</kbd>+<kbd>cp</kbd> | 𝐍 | Open color-picker | <small>[uga-rosa/ccc.nvim]</small>
| <kbd>Space</kbd>+<kbd>ml</kbd> | 𝐍 | Append modeline to end of buffer | <small>[lua/rafi/config/keymaps.lua]</small>
| <kbd>Space</kbd>+<kbd>mda</kbd> | 𝐕 | Sequentially mark region for diff | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdf</kbd> | 𝐕 | Mark region for diff and compare if more than one | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mds</kbd> | 𝐍 | Shows the comparison for all marked regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mdr</kbd> | 𝐍 | Removes the signs denoting the diff regions | <small>[AndrewRadev/linediff.vim]</small>
| <kbd>Space</kbd>+<kbd>mt</kbd> | 𝐍 𝐕 | Toggle highlighted word | <small>[t9md/vim-quickhl]</small>
| <kbd>Space</kbd>+<kbd>zz</kbd> | 𝐍 | Toggle distraction-free writing | <small>[folke/zen-mode.nvim]</small>
| <kbd>Space</kbd>+<kbd>gu</kbd> | 𝐍 | Open undo-tree | <small>[mbbill/undotree]</small>

### Window Management

| Key   | Mode | Action             | Plugin or Mapping
| ----- |:----:| ------------------ | ------
| <kbd>q</kbd> | 𝐍 | Quit window (if last window, quit nvim) | `:quit`
| <kbd>Ctrl</kbd>+<kbd>x</kbd> | 𝐍 | Rotate window placement | `C-w` `x`
| <kbd>sv</kbd> | 𝐍 | Horizontal split | `:split`
| <kbd>sg</kbd> | 𝐍 | Vertical split | `:vsplit`
| <kbd>st</kbd> | 𝐍 | Open new tab | `:tabnew`
| <kbd>so</kbd> | 𝐍 | Close other windows | `:only`
| <kbd>sb</kbd> | 𝐍 | Previous buffer | `:b#`
| <kbd>sc</kbd> | 𝐍 | Close current buffer | `:close`
| <kbd>sd</kbd> | 𝐍 | Delete buffer | `:bdelete`
| <kbd>sq</kbd> | 𝐍 | Quit window | `:quit`
| <kbd>sx</kbd> | 𝐍 | Delete buffer, leave blank window | `:enew │ bdelete`
| <kbd>sz</kbd> | 𝐍 | Toggle window zoom | `:vertical resize │ resize`
| <kbd>sh</kbd> | 𝐍 | Toggle colorscheme background=dark/light | `:set background` …

### Plugin: Mini.Bracketed

Go forward/backward with square brackets. See [echasnovski/mini.bracketed] for
more mappings and usage information.

| Key                 | Target                                            | Mapping                      |
|---------------------|-------------------------------------------------- | ---------------------------- |
| `[B` `[b` `]b` `]B` | Buffer                                            | `MiniBracketed.buffer()`     |
| `[C` `[c` `]c` `]C` | Comment block                                     | `MiniBracketed.comment()`    |
| `[X` `[x` `]x` `]X` | Conflict marker                                   | `MiniBracketed.conflict()`   |
| `[D` `[d` `]d` `]D` | Diagnostic                                        | `MiniBracketed.diagnostic()` |
| `[F` `[f` `]f` `]F` | File on disk                                      | `MiniBracketed.file()`       |
| `[I` `[i` `]i` `]I` | Indent change                                     | `MiniBracketed.indent()`     |
| `[J` `[j` `]j` `]J` | Jump from jumplist inside current buffer          | `MiniBracketed.jump()`       |
| `[L` `[l` `]l` `]L` | Location from location list                       | `MiniBracketed.location()`   |
| `[O` `[o` `]o` `]O` | Old files                                         | `MiniBracketed.oldfile()`    |
| `[Q` `[q` `]q` `]Q` | Quickfix entry from quickfix list                 | `MiniBracketed.quickfix()`   |
| `[T` `[t` `]t` `]T` | Tree-sitter node and parents                      | `MiniBracketed.treesitter()` |
| `[U` `[u` `]u` `]U` | Undo states from specially tracked linear history | `MiniBracketed.undo()`       |
| `[W` `[w` `]w` `]W` | Window in current tab                             | `MiniBracketed.window()`     |
| `[Y` `[y` `]y` `]Y` | Yank selection replacing the latest put region    | `MiniBracketed.yank()`       |

### Plugin: Mini.Surround

See [echasnovski/mini.surround] for more mappings and usage information.

| Key            | Mode  | Action                       |
| -------------- |:-----:| ---------------------------- |
| <kbd>ds</kbd>  | 𝐍     | Delete around with query     |
| <kbd>dss</kbd> | 𝐍     | Delete around automatically  |
| <kbd>cs</kbd>  | 𝐍     | Change around with query     |
| <kbd>css</kbd> | 𝐍     | Change around automatically  |
| <kbd>sa</kbd>  | 𝐍 𝐕 𝐎 | Trigger add operator         |
| <kbd>sd</kbd>  | 𝐍 𝐕   | Trigger delete operator      |
| <kbd>sdb</kbd> | 𝐍     | Delete around automatically  |
| <kbd>sr</kbd>  | 𝐍 𝐕   | Trigger replace operator     |
| <kbd>srb</kbd> | 𝐍     | Replace around automatically |
| <kbd>ir</kbd>  | 𝐕 𝐎   | Inner automatically          |
| <kbd>ab</kbd>  | 𝐕 𝐎   | Around automatically         |

### Plugin: Gitsigns

See [lewis6991/gitsigns.nvim] for more mappings and usage information.

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>]g</kbd> or <kbd>]g</kbd> | 𝐍 | Next/previous Git hunk |
| <kbd>gs</kbd>                  | 𝐍 | Preview hunk |
| <kbd>Space</kbd> <kbd>hp</kbd> | 𝐍 | Preview hunk inline |
| <kbd>Space</kbd> <kbd>hb</kbd> | 𝐍 | Blame line |
| <kbd>Space</kbd> <kbd>hs</kbd> | 𝐍 𝐕 | Stage hunk |
| <kbd>Space</kbd> <kbd>hu</kbd> | 𝐍 | Undo stage hunk |
| <kbd>Space</kbd> <kbd>hr</kbd> | 𝐍 𝐕 | Reset hunk |
| <kbd>Space</kbd> <kbd>hR</kbd> | 𝐍 | Reset buffer |
| <kbd>Space</kbd> <kbd>hd</kbd> | 𝐍 | Toggle deleted |
| <kbd>Space</kbd> <kbd>hw</kbd> | 𝐍 | Toggle word diff |
| <kbd>Space</kbd> <kbd>hl</kbd> | 𝐍 | Publish hunks to location-list |

### Plugin: Fugitive

See [tpope/vim-fugitive] for more mappings and usage information.

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd> <kbd>ga</kbd> | 𝐍 | Git add current file |
| <kbd>Space</kbd> <kbd>gd</kbd> | 𝐍 | Git diff |
| <kbd>Space</kbd> <kbd>gc</kbd> | 𝐍 | Git commit |
| <kbd>Space</kbd> <kbd>gb</kbd> | 𝐍 | Git blame |
| <kbd>Space</kbd> <kbd>gs</kbd> | 𝐍 | Git status -s |
| <kbd>Space</kbd> <kbd>gl</kbd> | 𝐍 | Git log --graph --all |
| <kbd>Space</kbd> <kbd>gF</kbd> | 𝐍 | Git fetch |
| <kbd>Space</kbd> <kbd>gp</kbd> | 𝐍 | Git push |
| <kbd>Space</kbd> <kbd>go</kbd> | 𝐍 𝐕 | Open SCM detailed URL in browser |

### Plugin: Telescope

See [telescope.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;r</kbd> | 𝐍 | Results of the previous picker
| <kbd>;R</kbd> | 𝐍 | List of the previous pickers
| <kbd>;f</kbd> | 𝐍 | File search
| <kbd>;g</kbd> | 𝐍 | Grep search
| <kbd>;b</kbd> | 𝐍 | Buffers
| <kbd>;x</kbd> | 𝐍 | Old files
| <kbd>;v</kbd> | 𝐍 𝐕 | Yank history
| <kbd>;m</kbd> | 𝐍 | Marks
| <kbd>;n</kbd> | 𝐍 | Dein plugin list
| <kbd>;j</kbd> | 𝐍 | Jump points
| <kbd>;k</kbd> | 𝐍 | Thesaurus
| <kbd>;u</kbd> | 𝐍 | Spelling suggestions
| <kbd>;o</kbd> | 𝐍 | Vim options
| <kbd>;s</kbd> | 𝐍 | Sessions
| <kbd>;t</kbd> | 𝐍 | LSP workspace symbols
| <kbd>;h</kbd> | 𝐍 | Highlights
| <kbd>;w</kbd> | 𝐍 | Memo list
| <kbd>;z</kbd> | 𝐍 | Zoxide directories
| <kbd>;;</kbd> | 𝐍 | Command history
| <kbd>;/</kbd> | 𝐍 | Search history
| <kbd>Space</kbd>+<kbd>gt</kbd> | 𝐍 | Find symbols matching word under cursor
| <kbd>Space</kbd>+<kbd>gf</kbd> | 𝐍 | Find files matching word under cursor
| <kbd>Space</kbd>+<kbd>gg</kbd> | 𝐍 𝐕 | Grep word under cursor
| **Within _Telescope_ window** ||
| <kbd>?</kbd> | 𝐍 | Keymaps help screen
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | 𝐍 | Move from none fuzzy search to fuzzy
| <kbd>jj</kbd> or <kbd>Escape</kbd> | 𝐈 | Leave Insert mode
| <kbd>i</kbd> | 𝐍 | Enter Insert mode (filter input)
| <kbd>q</kbd> or <kbd>Escape</kbd> | 𝐍 | Exit denite window
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | 𝐍 𝐈 | Next/previous candidate
| <kbd>Ctrl</kbd>+<kbd>d</kbd>/<kbd>u</kbd> | 𝐍 𝐈 | Scroll down/upwards
| <kbd>Ctrl</kbd>+<kbd>f</kbd>/<kbd>b</kbd> | 𝐍 𝐈 | Scroll preview down/upwards
| <kbd>J</kbd> or <kbd>K</kbd> | 𝐍 | Select candidates up/downwards
| <kbd>st</kbd> | 𝐍 | Open in a new tab
| <kbd>sg</kbd> | 𝐍 | Open in a vertical split
| <kbd>sv</kbd> | 𝐍 | Open in a split
| <kbd>w</kbd> | 𝐍 | Smart send to quickfix list
| <kbd>e</kbd> | 𝐍 | Send to quickfix list
| <kbd>dd</kbd> | 𝐍 | Delete entry (buffer list)

### Plugin: Neo-Tree

See [nvim-neo-tree/neo-tree.nvim] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>;e</kbd> | 𝐍 | Open file-explorer (toggle)
| <kbd>;a</kbd> | 𝐍 | Focus current file in file-explorer
| **Within _Neo-Tree_ window** ||
| <kbd>g?</kbd> | 𝐍 | Show help
| <kbd>q</kbd> | 𝐍 | Close window
| <kbd>j</kbd> or <kbd>k</kbd> | 𝐍 | Move up and down the tree
| <kbd>\></kbd> or <kbd>\<</kbd> | 𝐍 | Next or previous source
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
| <kbd>p</kbd> | 𝐍 | Preview node
| <kbd>a</kbd> | 𝐍 | Create new directories and/or files
| <kbd>N</kbd> | 𝐍 | Create new directory
| <kbd>r</kbd> | 𝐍 | Rename file or directory
| <kbd>dd</kbd> | 𝐍 | Delete
| <kbd>c</kbd> / <kbd>m</kbd> | 𝐍 | Copy/move
| <kbd>y</kbd> / <kbd>x</kbd> / <kbd>P</kbd> | 𝐍 | Clipboard copy/cut/paste
| <kbd>!</kbd> | 𝐍 | Filter
| <kbd>D</kbd> | 𝐍 | Filter directories
| <kbd>#</kbd> | 𝐍 | Fuzzy sorter
| <kbd>/</kbd> | 𝐍 | Filter on submit
| <kbd>Ctrl</kbd>+<kbd>c</kbd> | 𝐍 | Clear filter
| <kbd>Ctrl</kbd>+<kbd>r</kbd> or <kbd>R</kbd> | 𝐍 | Refresh
| <kbd>fi</kbd> / <kbd>fe</kbd> | 𝐍 | Include/exclude
| <kbd>H</kbd> | 𝐍 | Toggle hidden files
| <kbd>e</kbd> | 𝐍 | Toggle auto-expand window width
| <kbd>w</kbd> | 𝐍 | Toggle window width
| <kbd>z</kbd> | 𝐍 | Collapse all nodes

### Plugin: Spectre

See [windwp/nvim-spectre] for more mappings and usage information.

| Key   | Mode | Action
| ----- |:----:| ------------------
| <kbd>Space</kbd>+<kbd>so</kbd> | 𝐍 | Open spectre window (search & replace)

### Plugin: Marks

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

</details>

[Neovim]: https://github.com/neovim/neovim
[neoconf.json]: ./neoconf.json
[lazy.nvim]: https://github.com/folke/lazy.nvim
[LazyVim/starter]: https://github.com/LazyVim/starter
[lua/rafi/plugins/lsp/init.lua]: ./lua/rafi/plugins/lsp/init.lua
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
[telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[lua/rafi/config/keymaps.lua]: ./lua/rafi/config/keymaps.lua
[lua/rafi/lib/contextmenu.lua]: ./lua/rafi/lib/contextmenu.lua
[nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Marked 2]: https://marked2app.com
