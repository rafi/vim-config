# Rafael Bodill's Neovim Config

[![CI](https://github.com/rafi/vim-config/actions/workflows/ci.yml/badge.svg)](https://github.com/rafi/vim-config/actions/workflows/ci.yml)

Lean mean Neovim machine, 30-45ms startup time.
Works best with [Neovim] ≥0.12

(plugins managed by Neovim's built-in [vim.pack])

:gear: See [__Extending__](#extending) for customizing configuration and adding
plugins.

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
  * [Upgrade from the lazy.nvim version](#upgrade-from-the-lazynvim-version)
* [Structure](#structure)
* [Extending](#extending)
  * [Extend: Config](#extend-config)
  * [Extend: Plugins](#extend-plugins)
  * [Extend: Defaults](#extend-defaults)
  * [Extend: LSP Settings](#extend-lsp-settings)
* [Plugin Highlights](#plugin-highlights)
* [Plugins Included](#plugins-included)
* [Extra Plugins](#extra-plugins)
  * [Extra Plugins: AI](#extra-plugins-ai)
  * [Extra Plugins: Coding](#extra-plugins-coding)
  * [Extra Plugins: Colorscheme](#extra-plugins-colorscheme)
  * [Extra Plugins: Editor](#extra-plugins-editor)
  * [Extra Plugins: Formatting](#extra-plugins-formatting)
  * [Extra Plugins: Git](#extra-plugins-git)
  * [Extra Plugins: Grammar](#extra-plugins-grammar)
  * [Extra Plugins: Lang](#extra-plugins-lang)
  * [Extra Plugins: Linting](#extra-plugins-linting)
  * [Extra Plugins: LSP](#extra-plugins-lsp)
  * [Extra Plugins: Org](#extra-plugins-org)
  * [Extra Plugins: Treesitter](#extra-plugins-treesitter)
  * [Extra Plugins: UI](#extra-plugins-ui)
  * [Extra Plugins: Util](#extra-plugins-util)
* [Custom Key-mappings](#custom-key-mappings)
  * [Picker](#picker)
  * [Toggle Features](#toggle-features)
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
  * [Window Management](#window-management)
  * [Plugins](#plugins)
    * [Plugin: Mini.Surround](#plugin-minisurround)
    * [Plugin: Gitsigns](#plugin-gitsigns)
    * [Plugin: Diffview](#plugin-diffview)
  * [Keys from extras](#keys-from-extras)
    * [Plugin: Neo-Tree](#plugin-neo-tree)
    * [Plugin: Marks](#plugin-marks)
    * [Plugin: Zk](#plugin-zk)
* [License](#license)

<!-- vim-markdown-toc -->
</details>

> [!IMPORTANT]
> LazyVim has been dropped in-favor of vim.pack -- see [Upgrade from lazy.nvim](#upgrade-from-the-lazynvim-version)

## Features

* Native [vim.pack] for managing plugins
* Fast startup time: plugins are almost entirely lazy-loaded!
* Robust, yet light-weight
* Review plugin updates with `:Packman` (<kbd>Space</kbd>+<kbd>l</kbd>), and
  toggle opt-in extras with `:RafiExtras` or <kbd>Space</kbd>+<kbd>mx</kbd>
* Install LSP, DAP, linters, and formatters. Use with `:Mason` or <kbd>Space</kbd>+<kbd>cm</kbd>
* LSP configuration with [nvim-lspconfig]
* [folke/snacks.nvim] picker centric work-flow with lists (try <kbd>;</kbd>+<kbd>f</kbd>…)
* Custom context-menu (try it! <kbd>;</kbd>+<kbd>c</kbd>)
* Auto-complete setup with [blink.cmp]
* Structure view with [bassamsdata/namu.nvim]
* Git features using [lewis6991/gitsigns.nvim], [sindrets/diffview.nvim], and [more](#extra-plugins-git)
* Session management with [rmagatti/auto-session]
* Unobtrusive, yet informative status & tab lines
* Premium color-schemes
* Remembers last-used colorscheme

## Screenshot

![Vim screenshot](https://rafi.io/img/project/vim-config/features.png)

## Prerequisites

* [git](https://git-scm.com/) ≥ 2.19.0 (`brew install git`)
* [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim) ≥ v0.12
  for `vim.pack` (`brew install neovim`).

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
    and meets the requirements.

1. Inside Neovim, run `:RafiExtras` and press <kbd>Enter</kbd> to toggle
   extras, then restart Neovim. Choices are saved in `rafi.json`.

Enjoy! :smile:

## Install LSP, DAP, Linters, Formatters

Use `:Mason` (or <kbd>Space</kbd>+<kbd>cm</kbd>) to install and manage LSP
servers, DAP servers, linters and formatters. See `:h mason.nvim` and
[mason-org/mason.nvim] for more information.

### Language-Server Protocol (LSP)

You can install LSP servers using `:Mason` UI, or `:MasonInstall <name>`,
or `:LspInstall <name>` (use <kbd>Tab</kbd> to list available servers).
See Mason's [PACKAGES.md](https://mason-registry.dev/registry/list)
for the official list, and the [Language server mapping](https://github.com/mason-org/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)
list. You can also view at `:h mason-lspconfig-server-map`

You'll need utilities like `npm` and `curl` to install some extensions, see
[requirements](https://github.com/mason-org/mason.nvim#requirements)
(or `:h mason-requirements`) for more information.

See [plugin/lspconfig.lua](./plugin/lspconfig.lua) for custom
key-mappings, and [after/lsp/](./after/lsp) for settings of some
language-servers.

### Recommended LSP

```vim
:MasonInstall ansible-language-server bash-language-server css-lsp
:MasonInstall dockerfile-language-server gopls html-lsp json-lsp
:MasonInstall lua-language-server panache pyright sqlls
:MasonInstall svelte-language-server typescript-language-server
:MasonInstall tailwindcss-language-server
:MasonInstall vim-language-server yaml-language-server
```

and [more](https://github.com/mason-org/mason-lspconfig.nvim/blob/main/doc/server-mapping.md)…

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

* [Pragmata Pro] (€19-€1,990): My preferred font
* Any of the [Nerd Fonts]

On macOS with Homebrew, choose one of the [Nerd Fonts],
for example, here are some popular fonts:

```sh
brew search nerd-font
brew install --cask font-victor-mono-nerd-font
brew install --cask font-iosevka-nerd-font-mono
brew install --cask font-hack-nerd-font
brew install --cask font-fira-code
```

[Pragmata Pro]: https://www.fsd.it/shop/fonts/pragmatapro/
[Nerd Fonts]: https://www.nerdfonts.com

## Upgrade

To update Neovim configuration from my repo, and move plugins to the
versions locked in its `nvim-pack-lock.json`:

```bash
make update
```

To upgrade packages and plugins beyond that:

* Neovim plugins: Use `:Packman check` to review pending updates first and apply
  them with <kbd>U</kbd>. Or use `make update-plugins` for a headless update.
  With Neovim 0.13+, the plugins are checked in the background every hour, and
  a clickable count appears in statusline. Press <kbd>Space</kbd>+<kbd>l</kbd>
  (`:Packman`) to review updates.
* Mason packages: `:Mason` and press <kbd>U</kbd>

### Upgrade from the lazy.nvim version

The first start writes `rafi.json` from your `lazyvim.json` extras, and
warns about any that have no vim.pack version. Then:

* Plugins that used to be core (blink.cmp, mini.ai, mini.pairs,
  mini.surround, grug-far, outline, undotree, nvim-treesitter and others)
  are now extras. Pick the ones you want with `:RafiExtras`.
* `lua/plugins/*.lua` files that return lazy.nvim specs are ignored, with
  a warning. Rewrite them as plain `vim.pack.add()` code, see
  [Extend: Plugins](#extend-plugins).
* `lua/config/setup.lua` and `lua/config/lazy.lua` are no longer read.
* `LazyVim.*` calls in `lua/config/*.lua` fail. Use `rafi.util.root`,
  `rafi.util.pick`, `rafi.util.format`, `rafi.util.lsp`,
  `rafi.util.lualine`, `rafi.util.icons` and `rafi.pack.has()`.
* Once you're done, delete what lazy.nvim left behind:
  `lazyvim.json`, `lazy-lock.json`, `~/.local/share/nvim/lazy/` and
  `~/.local/state/nvim/lazy/`.

## Structure

* [after/](./after) - Language specific custom settings and plugins.
  * [plugin/extras.lua](./after/plugin/extras.lua) - Loads enabled extras,
    then user plugins
* [lua/](./lua) - Lua configurations
  * **`config/`** - Custom user configuration
  * **`plugins/`** - Custom user plugins
  * [rafi/](./lua/rafi)
    * [config/](./lua/rafi/config) - Neovim configurations
      * [autocmds.lua](./lua/rafi/config/autocmds.lua) - Auto-commands
      * [init.lua](./lua/rafi/config/init.lua) - Initialization, `rafi.json`
      * [keymaps.lua](./lua/rafi/config/keymaps.lua) - Key-mappings
      * [options.lua](./lua/rafi/config/options.lua) - Editor settings
    * [extras/](./lua/rafi/extras) - Opt-in plugins ("extras")
    * [pack.lua](./lua/rafi/pack.lua) - Lazy-loading helpers for `vim.pack`
    * [util/](./lua/rafi/util) - Utility library
* [plugin/](./plugin) - Core plugins, one `vim.pack` file each
* [snippets/](./snippets) - Personal code snippets
* `rafi.json` - Enabled extras and disabled core plugins (not tracked)

## Extending

### Extend: Config

Fork this repository and create a directory
`lua/config` with one or more of these files: (Optional)

* `lua/config/autocmds.lua` - Custom auto-commands
* `lua/config/options.lua` - Custom options
* `lua/config/keymaps.lua` - Custom key-mappings

Each loads right after its Rafi counterpart, so it can override it.

Adding plugins or override existing options:

* `lua/plugins/*.lua` - Plain Lua files calling `vim.pack.add()`, sourced
  after the extras
* `lua/plugins/extras/<cat>/<name>.lua` - Your own extras, listed in
  `:RafiExtras` next to Rafi's

### Extend: Plugins

Toggle "extras" plugins with `:RafiExtras` (or <kbd>Space</kbd>+<kbd>mx</kbd>)
and <kbd>Enter</kbd>, then restart Neovim. This saves choices in `rafi.json`,
which you can also edit manually. `extras` lists extras by `<cat>.<name>`
(their path under `lua/rafi/extras/`), and `disabled` turns off core
plugins by their path under `plugin/`:

```json
{
  "extras": [
    "coding.align",
    "editor.dial",
    "lang.docker",
    "lang.go",
    "lang.json",
    "lang.markdown",
    "lang.python",
    "lang.toml",
    "lang.typescript",
    "lang.yaml",
    "ui.bookmarks",
    "ui.deadcolumn"
  ],
  "disabled": ["lualine"]
}
```

A core plugin listed in `disabled` doesn't load, so you can replace it with
your own file. Files in `lua/plugins/*.lua` are plain Lua, sourced after the
extras. Here's an example, `lua/plugins/lightline.lua`:

```lua
-- Use lightline instead of lualine (add "lualine" to "disabled")
vim.pack.add({ 'https://github.com/itchyny/lightline.vim' })
vim.g.lightline = { colorscheme = 'wombat' }
```

See [plugin/](./plugin) and [lua/rafi/extras/](./lua/rafi/extras) for
examples that lazy-load with [lua/rafi/pack.lua](./lua/rafi/pack.lua).

### Extend: Defaults

1. Create `lua/config/options.lua` and set any Neovim/RafiVim features:
    (Default values are shown)

    ```lua
    -- Elite-mode (hjkl mode. arrow-keys resize window)
    vim.g.elite_mode = false

    -- External file diff program
    vim.g.diffprg = 'bcompare'

    -- <Tab> selects completion items, jumps in snippets and opens
    -- completion (coding.blink). false keeps <Tab> for snippet jumps and
    -- AI actions only.
    vim.g.cmp_supertab = true
    ```

### Extend: LSP Settings

Override server options with `vim.lsp.config()`, for example in
`lua/plugins/lsp.lua` (or an `after/lsp/<server>.lua` file):

```lua
vim.lsp.config('yamlls', {
  filetypes = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
})
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = 'Replace' },
    },
  },
})
```

## Plugin Highlights

* Plugin management with Neovim's built-in [vim.pack], lazy-loaded with
  small `plugin/` files
* Auto-completion with Language-Server Protocol (LSP)
* Project-aware tabline
* Extensive syntax highlighting with [nvim-treesitter/nvim-treesitter] (`treesitter.nvim-treesitter` extra)

_Note_ that 95% of the plugins are **lazy-loaded**.

## Plugins Included

<details open>
  <summary><strong>List of plugins</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

Core plugins, one file each under [plugin/](./plugin). Turn one off by
adding its file name (e.g. `lualine`) to `disabled` in `rafi.json`. Most
other plugins are extras, and many of them are enabled by default, see
[Extra Plugins](#extra-plugins).

| File           | Repository     | Description |
| -------------- | -------------- | ---------------------- |
| `conform`      | [stevearc/conform.nvim] | Lightweight yet powerful formatter plugin |
| `lint`         | [mfussenegger/nvim-lint] | Asynchronous linter plugin, reports via `vim.diagnostic` |
| `lspconfig`    | [neovim/nvim-lspconfig] | Quickstart configs for Nvim LSP, with [mason-org/mason-lspconfig.nvim] and [b0o/SchemaStore.nvim] |
| `lualine`      | [nvim-lualine/lualine.nvim] | Blazing fast and easy to configure statusline |
| `mason`        | [mason-org/mason.nvim] | Portable package manager for Neovim |
| `mini-icons`   | [nvim-mini/mini.icons] | Icon provider |
| `morrow`       | [rafi/neo-hybrid.vim] | `morrow` colorschemes, modern dark, hybrid improved |
| `snacks`       | [folke/snacks.nvim] | Collection of QoL plugins: picker, explorer, terminal, toggles (required) |
| `theme-loader` | [rafi/theme-loader.nvim] | Use last-used colorscheme |

[nvim-mini/mini.misc] always loads, it powers the lazy-loading helpers in
[lua/rafi/pack.lua](./lua/rafi/pack.lua).

[stevearc/conform.nvim]: https://github.com/stevearc/conform.nvim
[mfussenegger/nvim-lint]: https://github.com/mfussenegger/nvim-lint
[neovim/nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[mason-org/mason-lspconfig.nvim]: https://github.com/mason-org/mason-lspconfig.nvim
[b0o/SchemaStore.nvim]: https://github.com/b0o/SchemaStore.nvim
[nvim-lualine/lualine.nvim]: https://github.com/nvim-lualine/lualine.nvim
[mason-org/mason.nvim]: https://github.com/mason-org/mason.nvim
[nvim-mini/mini.icons]: https://github.com/nvim-mini/mini.icons
[rafi/neo-hybrid.vim]: https://github.com/rafi/neo-hybrid.vim
[folke/snacks.nvim]: https://github.com/folke/snacks.nvim
[rafi/theme-loader.nvim]: https://github.com/rafi/theme-loader.nvim
[nvim-mini/mini.misc]: https://github.com/nvim-mini/mini.misc

</details>

## Extra Plugins

<details open>
  <summary><strong>List of extras</strong> <small><i>(🔎 Click to expand/collapse)</i></small></summary>

Opt-in plugins, one file each under [lua/rafi/extras/](./lua/rafi/extras).
Toggle them with `:RafiExtras` (saved in `rafi.json`), see
[Extend: Plugins](#extend-plugins).

### Extra Plugins: AI

Extra: `ai.<name>`

| Name             | Repository     | Description |
| ---------------- | -------------- | ---------------------- |
| `avante`         | [avante-corp/avante.nvim] | Cursor-like AI chat and edit sidebar |
| `claudecode`     | [coder/claudecode.nvim] | Claude Code integration |
| `codeium`        | [Exafunction/windsurf.nvim] | Codeium completion (run `:Codeium Auth` once to sign in) |
| `copilot`        | [zbirenbaum/copilot.lua] | GitHub Copilot (run `:Copilot auth` once to sign in) |
| `copilot-chat`   | [CopilotC-Nvim/CopilotChat.nvim] | Chat with GitHub Copilot |
| `copilot-native` | Neovim's native inline completion | Copilot language server inline completion (needs Neovim 0.12, `:LspCopilotSignIn`, exclusive with `ai.copilot`) |
| `sidekick`       | [folke/sidekick.nvim] | Next edit suggestions with the Copilot LSP server, and AI CLI sessions |
| `supermaven`     | [supermaven-inc/supermaven-nvim] | Supermaven completion (run `:SupermavenUseFree` or `:SupermavenUsePro`) |
| `tabnine`        | [tzachar/cmp-tabnine] | Tabnine completion as a blink.cmp source (downloads its binary on install) |

All of them share the `<leader>a` keys (the one later in `rafi.json` wins),
and `vim.g.ai_cmp` selects completion-menu or inline suggestions.

[avante-corp/avante.nvim]: https://github.com/avante-corp/avante.nvim
[coder/claudecode.nvim]: https://github.com/coder/claudecode.nvim
[Exafunction/windsurf.nvim]: https://github.com/Exafunction/windsurf.nvim
[zbirenbaum/copilot.lua]: https://github.com/zbirenbaum/copilot.lua
[CopilotC-Nvim/CopilotChat.nvim]: https://github.com/CopilotC-Nvim/CopilotChat.nvim
[folke/sidekick.nvim]: https://github.com/folke/sidekick.nvim
[supermaven-inc/supermaven-nvim]: https://github.com/supermaven-inc/supermaven-nvim
[tzachar/cmp-tabnine]: https://github.com/tzachar/cmp-tabnine

### Extra Plugins: Coding

Extra: `coding.<name>`

| Name           | Repository     | Description |
| -------------- | -------------- | ---------------------- |
| `align`           | [nvim-mini/mini.align] | Align text interactively |
| `blink`           | [saghen/blink.cmp] | Code completion, with [rafamadriz/friendly-snippets] (enabled by default) |
| `chainsaw`        | [chrisgrieser/nvim-chainsaw] | Create log statements on the fly |
| `comment`         | [numToStr/Comment.nvim] | Powerful line and block-wise commenting, with [JoosepAlviste/nvim-ts-context-commentstring] |
| `debugprint`      | [andrewferrier/debugprint.nvim] | Debugging in Neovim the print() way |
| `emmet`           | [mattn/emmet-vim] | Expand abbreviations à la emmet |
| `lazydev`         | [folke/lazydev.nvim] | Configures LuaLS for editing Neovim config and plugins (enabled by default) |
| `linediff`        | [AndrewRadev/linediff.vim] | Perform diffs on blocks of code |
| `mini-ai`         | [nvim-mini/mini.ai] | Extend and create `a`/`i` textobjects (enabled by default) |
| `mini-comment`    | [nvim-mini/mini.comment] | Fast and feature-rich commenting (`gc`), with treesitter context |
| `mini-pairs`      | [nvim-mini/mini.pairs] | Automatically manage character pairs (enabled by default) |
| `mini-splitjoin`  | [nvim-mini/mini.splitjoin] | Split and join arguments (enabled by default) |
| `mini-surround`   | [nvim-mini/mini.surround] | Fast and feature-rich surround actions (enabled by default) |
| `mini-trailspace` | [nvim-mini/mini.trailspace] | Trailing whitespace highlight and remove (enabled by default) |
| `neogen`          | [danymat/neogen] | Annotation generator |
| `sibling-swap`    | [Wansmer/sibling-swap.nvim] | Swap sibling treesitter nodes |
| `tabout`          | [abecodes/tabout.nvim] | Tab out of brackets and quotes |
| `ts-comments`     | [folke/ts-comments.nvim] | Enhance Neovim's native comments with treesitter context (enabled by default) |
| `yanky`           | [gbprod/yanky.nvim] | Better yank and paste: yank ring, history picker, cycle after put |

[nvim-mini/mini.align]: https://github.com/nvim-mini/mini.align
[chrisgrieser/nvim-chainsaw]: https://github.com/chrisgrieser/nvim-chainsaw
[andrewferrier/debugprint.nvim]: https://github.com/andrewferrier/debugprint.nvim
[mattn/emmet-vim]: https://github.com/mattn/emmet-vim
[numToStr/Comment.nvim]: https://github.com/numToStr/Comment.nvim
[AndrewRadev/linediff.vim]: https://github.com/AndrewRadev/linediff.vim
[nvim-mini/mini.ai]: https://github.com/nvim-mini/mini.ai
[nvim-mini/mini.pairs]: https://github.com/nvim-mini/mini.pairs
[nvim-mini/mini.splitjoin]: https://github.com/nvim-mini/mini.splitjoin
[nvim-mini/mini.surround]: https://github.com/nvim-mini/mini.surround
[nvim-mini/mini.trailspace]: https://github.com/nvim-mini/mini.trailspace
[danymat/neogen]: https://github.com/danymat/neogen
[Wansmer/sibling-swap.nvim]: https://github.com/Wansmer/sibling-swap.nvim
[abecodes/tabout.nvim]: https://github.com/abecodes/tabout.nvim
[folke/ts-comments.nvim]: https://github.com/folke/ts-comments.nvim
[JoosepAlviste/nvim-ts-context-commentstring]: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
[gbprod/yanky.nvim]: https://github.com/gbprod/yanky.nvim
[nvim-mini/mini.comment]: https://github.com/nvim-mini/mini.comment
[saghen/blink.cmp]: https://github.com/saghen/blink.cmp
[rafamadriz/friendly-snippets]: https://github.com/rafamadriz/friendly-snippets
[folke/lazydev.nvim]: https://github.com/folke/lazydev.nvim

### Extra Plugins: Colorscheme

Extra: `colorscheme.<name>`

| Name           | Repository     | Description |
| -------------- | -------------- | ---------------------- |
| `bamboo`       | [ribru17/bamboo.nvim] | Warm green theme |
| `catppuccin`   | [catppuccin/nvim] | Soothing pastel theme |
| `cyberdream`   | [scottmckendry/cyberdream.nvim] | High-contrast, futuristic & vibrant colorscheme |
| `github`       | [projekt0n/github-nvim-theme] | Github's Neovim themes |
| `kanagawa`     | [rebelot/kanagawa.nvim] | Colorscheme inspired by Katsushika Hokusai's famous painting |
| `lackluster`   | [slugbyte/lackluster.nvim] | Minimal, mostly monochrome colorscheme that's soft on the eyes |
| `material`     | [marko-cerovac/material.nvim] | Colorscheme based on the Material Design color palette |
| `meowsoot`     | [marekh19/meowsoot.nvim] | Pink-cyan-lavender colorscheme, where green never reaches code |
| `modus`        | [miikanissi/modus-themes.nvim] | Highly accessible themes conforming with WCAG AAA color contrast |
| `monokai-nightasty` | [polirritmico/monokai-nightasty.nvim] | Dark/light theme based on the Monokai color palette |
| `monokai-pro`  | [loctvl842/monokai-pro.nvim] | Monokai Pro colorscheme, with several filter variants |
| `onenord`      | [rmehri01/onenord.nvim] | Theme combining the Nord and Atom One Dark color palettes |
| `oxocarbon`    | [nyoom-engineering/oxocarbon.nvim] | Dark and light theme inspired by IBM Carbon |
| `tokyonight`   | [folke/tokyonight.nvim] | Clean, dark Neovim theme (enabled by default) |

[ribru17/bamboo.nvim]: https://github.com/ribru17/bamboo.nvim
[scottmckendry/cyberdream.nvim]: https://github.com/scottmckendry/cyberdream.nvim
[projekt0n/github-nvim-theme]: https://github.com/projekt0n/github-nvim-theme
[rebelot/kanagawa.nvim]: https://github.com/rebelot/kanagawa.nvim
[slugbyte/lackluster.nvim]: https://github.com/slugbyte/lackluster.nvim
[marko-cerovac/material.nvim]: https://github.com/marko-cerovac/material.nvim
[marekh19/meowsoot.nvim]: https://github.com/marekh19/meowsoot.nvim
[miikanissi/modus-themes.nvim]: https://github.com/miikanissi/modus-themes.nvim
[polirritmico/monokai-nightasty.nvim]: https://github.com/polirritmico/monokai-nightasty.nvim
[loctvl842/monokai-pro.nvim]: https://github.com/loctvl842/monokai-pro.nvim
[rmehri01/onenord.nvim]: https://github.com/rmehri01/onenord.nvim
[nyoom-engineering/oxocarbon.nvim]: https://github.com/nyoom-engineering/oxocarbon.nvim
[catppuccin/nvim]: https://github.com/catppuccin/nvim
[folke/tokyonight.nvim]: https://github.com/folke/tokyonight.nvim

### Extra Plugins: Editor

Extra: `editor.<name>`

| Name          | Repository     | Description |
| --------------| -------------- | ---------------------- |
| `anyjump`         | [pechorin/any-jump.vim] | Jump to any definition and references without overhead |
| `auto-session`    | [rmagatti/auto-session] | Automatically save and restore sessions (enabled by default) |
| `dbee`            | [kndndrj/nvim-dbee] | Interactive database client |
| `dial`            | [monaqa/dial.nvim] | Increment and decrement numbers, dates, and more (enabled by default) |
| `fff`             | [dmtrKovalenko/fff] | Fast fuzzy file finder and live grep with frecency |
| `firenvim`        | [glacambre/firenvim] | Neovim in the browser |
| `flybuf`          | [nvimdev/flybuf.nvim] | List buffers in a float window |
| `fzf`             | [ibhagwan/fzf-lua] | FZF picker, alternative to the snacks picker |
| `glance`          | [dnlhc/glance.nvim] | Pretty window for navigating LSP locations |
| `grug-far`        | [MagicDuck/grug-far.nvim] | Search/replace in multiple files (enabled by default) |
| `guess-indent`    | [nmac427/guess-indent.nvim] | Automatic indentation style detection (enabled by default) |
| `harpoon2`        | [ThePrimeagen/harpoon] | Marks for navigating your project |
| `helpful`         | [tweekmonster/helpful.vim] | Display vim version numbers in docs |
| `inc-rename`      | [smjonas/inc-rename.nvim] | Incremental LSP renaming, based on Neovim's command-preview |
| `key-analyzer`    | [meznaric/key-analyzer.nvim] | Visualize keyboard mappings for a prefix on a keyboard layout |
| `kubectl`         | [ramilito/kubectl.nvim] | Browse and manage Kubernetes resources |
| `leap`            | [andyg/leap.nvim] | General-purpose motion plugin for fast cursor movement |
| `mini-diff`       | [nvim-mini/mini.diff] | Git diff signs and hunk overlay |
| `mini-files`      | [nvim-mini/mini.files] | Column-based file explorer |
| `mini-hipatterns` | [nvim-mini/mini.hipatterns] | Highlight patterns in text, e.g. hex colors and Tailwind CSS classes (enabled by default) |
| `mini-move`       | [nvim-mini/mini.move] | Move lines and selections with Alt-h/j/k/l |
| `mini-visits`     | [nvim-mini/mini.visits] | Track and reuse file system visits |
| `namu`            | [bassamsdata/namu.nvim] | Flexible symbol navigation (LSP, treesitter, ctags, diagnostics) (enabled by default) |
| `neo-tree`        | [nvim-neo-tree/neo-tree.nvim] | File explorer tree (replaces the core Snacks explorer) |
| `oil`             | [stevearc/oil.nvim] | File explorer that lets you edit the filesystem like a buffer |
| `outline`         | [hedyhli/outline.nvim] | Code outline sidebar powered by LSP |
| `packman`         | [rafi/packman.nvim] | Review and apply vim.pack plugin updates in a picker (enabled by default) |
| `quickhl`         | [t9md/vim-quickhl] | Highlight words quickly |
| `rest`            | [rest-nvim/rest.nvim] | Fast Neovim http client written in Lua |
| `suda`            | [lambdalisue/vim-suda] | Read or write files with sudo |
| `telescope`       | [nvim-telescope/telescope.nvim] | Telescope as the picker (replaces snacks picker keys), with fzf-native and [jvgrootveld/telescope-zoxide] |
| `thesaurus`       | [rafi/telescope-thesaurus.nvim] | Browse synonyms and definitions, via the snacks picker (telescope's with `editor.telescope`) |
| `tmux-navigator`  | [christoomey/vim-tmux-navigator] | Seamless navigation between tmux panes and vim splits (enabled by default) |
| `todo-comments`   | [folke/todo-comments.nvim] | Highlight, list and search todo comments in your projects (enabled by default) |
| `trouble`         | [folke/trouble.nvim] | Pretty lists to help you solve all code diagnostics (enabled by default) |
| `ufo`             | [kevinhwang91/nvim-ufo] | Make folds look modern and keep a high performance |
| `undotree`        | [mbbill/undotree] | Visualize the undo history tree |
| `window-picker`   | [s1n7ax/nvim-window-picker] | Fancy window picker (enabled by default) |

[pechorin/any-jump.vim]: https://github.com/pechorin/any-jump.vim
[kndndrj/nvim-dbee]: https://github.com/kndndrj/nvim-dbee
[monaqa/dial.nvim]: https://github.com/monaqa/dial.nvim
[glacambre/firenvim]: https://github.com/glacambre/firenvim
[nvimdev/flybuf.nvim]: https://github.com/nvimdev/flybuf.nvim
[ThePrimeagen/harpoon]: https://github.com/ThePrimeagen/harpoon
[meznaric/key-analyzer.nvim]: https://github.com/meznaric/key-analyzer.nvim
[ramilito/kubectl.nvim]: https://github.com/ramilito/kubectl.nvim
[nvim-mini/mini.visits]: https://github.com/nvim-mini/mini.visits
[nvim-neo-tree/neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim
[stevearc/oil.nvim]: https://github.com/stevearc/oil.nvim
[rest-nvim/rest.nvim]: https://github.com/rest-nvim/rest.nvim
[jvgrootveld/telescope-zoxide]: https://github.com/jvgrootveld/telescope-zoxide
[kevinhwang91/nvim-ufo]: https://github.com/kevinhwang91/nvim-ufo
[dnlhc/glance.nvim]: https://github.com/dnlhc/glance.nvim
[MagicDuck/grug-far.nvim]: https://github.com/MagicDuck/grug-far.nvim
[nmac427/guess-indent.nvim]: https://github.com/nmac427/guess-indent.nvim
[tweekmonster/helpful.vim]: https://github.com/tweekmonster/helpful.vim
[andyg/leap.nvim]: https://codeberg.org/andyg/leap.nvim
[nvim-mini/mini.hipatterns]: https://github.com/nvim-mini/mini.hipatterns
[bassamsdata/namu.nvim]: https://github.com/bassamsdata/namu.nvim
[hedyhli/outline.nvim]: https://github.com/hedyhli/outline.nvim
[t9md/vim-quickhl]: https://github.com/t9md/vim-quickhl
[lambdalisue/vim-suda]: https://github.com/lambdalisue/vim-suda
[rafi/telescope-thesaurus.nvim]: https://github.com/rafi/telescope-thesaurus.nvim
[mbbill/undotree]: https://github.com/mbbill/undotree
[ibhagwan/fzf-lua]: https://github.com/ibhagwan/fzf-lua
[smjonas/inc-rename.nvim]: https://github.com/smjonas/inc-rename.nvim
[nvim-mini/mini.diff]: https://github.com/nvim-mini/mini.diff
[nvim-mini/mini.files]: https://github.com/nvim-mini/mini.files
[nvim-mini/mini.move]: https://github.com/nvim-mini/mini.move
[rmagatti/auto-session]: https://github.com/rmagatti/auto-session
[dmtrKovalenko/fff]: https://github.com/dmtrKovalenko/fff
[rafi/packman.nvim]: https://github.com/rafi/packman.nvim
[nvim-telescope/telescope.nvim]: https://github.com/nvim-telescope/telescope.nvim
[christoomey/vim-tmux-navigator]: https://github.com/christoomey/vim-tmux-navigator
[folke/todo-comments.nvim]: https://github.com/folke/todo-comments.nvim
[folke/trouble.nvim]: https://github.com/folke/trouble.nvim
[s1n7ax/nvim-window-picker]: https://github.com/s1n7ax/nvim-window-picker

### Extra Plugins: Formatting

Extra: `formatting.<name>`

| Name           | Repository     | Description |
| -------------- | -------------- | ---------------------- |
| `black`        | [psf/black] | Python formatter, via conform |
| `prettier`     | [prettier/prettier] | Formatter for web, markdown, yaml and more, via conform (only when a prettier config exists) |

[psf/black]: https://github.com/psf/black
[prettier/prettier]: https://github.com/prettier/prettier

### Extra Plugins: Git

Extra: `git.<name>`

| Name         | Repository     | Description |
| -------------| -------------- | ---------------------- |
| `blame`      | [FabijanZulj/blame.nvim] | Show git blame annotations inline, or in a scrollable window |
| `committia`  | [rhysd/committia.vim] | Pleasant editing on Git commit messages (enabled by default) |
| `diffview`   | [sindrets/diffview.nvim] | Tabpage interface for cycling through diffs (enabled by default) |
| `fugitive`   | [tpope/vim-fugitive] | Git client, including [junegunn/gv.vim] commit browser |
| `gitsigns`   | [lewis6991/gitsigns.nvim] | Git signs written in pure lua (enabled by default) |
| `neogit`     | [NeogitOrg/neogit] | Magit clone for Neovim |

[FabijanZulj/blame.nvim]: https://github.com/FabijanZulj/blame.nvim
[tpope/vim-fugitive]: https://github.com/tpope/vim-fugitive
[junegunn/gv.vim]: https://github.com/junegunn/gv.vim
[rhysd/committia.vim]: https://github.com/rhysd/committia.vim
[sindrets/diffview.nvim]: https://github.com/sindrets/diffview.nvim
[lewis6991/gitsigns.nvim]: https://github.com/lewis6991/gitsigns.nvim
[NeogitOrg/neogit]: https://github.com/NeogitOrg/neogit

### Extra Plugins: Grammar

Extra: `grammar.<name>`

| Name         | Description |
| -------------| ---------------------- |
| `harper`     | [Harper] grammar and prose checker language server for Markdown |

[Harper]: https://github.com/Automattic/harper

### Extra Plugins: Lang

Extra: `lang.<name>`. Each registers its language servers, Mason tools,
linters and formatters with `rafi.util.lang`, plus any plugins listed.

| Name             | Description |
| ---------------- | ---------------------- |
| `ansible`        | [mfussenegger/nvim-ansible] filetypes/ftplugin, ansiblels and ansible-lint |
| `bruno`          | `.bru` filetype and its [tree-sitter-bruno] parser |
| `clangd`         | C/C++: clangd and [dchinmay2/clangd_extensions.nvim] |
| `docker`         | Dockerfile and compose language servers, hadolint linter |
| `go`             | gopls, Go tools, golangci-lint and formatters |
| `helm`           | [qvalentin/helm-ls.nvim] filetypes/ftplugin, and helm_ls language server |
| `java`           | [mfussenegger/nvim-jdtls], jdtls started per Java buffer (installed by Mason) |
| `json`           | jsonls with SchemaStore schemas (enabled by default) |
| `log-highlighting` | [MTDL9/vim-log-highlighting] syntax for log files |
| `markdown`       | panache, [MeanderingProgrammer/render-markdown.nvim] and [selimacerbas/mdkite.nvim] (with [selimacerbas/kitehost.nvim]) (enabled by default) |
| `mustache-handlebars` | [mustache/vim-mustache-handlebars] syntax, indent and ftplugin |
| `nix`            | nil language server, nixfmt formatter and statix linter |
| `python`         | pyright + ruff, [linux-cultist/venv-selector.nvim] |
| `reason`         | [reasonml-editor/vim-reason-plus] syntax and indent |
| `rust`           | [mrcjkb/rustaceanvim] (rust-analyzer) and [Saecki/crates.nvim] for `Cargo.toml` |
| `sql`            | [tpope/vim-dadbod] stack with [kristijanhusak/vim-dadbod-ui] (`:DBUI`, `<leader>D`) and [kristijanhusak/vim-dadbod-completion], sqlfluff |
| `stylus`         | [iloginow/vim-stylus] syntax, indent and completion |
| `svelte`         | Svelte language server, plus the vtsls plugin |
| `tailwind`       | Tailwind CSS language server |
| `terraform`      | terraformls, tflint, validate linter and fmt formatters |
| `tmux`           | Tmuxfile filetype, and `gK` opens `man tmux` at the word |
| `toml`           | taplo language server (enabled by default) |
| `typescript`     | vtsls language server for TypeScript/JavaScript |
| `vue`            | vue_ls (hybrid mode) plus vtsls with `@vue/typescript-plugin` |
| `yaml`           | yamlls with SchemaStore and Kubernetes schemas (enabled by default) |

[mfussenegger/nvim-ansible]: https://github.com/mfussenegger/nvim-ansible
[tree-sitter-bruno]: https://github.com/Scalamando/tree-sitter-bruno
[qvalentin/helm-ls.nvim]: https://github.com/qvalentin/helm-ls.nvim
[MTDL9/vim-log-highlighting]: https://github.com/MTDL9/vim-log-highlighting
[MeanderingProgrammer/render-markdown.nvim]: https://github.com/MeanderingProgrammer/render-markdown.nvim
[selimacerbas/mdkite.nvim]: https://github.com/selimacerbas/mdkite.nvim
[selimacerbas/kitehost.nvim]: https://github.com/selimacerbas/kitehost.nvim
[mustache/vim-mustache-handlebars]: https://github.com/mustache/vim-mustache-handlebars
[linux-cultist/venv-selector.nvim]: https://github.com/linux-cultist/venv-selector.nvim
[reasonml-editor/vim-reason-plus]: https://github.com/reasonml-editor/vim-reason-plus
[iloginow/vim-stylus]: https://github.com/iloginow/vim-stylus
[dchinmay2/clangd_extensions.nvim]: https://github.com/dchinmay2/clangd_extensions.nvim
[mfussenegger/nvim-jdtls]: https://github.com/mfussenegger/nvim-jdtls
[mrcjkb/rustaceanvim]: https://github.com/mrcjkb/rustaceanvim
[Saecki/crates.nvim]: https://github.com/Saecki/crates.nvim
[tpope/vim-dadbod]: https://github.com/tpope/vim-dadbod
[kristijanhusak/vim-dadbod-ui]: https://github.com/kristijanhusak/vim-dadbod-ui
[kristijanhusak/vim-dadbod-completion]: https://github.com/kristijanhusak/vim-dadbod-completion

### Extra Plugins: Linting

Extra: `linting.<name>`

| Name           | Description |
| -------------- | ---------------------- |
| `eslint`       | ESLint language server, with fix-all on save (`vim.g.eslint_auto_format`) |

### Extra Plugins: LSP

Extra: `lsp.<name>`

| Key              | Name           | Description |
| ---------------- | -------------- | ---------------------- |
| `actions-preview` | [aznhe21/actions-preview.nvim] | Fully customizable previewer for LSP code actions, replaces `<leader>ca` |
| `gtd`            | [hrsh7th/nvim-gtd] | LSP's go-to definition or file, with findup/walk fallbacks |
| `lightbulb`      | [kosayoda/nvim-lightbulb] | VSCode 💡 for neovim's built-in LSP |

[aznhe21/actions-preview.nvim]: https://github.com/aznhe21/actions-preview.nvim
[hrsh7th/nvim-gtd]: https://github.com/hrsh7th/nvim-gtd
[kosayoda/nvim-lightbulb]: https://github.com/kosayoda/nvim-lightbulb

### Extra Plugins: Org

Extra: `org.<name>`

| Key            | Name           | Description |
| -------------- | -------------- | ---------------------- |
| `calendar`     | [itchyny/calendar.vim] | Calendar application with Google Calendar/Tasks sync |
| `obsidian`     | [obsidian-nvim/obsidian.nvim] | Obsidian vault notes: links, backlinks, dailies, templates |
| `telekasten`   | [nvim-telekasten/telekasten.nvim] | Markdown zettelkasten or wiki with telescope |
| `vimwiki`      | [vimwiki/vimwiki] | Personal wiki with markdown syntax in `~/notebook` |
| `zk`           | [zk-org/zk-nvim] | Zettelkasten note-taking with the zk CLI |

[itchyny/calendar.vim]: https://github.com/itchyny/calendar.vim
[obsidian-nvim/obsidian.nvim]: https://github.com/obsidian-nvim/obsidian.nvim
[nvim-telekasten/telekasten.nvim]: https://github.com/nvim-telekasten/telekasten.nvim
[vimwiki/vimwiki]: https://github.com/vimwiki/vimwiki
[zk-org/zk-nvim]: https://github.com/zk-org/zk-nvim

### Extra Plugins: Treesitter

Extra: `treesitter.<name>`

| Key            | Name                         | Description |
| -------------- | ---------------------------- | ---------------------- |
| `arborist`     | [arborist-ts/arborist.nvim] | Tree-sitter parser manager, installs parsers on demand |
| `autotag`      | [windwp/nvim-ts-autotag] | Automatically add closing tags for HTML and JSX (enabled by default) |
| `diffmantic`   | [HarshK97/diffmantic.nvim] | Semantic diff using Treesitter |
| `endwise`      | [RRethy/nvim-treesitter-endwise] | Wisely add "end" in Ruby, Lua, Vimscript and other languages |
| `matchup`      | [andymass/vim-matchup] | Modern matchit and matchparen (enabled by default) |
| `nvim-treesitter` | [nvim-treesitter/nvim-treesitter] | Tree-sitter parsers, highlight, indent and folds (`main` branch; enabled by default) |
| `textobjects`  | [nvim-treesitter/nvim-treesitter-textobjects] | Tree-sitter textobject motions (enabled by default) |
| `treesj`       | [Wansmer/treesj] | Split and join blocks of code, using Tree-sitter |

Enable only one of `arborist` and `nvim-treesitter`, both install parsers
and start highlighting (`arborist` skips itself if `nvim-treesitter` is on).

[arborist-ts/arborist.nvim]: https://github.com/arborist-ts/arborist.nvim
[HarshK97/diffmantic.nvim]: https://github.com/HarshK97/diffmantic.nvim
[RRethy/nvim-treesitter-endwise]: https://github.com/RRethy/nvim-treesitter-endwise
[nvim-treesitter/nvim-treesitter]: https://github.com/nvim-treesitter/nvim-treesitter
[Wansmer/treesj]: https://github.com/Wansmer/treesj
[windwp/nvim-ts-autotag]: https://github.com/windwp/nvim-ts-autotag
[andymass/vim-matchup]: https://github.com/andymass/vim-matchup
[nvim-treesitter/nvim-treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

### Extra Plugins: UI

Extra: `ui.<name>`

| Key               | Name           | Description |
| ----------------- | -------------- | ---------------------- |
| `alpha`           | [goolord/alpha-nvim] | Fast and fully programmable greeter dashboard |
| `bookmarks`       | [tomasky/bookmarks.nvim] | Bookmarks with a global file store and sign annotations (enabled by default) |
| `bqf`             | [kevinhwang91/nvim-bqf] | Preview and enhanced quickfix window |
| `bufferline`      | [akinsho/bufferline.nvim] | Snazzy tab/bufferline (enabled by default) |
| `ccc`             | [uga-rosa/ccc.nvim] | Super powerful color picker/colorizer plugin |
| `colorful-winsep` | [nvim-zh/colorful-winsep.nvim] | Colorful and animated window separators |
| `cursorword`      | [itchyny/vim-cursorword] | Underlines other uses of the word under the cursor, in select filetypes |
| `cybu`            | [ghillb/cybu.nvim] | Cycle buffers with a notification window listing them |
| `deadcolumn`      | [Bekaboo/deadcolumn.nvim] | Show colorcolumn dynamically |
| `goto-preview`    | [rmagatti/goto-preview] | Preview definitions, implementations and references in floats |
| `illuminate`      | [RRethy/vim-illuminate] | Highlights other uses of the word under the cursor (regex/treesitter/LSP) |
| `incline`         | [b0o/incline.nvim] | Floating statuslines |
| `marks`           | [chentoast/marks.nvim] | Interacting with and manipulating marks |
| `mini-animate`    | [nvim-mini/mini.animate] | Animate scrolling, cursor movement and window resizing |
| `mini-clue`       | [nvim-mini/mini.clue] | Show next key clues, replaces which-key |
| `mini-indentscope` | [nvim-mini/mini.indentscope] | Active indent scope line and textobjects |
| `mini-map`        | [nvim-mini/mini.map] | Window with buffer text overview, scrollbar and highlights |
| `mini-starter`    | [nvim-mini/mini.starter] | Start screen, alternative to `ui.alpha` |
| `packcount`       | [rafi/packcount.nvim] | Statusline count of plugins with pending vim.pack updates, Neovim 0.13+ (enabled by default) |
| `quicker`         | [stevearc/quicker.nvim] | Improved diagnostics and location/quickfix list windows |
| `smear-cursor`    | [sphamba/smear-cursor.nvim] | Animate cursor movement with a smear effect |
| `staline`         | [tamton-aquib/staline.nvim] | Minimal statusline, replaces lualine |
| `tabby`           | [nanozuki/tabby.nvim] | Tabpage-based tabline with tab rename, window picker and jump mode, alternative to `ui.bufferline` |
| `treesitter-context` | [nvim-treesitter/nvim-treesitter-context] | Show the context of the current function |
| `which-key`       | [folke/which-key.nvim] | Popup with possible key bindings of the command you started typing (enabled by default) |

[goolord/alpha-nvim]: https://github.com/goolord/alpha-nvim
[tomasky/bookmarks.nvim]: https://github.com/tomasky/bookmarks.nvim
[kevinhwang91/nvim-bqf]: https://github.com/kevinhwang91/nvim-bqf
[uga-rosa/ccc.nvim]: https://github.com/uga-rosa/ccc.nvim
[nvim-zh/colorful-winsep.nvim]: https://github.com/nvim-zh/colorful-winsep.nvim
[itchyny/vim-cursorword]: https://github.com/itchyny/vim-cursorword
[ghillb/cybu.nvim]: https://github.com/ghillb/cybu.nvim
[Bekaboo/deadcolumn.nvim]: https://github.com/Bekaboo/deadcolumn.nvim
[rmagatti/goto-preview]: https://github.com/rmagatti/goto-preview
[RRethy/vim-illuminate]: https://github.com/RRethy/vim-illuminate
[b0o/incline.nvim]: https://github.com/b0o/incline.nvim
[chentoast/marks.nvim]: https://github.com/chentoast/marks.nvim
[nvim-mini/mini.clue]: https://github.com/nvim-mini/mini.clue
[nvim-mini/mini.map]: https://github.com/nvim-mini/mini.map
[stevearc/quicker.nvim]: https://github.com/stevearc/quicker.nvim
[tamton-aquib/staline.nvim]: https://github.com/tamton-aquib/staline.nvim
[nvim-mini/mini.animate]: https://github.com/nvim-mini/mini.animate
[nvim-mini/mini.indentscope]: https://github.com/nvim-mini/mini.indentscope
[nvim-mini/mini.starter]: https://github.com/nvim-mini/mini.starter
[sphamba/smear-cursor.nvim]: https://github.com/sphamba/smear-cursor.nvim
[nvim-treesitter/nvim-treesitter-context]: https://github.com/nvim-treesitter/nvim-treesitter-context
[nanozuki/tabby.nvim]: https://github.com/nanozuki/tabby.nvim
[akinsho/bufferline.nvim]: https://github.com/akinsho/bufferline.nvim
[rafi/packcount.nvim]: https://github.com/rafi/packcount.nvim
[folke/which-key.nvim]: https://github.com/folke/which-key.nvim

### Extra Plugins: Util

Extra: `util.<name>`

| Name           | Repository     | Description |
| -------------- | -------------- | ---------------------- |
| `gh`           | [ldelossa/gh.nvim] | GitHub code review inside Neovim (needs the `gh` CLI) |
| `octo`         | [pwntester/octo.nvim] | Edit and review GitHub issues and pull requests |
| `project`      | [ahmedkhalf/project.nvim] | Recent projects list and root detection |
| `startuptime`  | [dstein64/vim-startuptime] | Measure startup time |

[ldelossa/gh.nvim]: https://github.com/ldelossa/gh.nvim
[pwntester/octo.nvim]: https://github.com/pwntester/octo.nvim
[ahmedkhalf/project.nvim]: https://github.com/ahmedkhalf/project.nvim
[dstein64/vim-startuptime]: https://github.com/dstein64/vim-startuptime

</details>

## Custom Key-mappings

Note that,

* **Leader** key set as <kbd>Space</kbd>
* **Local-Leader** key set as <kbd>;</kbd> and used for navigation and search
  (Snacks/Telescope and Neo-tree)
* Disable <kbd>←</kbd> <kbd>↑</kbd> <kbd>→</kbd> <kbd>↓</kbd> in normal mode by enabling `vim.g.elite_mode`.

<details open>
  <summary>
    <strong>Key-mappings</strong>
    <small><i>(🔎 Click to expand/collapse)</i></small>
  </summary>

Legend: | Ⓝormal | Ⓥisual | Ⓢelect | Ⓘnsert | Ⓞperator | Ⓒommand |

### Picker

 (Snacks/Telescope)

| Key   | Mode | Action |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd> <kbd>;</kbd> | Ⓝ | Select picker |
| <kbd>;r</kbd> | Ⓝ | Resume previous picker |
| <kbd>;p</kbd> | Ⓝ | Projects |
| <kbd>;f</kbd> | Ⓝ | File |
| <kbd>;F</kbd> | Ⓝ | File (cwd) |
| <kbd>;g</kbd> | Ⓝ | Grep search |
| <kbd>;G</kbd> | Ⓝ | Grep search (cwd) |
| <kbd>;b</kbd> | Ⓝ | Switch buffers |
| <kbd>;h</kbd> | Ⓝ | Help pages |
| <kbd>;H</kbd> | Ⓝ | Highlights |
| <kbd>;j</kbd> | Ⓝ | Jumplist |
| <kbd>;m</kbd> | Ⓝ | Jump to mark |
| <kbd>;M</kbd> | Ⓝ | Man pages |
| <kbd>;o</kbd> | Ⓝ | Options |
| <kbd>;t</kbd> | Ⓝ | Goto symbol |
| <kbd>;T</kbd> | Ⓝ | Goto symbol (workspace) |
| <kbd>;v</kbd> | Ⓝ Ⓥ | Registers |
| <kbd>;s</kbd> | Ⓝ | Sessions |
| <kbd>;u</kbd> | Ⓝ | Spelling suggestions |
| <kbd>;x</kbd> | Ⓝ | Recent |
| <kbd>;X</kbd> | Ⓝ | Recent (cwd) |
| <kbd>;z</kbd> | Ⓝ | Zoxide directories |
| <kbd>;;</kbd> | Ⓝ | Command history |
| <kbd>;:</kbd> | Ⓝ | Commands |
| <kbd>;/</kbd> | Ⓝ | Search history |
| <kbd>;dd</kbd> | Ⓝ | LSP definitions |
| <kbd>;di</kbd> | Ⓝ | LSP implementations |
| <kbd>;dr</kbd> | Ⓝ | LSP references |
| <kbd>;da</kbd> | Ⓝ Ⓥ | LSP code actions |
| <kbd>Space</kbd> <kbd>/</kbd> | Ⓝ | Buffer fuzzy find |
| <kbd>Space</kbd> <kbd>gs</kbd> | Ⓝ | Git status |
| <kbd>Space</kbd> <kbd>gr</kbd> | Ⓝ | Git branches |
| <kbd>Space</kbd> <kbd>gh</kbd> | Ⓝ | Git stashes |
| <kbd>Space</kbd> <kbd>gF</kbd> | Ⓝ | Find files matching word under cursor |
| <kbd>Space</kbd> <kbd>gg</kbd> | Ⓝ Ⓥ | Grep word/selection |
| <kbd>Space</kbd> <kbd>gG</kbd> | Ⓝ Ⓥ | Grep word/selection (cwd) |
| <kbd>Space</kbd> <kbd>sc</kbd> | Ⓝ | Colorschemes |
| <kbd>Space</kbd> <kbd>sd</kbd> | Ⓝ | Document diagnostics |
| <kbd>Space</kbd> <kbd>sD</kbd> | Ⓝ | Workspace diagnostics |
| <kbd>Space</kbd> <kbd>sh</kbd> | Ⓝ | Help tags |
| <kbd>Space</kbd> <kbd>sk</kbd> | Ⓝ | Key-maps |
| <kbd>Space</kbd> <kbd>sm</kbd> | Ⓝ | Man pages |
| <kbd>Space</kbd> <kbd>ss</kbd> | Ⓝ | LSP document symbols |
| <kbd>Space</kbd> <kbd>sS</kbd> | Ⓝ | LSP workspace symbols |
| <kbd>Space</kbd> <kbd>st</kbd> | Ⓝ | Todo list |
| <kbd>Space</kbd> <kbd>sT</kbd> | Ⓝ | Todo/Fix/Fixme list |
| <kbd>Space</kbd> <kbd>sw</kbd> | Ⓝ | Grep string |
| | | &nbsp; |
| <kbd>;i</kbd> | Ⓝ | (Snacks only) Icons |
| <kbd>;w</kbd> | Ⓝ | (org.zk extra) Zk notes |
| <kbd>Space</kbd> <kbd>sp</kbd> | Ⓝ | Plugin directories |
| <kbd>;k</kbd> | Ⓝ | (editor.thesaurus extra) Thesaurus |
| | | &nbsp; |
| **Within _Picker_ window** | | &nbsp; |
| <kbd>?</kbd> | Ⓝ | Keymaps help screen |
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | Ⓝ | Move from none fuzzy search to fuzzy |
| <kbd>jj</kbd> or <kbd>Escape</kbd> | Ⓘ | Leave Insert mode |
| <kbd>i</kbd> | Ⓝ | Enter Insert mode (filter input) |
| <kbd>q</kbd> or <kbd>Escape</kbd> | Ⓝ | Exit |
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | Ⓝ Ⓘ | Next/previous candidate |
| <kbd>Ctrl</kbd>+<kbd>d</kbd>/<kbd>u</kbd> | Ⓝ Ⓘ | Scroll down/upwards |
| <kbd>Ctrl</kbd>+<kbd>f</kbd>/<kbd>b</kbd> | Ⓝ Ⓘ | Scroll preview down/upwards |
| <kbd>Ctrl</kbd>+<kbd>j</kbd>/<kbd>k</kbd> | Ⓝ Ⓘ | Scroll preview vertically |
| <kbd>Ctrl</kbd>+<kbd>h</kbd>/<kbd>l</kbd> | Ⓝ Ⓘ | Scroll preview horizontally |
| <kbd>J</kbd> or <kbd>K</kbd> | Ⓝ | Select candidates up/downwards |
| <kbd>st</kbd> | Ⓝ | Open in a new tab |
| <kbd>sg</kbd> | Ⓝ | Open in a vertical split |
| <kbd>sv</kbd> | Ⓝ | Open in a split |
| <kbd>*</kbd>  | Ⓝ | Toggle selection |
| <kbd>u</kbd>  | Ⓝ | Drop all |
| <kbd>w</kbd>  | Ⓝ | Smart send to quickfix list |
| <kbd>e</kbd>  | Ⓝ | Send to quickfix list |
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | Ⓘ | Send to quickfix list |
| <kbd>dd</kbd> | Ⓝ | Delete entry (buffer list) |
| <kbd>!</kbd> | Ⓝ | Edit in command line |

### Toggle Features

| Key   | Mode | Action |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd> <kbd>dph</kbd>  | Ⓝ | Toggle profiler highlights |
| <kbd>Space</kbd> <kbd>dpp</kbd>  | Ⓝ | Toggle profiler |
| <kbd>Space</kbd> <kbd>ua</kbd> | Ⓝ | Toggle animation |
| <kbd>Space</kbd> <kbd>uA</kbd> | Ⓝ | Toggle tabline |
| <kbd>Space</kbd> <kbd>ub</kbd> | Ⓝ | Toggle background dark/light |
| <kbd>Space</kbd> <kbd>uc</kbd>  | Ⓝ | Toggle conceal level |
| <kbd>Space</kbd> <kbd>uC</kbd>  | Ⓝ | Colorschemes |
| <kbd>Space</kbd> <kbd>ud</kbd>  | Ⓝ | Toggle buffer diagnostics |
| <kbd>Space</kbd> <kbd>uD</kbd>  | Ⓝ | Toggle text dim |
| <kbd>Space</kbd> <kbd>uf</kbd> | Ⓝ | Toggle format on Save |
| <kbd>Space</kbd> <kbd>uF</kbd> | Ⓝ | Toggle format on Save (Global) |
| <kbd>Space</kbd> <kbd>ug</kbd> | Ⓝ | Toggle indentation lines |
| <kbd>Space</kbd> <kbd>uG</kbd> | Ⓝ | Toggle git signs |
| <kbd>Space</kbd> <kbd>uh</kbd> | Ⓝ | Toggle inlay-hints |
| <kbd>Space</kbd> <kbd>ui</kbd> | Ⓝ | Inspect position |
| <kbd>Space</kbd> <kbd>uI</kbd> | Ⓝ | Inspect tree |
| <kbd>Space</kbd> <kbd>ul</kbd> | Ⓝ | Toggle line numbers |
| <kbd>Space</kbd> <kbd>uL</kbd> | Ⓝ | Toggle relative line numbers |
| <kbd>Space</kbd> <kbd>um</kbd> | Ⓝ | Toggle markdown render |
| <kbd>Space</kbd> <kbd>un</kbd> | Ⓝ | Dismiss all notifications |
| <kbd>Space</kbd> <kbd>up</kbd> | Ⓝ | Disable auto-pairs |
| <kbd>Space</kbd> <kbd>ur</kbd> | Ⓝ | Redraw, clear hlsearch, and diff update |
| <kbd>Space</kbd> <kbd>us</kbd> | Ⓝ | Toggle spell-checker |
| <kbd>Space</kbd> <kbd>uS</kbd> | Ⓝ | Toggle smooth scroll |
| <kbd>Space</kbd> <kbd>uT</kbd> | Ⓝ | Toggle tree-sitter |
| <kbd>Space</kbd> <kbd>uw</kbd> | Ⓝ | Toggle wrap |
| <kbd>Space</kbd> <kbd>uz</kbd> | Ⓝ | Toggle distraction-free zen writing |
| <kbd>Space</kbd> <kbd>uZ</kbd> | Ⓝ | Toggle window zoom |

### Navigation

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>j</kbd> / <kbd>k</kbd> | Ⓝ Ⓥ | Cursor moves through display-lines | <small>`g` `j/k`</small> |
| <kbd>]i</kbd> / <kbd>[i</kbd> | Ⓝ Ⓥ | Jump to scope edges | <small>[folke/snacks.nvim]</small> |
| <kbd>gh</kbd> / <kbd>gl</kbd> | Ⓝ Ⓥ | Easier line-wise movement | <small>`g^` `g$`</small> |
| <kbd>zl</kbd> / <kbd>zh</kbd> | Ⓝ | Scroll horizontally and vertically wider | <small>`z4` `l/h`</small> |
| <kbd>Ctrl</kbd>+<kbd>j</kbd> | Ⓝ | Move to split below | <small>`<C-w>j` or [christoomey/vim-tmux-navigator]</small> |
| <kbd>Ctrl</kbd>+<kbd>k</kbd> | Ⓝ | Move to upper split | <small>`<C-w>k` or [christoomey/vim-tmux-navigator]</small> |
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | Ⓝ | Move to left split | <small>`<C-w>h` or [christoomey/vim-tmux-navigator]</small> |
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | Ⓝ | Move to right split | <small>`<C-w>l` or [christoomey/vim-tmux-navigator]</small> |
| <kbd>Return</kbd> | Ⓝ | Toggle fold under cursor | <small>`za`</small> |
| <kbd>Shift</kbd>+<kbd>Return</kbd> | Ⓝ | Focus the current fold by closing all others | <small>`zMzv`</small> |
| <kbd>Ctrl</kbd>+<kbd>f</kbd> | Ⓒ | Move cursor forwards in command | <kbd>Right</kbd> |
| <kbd>Ctrl</kbd>+<kbd>b</kbd> | Ⓒ | Move cursor backwards in command | <kbd>Left</kbd> |
| <kbd>Ctrl</kbd>+<kbd>h</kbd> | Ⓒ | Move cursor to the beginning in command | <kbd>Home</kbd> |
| <kbd>Ctrl</kbd>+<kbd>l</kbd> | Ⓒ | Move cursor to the end in command | <kbd>End</kbd> |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | Ⓝ | Go to next tab | <small>`:tabnext`</small> |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd><kbd>Tab</kbd> | Ⓝ | Go to previous tab | <small>`:tabprevious`</small> |
| <kbd>Alt</kbd>+<kbd>j</kbd> or <kbd>]</kbd> | Ⓝ | Go to next tab | <small>`:tabnext`</small> |
| <kbd>Alt</kbd>+<kbd>k</kbd> or <kbd>[</kbd> | Ⓝ | Go to previous tab | <small>`:tabprevious`</small> |
| <kbd>Alt</kbd>+<kbd>{</kbd> | Ⓝ | Move tab backward | <small>`:-tabmove`</small> |
| <kbd>Alt</kbd>+<kbd>}</kbd> | Ⓝ | Move tab forward | <small>`:+tabmove`</small> |

### Selection

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Space</kbd>+<kbd>Space</kbd> | Ⓝ Ⓥ | Toggle visual-line mode | <small>`V` / <kbd>Escape</kbd></small> |
| <kbd>vsp</kbd> | Ⓝ | Select last paste | <small>[config/keymaps.lua]</small> |
| <kbd>sg</kbd> | Ⓥ | Replace within selected area | <small>[config/keymaps.lua]</small> |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | Ⓥ | Replace selection with step-by-step confirmation | <small>[config/keymaps.lua]</small> |
| <kbd>></kbd> / <kbd><</kbd> | Ⓥ | Indent and re-select | <small>[config/keymaps.lua]</small> |
| <kbd>Tab</kbd> / <kbd>Shift</kbd>+<kbd>Tab</kbd> | Ⓥ | Indent and re-select | <small>[config/keymaps.lua]</small> |
| <kbd>I</kbd> / <kbd>gI</kbd> / <kbd>A</kbd> | Ⓥ | Force blockwise operation | <small>[config/keymaps.lua]</small> |

### Jump To

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>],</kbd> or <kbd>[,</kbd> | Ⓝ | Next/previous parameter | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small> |
| <kbd>]q</kbd> or <kbd>[q</kbd> | Ⓝ | Next/previous on quick-fix | <small>`:cnext` / `:cprev`</small> |
| <kbd>]a</kbd> or <kbd>[a</kbd> | Ⓝ | Next/previous on location-list | <small>`:lnext` / `:lprev`</small> |
| <kbd>]d</kbd> or <kbd>[d</kbd> | Ⓝ | Next/previous diagnostics | <small>[config/keymaps.lua]</small> |
| <kbd>]e</kbd> or <kbd>[e</kbd> | Ⓝ | Next/previous error | <small>[config/keymaps.lua]</small> |
| <kbd>]w</kbd> or <kbd>[w</kbd> | Ⓝ | Next/previous warning | <small>[config/keymaps.lua]</small> |
| <kbd>]b</kbd> or <kbd>[b</kbd> | Ⓝ | Next/previous buffer | <small>[akinsho/bufferline.nvim]</small> |
| <kbd>]f</kbd> or <kbd>[f</kbd> | Ⓝ | Next/previous function start | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small> |
| <kbd>]F</kbd> or <kbd>[F</kbd> | Ⓝ | Next/previous function end | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small> |
| <kbd>]c</kbd> or <kbd>[c</kbd> | Ⓝ | Next/previous class start | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small> |
| <kbd>]C</kbd> or <kbd>[C</kbd> | Ⓝ | Next/previous class end | <small>[nvim-treesitter/nvim-treesitter-textobjects]</small> |
| <kbd>]g</kbd> or <kbd>[g</kbd> | Ⓝ | Next/previous Git hunk | <small>[lewis6991/gitsigns.nvim]</small> |
| <kbd>]i</kbd> or <kbd>[i</kbd> | Ⓝ | Jump to bottom/top edge of scope | <small>[folke/snacks.nvim]</small> |
| <kbd>]t</kbd> or <kbd>[t</kbd> | Ⓝ | Next/previous TODO | <small>[folke/todo-comments.nvim]</small> |
| <kbd>]z</kbd> or <kbd>[z</kbd> | Ⓝ | Next/previous whitespace error | <small>[config/keymaps.lua]</small> |

### Buffers

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Space</kbd>+<kbd>bd</kbd> | Ⓝ | Delete buffer | <small>[folke/snacks.nvim]</small> |

### Clipboard

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>p</kbd> or <kbd>P</kbd> | Ⓥ | Paste without yank | <small>`:let @+=@0`</small> |
| <kbd>Space</kbd>+<kbd>y</kbd> | Ⓝ | Copy relative file-path to clipboard | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd>+<kbd>Y</kbd> | Ⓝ | Copy absolute file-path to clipboard | <small>[config/keymaps.lua]</small> |

### Auto-Completion

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Enter</kbd> | Ⓘ | Accept completion item | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>y</kbd> | Ⓘ | Select and accept completion item | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>Space</kbd> | Ⓘ | Open completion menu or toggle documentation | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>n</kbd>/<kbd>p</kbd> or <kbd>j</kbd>/<kbd>k</kbd> | Ⓘ | Movement in completion pop-up | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>d</kbd>/<kbd>u</kbd> | Ⓘ | Select next/previous candidate | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>f</kbd>/<kbd>b</kbd> | Ⓘ | Scroll documentation | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>e</kbd> | Ⓘ | Close completion menu | <small>[blink.cmp]</small> |
| <kbd>Tab</kbd> / <kbd>Shift-Tab</kbd> | Ⓘ Ⓢ | Navigate snippet placeholders | <small>[blink.cmp]</small> |
| <kbd>Ctrl</kbd>+<kbd>l</kbd> / <kbd>h</kbd> | Ⓘ Ⓢ | Next/previous snippet placeholder | <small>[blink.cmp]</small> |

### LSP

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>gr</kbd> | Ⓝ | Go to references | <small>[plugin/lspconfig.lua]</small> |
| <kbd>gR</kbd> | Ⓝ | List references with Trouble | <small>[folke/trouble.nvim]</small> |
| <kbd>gd</kbd> | Ⓝ | Go to definition | <small>[plugin/lspconfig.lua]</small> |
| <kbd>gD</kbd> | Ⓝ | Go to declaration | <small>[plugin/lspconfig.lua]</small> |
| <kbd>gI</kbd> | Ⓝ | Go to implementation | <small>[plugin/lspconfig.lua]</small> |
| <kbd>gy</kbd> | Ⓝ | Go to type definition | <small>[plugin/lspconfig.lua]</small> |
| <kbd>K</kbd>  | Ⓝ | Show hover help or collapsed fold | <small>[plugin/lspconfig.lua]</small> |
| <kbd>gK</kbd> | Ⓝ | Show signature help | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>cr</kbd>  | Ⓝ | Rename | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>ce</kbd>  | Ⓝ | Open diagnostics window | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>cs</kbd>  | Ⓝ | Formatter menu selection | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>ca</kbd>  | Ⓝ Ⓥ | Code action (preview with `lsp.actions-preview`) | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>cA</kbd>  | Ⓝ | Source action | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>cli</kbd>  | Ⓝ | LSP incoming calls | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>clo</kbd>  | Ⓝ | LSP outgoing calls | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>ciwa</kbd> | Ⓝ | Add workspace folder | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>ciwr</kbd> | Ⓝ | Remove workspace folder | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Space</kbd> <kbd>ciwl</kbd> | Ⓝ | List workspace folders | <small>[plugin/lspconfig.lua]</small> |

### Diagnostics

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Space</kbd> <kbd>ud</kbd>  | Ⓝ | Toggle diagnostics | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>xt</kbd> | Ⓝ | List TODO with Trouble | <small>[folke/todo-comments.nvim]</small> |
| <kbd>Space</kbd> <kbd>xT</kbd> | Ⓝ | List TODO/FIXME with Trouble | <small>[folke/todo-comments.nvim]</small> |
| <kbd>Space</kbd> <kbd>st</kbd> | Ⓝ | Select TODO with picker | <small>[folke/todo-comments.nvim]</small> |
| <kbd>Space</kbd> <kbd>sT</kbd> | Ⓝ | Select TODO/FIXME with picker | <small>[folke/todo-comments.nvim]</small> |
| <kbd>Space</kbd> <kbd>xx</kbd> | Ⓝ | Toggle Trouble | <small>[folke/trouble.nvim]</small> |
| <kbd>Space</kbd> <kbd>xq</kbd> | Ⓝ | Toggle Quickfix list | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>xl</kbd> | Ⓝ | Toggle Location list | <small>[config/keymaps.lua]</small> |

### Coding

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Ctrl</kbd>+<kbd>q</kbd> | Ⓝ | Start recording macro | <small>`q`</small> |
| <kbd>Space</kbd> <kbd>cf</kbd> | Ⓝ Ⓥ | Format | <small>[util/format.lua]</small> |
| <kbd>Space</kbd> <kbd>cF</kbd> | Ⓝ Ⓥ | Format injected langs | <small>[stevearc/conform.nvim]</small> |
| <kbd>Space</kbd> <kbd>cc</kbd> | Ⓝ Ⓥ | Run codelens | <small>[plugin/lspconfig.lua]</small> |
| <kbd>Shift</kbd>+<kbd>Return</kbd> | Ⓘ | Start new line from any cursor position | <small>`<C-o>o`</small> |
| <kbd>]</kbd> <kbd>Space</kbd> | Ⓝ | Add new line below | <small>`o<Esc>`</small> |
| <kbd>[</kbd> <kbd>Space</kbd> | Ⓝ | Add new line above | <small>`O<Esc>`</small> |
| <kbd>gc</kbd> | Ⓝ Ⓥ | Comment prefix | <small>Neovim's `gc`</small> |
| <kbd>gcc</kbd> | Ⓝ Ⓥ | Toggle comments | <small>Neovim's `gcc`</small> |
| <kbd>Space</kbd>+<kbd>j</kbd> or <kbd>k</kbd> | Ⓝ Ⓥ | Move lines down/up | <small>`:m` … |
| <kbd>Space</kbd>+<kbd>v</kbd> | Ⓝ Ⓥ | Toggle line-wise comments | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd>+<kbd>dd</kbd> | Ⓝ Ⓥ | Duplicate line or selection | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd>+<kbd>cw</kbd> | Ⓝ | Remove all spaces at EOL | <small>[nvim-mini/mini.trailspace]</small> |
| <kbd>Space</kbd>+<kbd>cid</kbd> | Ⓝ | LazyDev info | <small>[folke/lazydev.nvim]</small> |
| <kbd>Space</kbd>+<kbd>cif</kbd> | Ⓝ | Formatter info | <small>[config/keymaps.lua]</small> |
| <kbd>sj</kbd> / <kbd>sk</kbd> | Ⓝ | Join/split arguments | <small>[nvim-mini/mini.splitjoin]</small> |

### Search, Substitute, Diff

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>\*</kbd> / <kbd>#</kbd> | Ⓝ Ⓥ | Search partial words | <small>`g*` / `g#`</small> |
| <kbd>g\*</kbd> / <kbd>g#</kbd> | Ⓝ Ⓥ | Search whole-word forward/backward | <small>`*` / `#`</small> |
| <kbd>Ctrl</kbd>+<kbd>c</kbd> | Ⓝ | Change inner word | <small>`ciw`</small> |
| <kbd>Escape</kbd> | Ⓝ | Clear search highlight | <small>`:nohlsearch`</small> |
| <kbd>Backspace</kbd> | Ⓝ | Match bracket | <small>`%`</small> |
| <kbd>Space</kbd>+<kbd>bf</kbd> | Ⓝ | Diff current windows in tab | <small>`windo diffthis`</small> |
| <kbd>Space</kbd>+<kbd>bF</kbd> | Ⓝ | External diff | <small>`!vim.g.diffprg % #`</small> |

### Command & History

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>g!</kbd> | Ⓝ | Read vim command into buffer | <small>`:put=execute('⌴')`</small> |
| <kbd>Ctrl</kbd>+<kbd>n</kbd> / <kbd>p</kbd> | Ⓒ | Switch history search pairs | <kbd>↓</kbd> / <kbd>↑</kbd> |
| <kbd>↓</kbd> / <kbd>↑</kbd> | Ⓒ | Switch history search pairs | <small>`Ctrl` `n`/`p`</small> |

### File Operations

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Space</kbd>+<kbd>Tab</kbd> <kbd>c</kbd> | Ⓝ | Switch tab to the directory of current buffer | <small>`:tcd %:p:h`</small> |
| <kbd>Space</kbd>+<kbd>w</kbd> or <kbd>M</kbd>+<kbd>s</kbd> | Ⓝ | Write buffer to file | <small>`:write`</small> |
| <kbd>Ctrl</kbd>+<kbd>s</kbd> | Ⓝ Ⓥ Ⓒ | Write buffer to file | <small>`:write`</small> |

### Window Management

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>Space</kbd> <kbd>qq</kbd> | Ⓝ | Quit all and exit | <small>`:quitall`</small> |
| <kbd>s]</kbd> | Ⓝ | Rotate window placement | <small>`C-w` `x`</small> |
| <kbd>sp</kbd> | Ⓝ | Choose a window to edit | <small>[s1n7ax/nvim-window-picker]</small> |
| <kbd>sw</kbd> | Ⓝ | Switch editing window with selected | <small>[s1n7ax/nvim-window-picker]</small> |
| <kbd>sv</kbd> | Ⓝ | Horizontal split | <small>`:split`</small> |
| <kbd>sg</kbd> | Ⓝ | Vertical split | <small>`:vsplit`</small> |
| <kbd>st</kbd> | Ⓝ | Open new tab | <small>`:tabnew`</small> |
| <kbd>so</kbd> | Ⓝ | Close other windows | <small>`:only`</small> |
| <kbd>sb</kbd> | Ⓝ | Previous buffer | <small>`:b#`</small> |
| <kbd>sc</kbd> | Ⓝ | Close current buffer | <small>`:close`</small> |
| <kbd>sd</kbd> | Ⓝ | Delete buffer | <small>`:bdelete`</small> |
| <kbd>sq</kbd> | Ⓝ | Quit window (if last window, quit nvim) | <small>`:quit`</small> |
| <kbd>sx</kbd> | Ⓝ | Delete buffer, leave blank window | <small>`:enew │ bdelete`</small> |
| <kbd>sz</kbd> | Ⓝ | Toggle window zoom | <small>`:vertical resize │ resize`</small> |
| <kbd>sh</kbd> | Ⓝ | Toggle colorscheme background=dark/light | <small>`:set background` … |

### Plugins

| Key   | Mode | Action             | Plugin or Mapping |
| ----- |:----:| ------------------ | ------ |
| <kbd>;</kbd>+<kbd>c</kbd> | Ⓝ | Open context-menu | <small>[config/keymaps.lua]</small> |
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>o</kbd> | Ⓝ | Navigate to previous file on jumplist | <small>[config/keymaps.lua]</small> |
| <kbd>g</kbd><kbd>Ctrl</kbd>+<kbd>i</kbd> | Ⓝ | Navigate to next file on jumplist | <small>[config/keymaps.lua]</small> |
| <kbd>Ctrl</kbd>+<kbd>/</kbd> | Ⓝ | Toggle terminal | <small>[folke/snacks.nvim]</small> |
| <kbd>Space</kbd> <kbd>mx</kbd> | Ⓝ | Toggle extras (`:RafiExtras`) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>o</kbd> | Ⓝ | Namu sidebar (`editor.namu`; `editor.outline`) | <small>[bassamsdata/namu.nvim]</small> |
| <kbd>Space</kbd> <kbd>?</kbd> | Ⓝ | Open the macOS dictionary on current word | <small>`:!open dict://`</small> |
| <kbd>Space</kbd> <kbd>cp</kbd> | Ⓝ | Toggle Markdown preview (`lang.markdown` extra) | <small>[selimacerbas/mdkite.nvim]</small> |
| <kbd>Space</kbd> <kbd>ft</kbd> | Ⓝ | Open terminal (root dir) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>fT</kbd> | Ⓝ | Open terminal (cwd) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gt</kbd> | Ⓝ | Open Lazygit (root dir) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gT</kbd> | Ⓝ | Open Lazygit (cwd) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gf</kbd> | Ⓝ | Current file git history | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gl</kbd> | Ⓝ | Git log (root dir) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gL</kbd> | Ⓝ | Git log (cwd) | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gb</kbd> | Ⓝ | Git blame line | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gm</kbd> | Ⓝ | Reveal commit under cursor | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>go</kbd> | Ⓝ Ⓥ | Open source-code URL in browser | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>gY</kbd> | Ⓝ Ⓥ | Copy source-code URL | <small>[config/keymaps.lua]</small> |
| <kbd>Space</kbd> <kbd>ml</kbd> | Ⓝ | Append modeline to end of buffer | <small>[config/keymaps.lua]</small> |

#### Plugin: Mini.Surround

See [nvim-mini/mini.surround] for more mappings and usage information.

| Key            | Mode  | Action                       |
| -------------- |:-----:| ---------------------------- |
| <kbd>sa</kbd> & movement  | Ⓝ Ⓥ | Add surrounding |
| <kbd>cs</kbd> & movement  | Ⓝ   | Replace surrounding |
| <kbd>ds</kbd> & movement  | Ⓝ   | Delete surrounding |
| <kbd>gzf</kbd> & movement | Ⓝ   | Find surrounding (to the right) |
| <kbd>gzF</kbd> & movement | Ⓝ   | Find surrounding (to the left) |
| <kbd>gzh</kbd> & movement | Ⓝ   | Highlight surrounding |
| <kbd>gzn</kbd> & movement | Ⓝ   | Update neighbor lines |

#### Plugin: Gitsigns

See [lewis6991/gitsigns.nvim] for more mappings and usage information.

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>]g</kbd> or <kbd>]g</kbd> | Ⓝ | Next/previous Git hunk |
| <kbd>gs</kbd>                  | Ⓝ | Preview hunk |
| <kbd>Space</kbd> <kbd>hp</kbd> | Ⓝ | Preview hunk inline |
| <kbd>Space</kbd> <kbd>hb</kbd> | Ⓝ | Blame line |
| <kbd>Space</kbd> <kbd>hs</kbd> | Ⓝ Ⓥ | Stage hunk |
| <kbd>Space</kbd> <kbd>hr</kbd> | Ⓝ Ⓥ | Reset hunk |
| <kbd>Space</kbd> <kbd>hu</kbd> | Ⓝ | Undo stage hunk |
| <kbd>Space</kbd> <kbd>hS</kbd> | Ⓝ | Stage buffer |
| <kbd>Space</kbd> <kbd>hR</kbd> | Ⓝ | Reset buffer |
| <kbd>Space</kbd> <kbd>hd</kbd> | Ⓝ | Diff against the index |
| <kbd>Space</kbd> <kbd>hD</kbd> | Ⓝ | Diff against the last commit |
| <kbd>Space</kbd> <kbd>hw</kbd> | Ⓝ | Toggle word diff |
| <kbd>Space</kbd> <kbd>hl</kbd> | Ⓝ | Publish hunks to location-list |
| <kbd>Space</kbd> <kbd>htb</kbd> | Ⓝ | Toggle git current line blame |
| <kbd>Space</kbd> <kbd>htd</kbd> | Ⓝ | Toggle git deleted |
| <kbd>Space</kbd> <kbd>htw</kbd> | Ⓝ | Toggle git word diff |
| <kbd>Space</kbd> <kbd>htl</kbd> | Ⓝ | Toggle git line highlight |
| <kbd>Space</kbd> <kbd>htn</kbd> | Ⓝ | Toggle git number highlight |
| <kbd>Space</kbd> <kbd>hts</kbd> | Ⓝ | Toggle git signs |
| <kbd>ih</kbd>                  | Ⓞ | Select inner hunk operator |

#### Plugin: Diffview

See [sindrets/diffview.nvim] for more mappings and usage information.

| Key   | Mode | Action |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd> <kbd>gd</kbd> | Ⓝ | Diff view file history |
| <kbd>Space</kbd> <kbd>gv</kbd> | Ⓝ | Diff view open |
| | | &nbsp; |
| **Within _diffview_ "view" window** | | &nbsp; |
| | | &nbsp; |
| <kbd>Tab</kbd> / <kbd>Shift</kbd>+<kbd>Tab</kbd> | Ⓝ | Select next/previous entry |
| <kbd>;</kbd> <kbd>a</kbd>    | Ⓝ | Focus file |
| <kbd>;</kbd> <kbd>e</kbd>    | Ⓝ | Toggle files panel |
| | | &nbsp; |
| **Within _diffview_ "file" panel** | | &nbsp; |
| | | &nbsp; |
| <kbd>q</kbd>                 | Ⓝ | Close |
| <kbd>h</kbd>                 | Ⓝ | Previous entry |
| <kbd>o</kbd>                 | Ⓝ | Focus entry |
| <kbd>gf</kbd>                | Ⓝ | Open file |
| <kbd>sg</kbd>                | Ⓝ | Open file in split |
| <kbd>st</kbd>                | Ⓝ | Open file in new tab |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> | Ⓝ | Refresh files |
| <kbd>;</kbd> <kbd>e</kbd>    | Ⓝ | Toggle panel |
| | | &nbsp; |
| **Within _diffview_ "history" panel** | | &nbsp; |
| | | &nbsp; |
| <kbd>q</kbd>                 | Ⓝ | Close diffview |
| <kbd>o</kbd>                 | Ⓝ | Focus entry |
| <kbd>O</kbd>                 | Ⓝ | Show options |

### Keys from extras

Available only while the extra is enabled (`:RafiExtras`).

| Key   | Mode | Action             | Extra |
| ----- |:----:| ------------------ | ------ |
| <kbd>ss</kbd> | Ⓝ Ⓥ Ⓞ | Leap jump | <small>`editor.leap` ([andyg/leap.nvim])</small> |
| <kbd>S</kbd> | Ⓝ | Leap to other windows | <small>`editor.leap` ([andyg/leap.nvim])</small> |
| <kbd>f</kbd> / <kbd>F</kbd> / <kbd>t</kbd> / <kbd>T</kbd> | Ⓝ Ⓥ Ⓞ | Enhanced character motions | <small>`editor.leap` ([andyg/leap.nvim])</small> |
| <kbd>Space</kbd> <kbd>cgd</kbd> | Ⓝ | Glance definitions | <small>`editor.glance` ([dnlhc/glance.nvim])</small> |
| <kbd>Space</kbd> <kbd>cgr</kbd> | Ⓝ | Glance references | <small>`editor.glance` ([dnlhc/glance.nvim])</small> |
| <kbd>Space</kbd> <kbd>cgy</kbd> | Ⓝ | Glance type definitions | <small>`editor.glance` ([dnlhc/glance.nvim])</small> |
| <kbd>Space</kbd> <kbd>cgi</kbd> | Ⓝ | Glance implementations | <small>`editor.glance` ([dnlhc/glance.nvim])</small> |
| <kbd>Space</kbd> <kbd>cgu</kbd> | Ⓝ | Glance resume | <small>`editor.glance` ([dnlhc/glance.nvim])</small> |
| <kbd>Space</kbd> <kbd>cn</kbd> | Ⓝ | Generate doc annotations | <small>`coding.neogen` ([danymat/neogen])</small> |
| <kbd>Space</kbd>+<kbd>V</kbd> | Ⓝ Ⓥ | Toggle block-wise comments | <small>`coding.comment` ([numToStr/Comment.nvim])</small> |
| <kbd>Space</kbd> <kbd>gu</kbd> | Ⓝ | Open undo-tree | <small>`editor.undotree` ([mbbill/undotree])</small> |
| <kbd>Space</kbd> <kbd>mg</kbd> | Ⓝ | Open Neogit | <small>`git.neogit` ([NeogitOrg/neogit])</small> |
| <kbd>Space</kbd> <kbd>mc</kbd> | Ⓝ | Open color-picker | <small>`ui.ccc` ([uga-rosa/ccc.nvim])</small> |
| <kbd>Space</kbd> <kbd>mda</kbd> | Ⓥ | Sequentially mark region for diff | <small>`coding.linediff` ([AndrewRadev/linediff.vim])</small> |
| <kbd>Space</kbd> <kbd>mdf</kbd> | Ⓥ | Mark region for diff and compare if more than one | <small>`coding.linediff` ([AndrewRadev/linediff.vim])</small> |
| <kbd>Space</kbd> <kbd>mds</kbd> | Ⓝ | Shows the comparison for all marked regions | <small>`coding.linediff` ([AndrewRadev/linediff.vim])</small> |
| <kbd>Space</kbd> <kbd>mdr</kbd> | Ⓝ | Removes the signs denoting the diff regions | <small>`coding.linediff` ([AndrewRadev/linediff.vim])</small> |
| <kbd>Space</kbd> <kbd>ch</kbd> | Ⓝ | Run HTTP request | <small>`editor.rest` ([rest-nvim/rest.nvim])</small> |
| <kbd>Space</kbd> <kbd>mt</kbd> | Ⓝ Ⓥ | Toggle highlighted word | <small>`editor.quickhl` ([t9md/vim-quickhl])</small> |

#### Plugin: Neo-Tree

See [nvim-neo-tree/neo-tree.nvim] for more mappings and usage information.

| Key   | Mode | Action             |
| ----- |:----:| ------------------ |
| <kbd>Space</kbd> <kbd>e</kbd>/<kbd>fe</kbd> | Ⓝ | Toggle file explorer (root) |
| <kbd>Space</kbd> <kbd>E</kbd>/<kbd>fE</kbd> | Ⓝ | Toggle file explorer (cwd) |
| <kbd>ge</kbd> | Ⓝ | Open Git explorer |
| <kbd>be</kbd> | Ⓝ | Open Buffer explorer |
| <kbd>;a</kbd> | Ⓝ | Reveal in file explorer |
| <kbd>;A</kbd> | Ⓝ | Reveal in file explorer (cwd) |
| | | &nbsp; |
| **Within _Neo-Tree_ window** | | &nbsp; |
| | | &nbsp; |
| <kbd>g?</kbd> | Ⓝ | Show help |
| <kbd>q</kbd> | Ⓝ | Close window |
| <kbd>j</kbd> or <kbd>k</kbd> | Ⓝ | Move up and down the tree |
| <kbd>Tab</kbd> or <kbd>Shift</kbd>+<kbd>Tab</kbd> | Ⓝ | Next or previous source |
| <kbd>]g</kbd> or <kbd>[g</kbd> | Ⓝ | Jump to next/previous git modified node |
| <kbd>l</kbd> | Ⓝ | Toggle collapse/expand directory or open file |
| <kbd>h</kbd> | Ⓝ | Collapse directory tree |
| <kbd>Return</kbd> | Ⓝ | Select window to open file |
| <kbd>gr</kbd> | Ⓝ | Grep in current position |
| <kbd>gf</kbd> | Ⓝ | Find files in current position |
| <kbd>.</kbd> | Ⓝ | Set as root directory |
| <kbd>Backspace</kbd> | Ⓝ | Change into parent directory |
| <kbd>sv</kbd> or <kbd>S</kbd> | Ⓝ | Open file in a horizontal split |
| <kbd>sg</kbd> or <kbd>s</kbd> | Ⓝ | Open file in a vertical split |
| <kbd>st</kbd> or <kbd>t</kbd> | Ⓝ | Open file in new tab |
| <kbd>p</kbd> | Ⓝ | Preview toggle |
| <kbd>a</kbd> | Ⓝ | Create new directories and/or files |
| <kbd>N</kbd> | Ⓝ | Create new directory |
| <kbd>r</kbd> | Ⓝ | Rename file or directory |
| <kbd>dd</kbd> | Ⓝ | Delete |
| <kbd>c</kbd> / <kbd>m</kbd> | Ⓝ | Copy/move |
| <kbd>y</kbd> / <kbd>x</kbd> / <kbd>P</kbd> | Ⓝ | Clipboard copy/cut/paste |
| <kbd>!</kbd> | Ⓝ | Filter |
| <kbd>D</kbd> | Ⓝ | Filter directories |
| <kbd>#</kbd> | Ⓝ | Fuzzy sorter |
| <kbd>F</kbd> | Ⓝ | Filter on submit |
| <kbd>Ctrl</kbd>+<kbd>c</kbd> | Ⓝ | Clear filter |
| <kbd>Ctrl</kbd>+<kbd>r</kbd> or <kbd>R</kbd> | Ⓝ | Refresh |
| <kbd>fi</kbd> / <kbd>fe</kbd> | Ⓝ | Include/exclude |
| <kbd>H</kbd> | Ⓝ | Toggle hidden files |
| <kbd>e</kbd> | Ⓝ | Toggle auto-expand window width |
| <kbd>w</kbd> | Ⓝ | Toggle window width |
| <kbd>z</kbd> | Ⓝ | Collapse all nodes |

#### Plugin: Marks

See [chentoast/marks.nvim] for more mappings and usage information.

| Key   | Mode | Action |
| ----- |:----:| ------------------ |
| <kbd>m,</kbd> | Ⓝ | Set the next available alphabetical (lowercase) mark |
| <kbd>m;</kbd> | Ⓝ | Toggle the next available mark at the current line |
| <kbd>m</kbd> <kbd>a-z</kbd> | Ⓝ | Set mark |
| <kbd>dm</kbd> <kbd>a-z</kbd> | Ⓝ | Remove mark |
| <kbd>dm-</kbd> | Ⓝ | Delete all marks on the current line |
| <kbd>dm\<Space></kbd> | Ⓝ | Delete all marks in the current buffer |
| <kbd>m]</kbd> | Ⓝ | Move to next mark |
| <kbd>m[</kbd> | Ⓝ | Move to previous mark |
| <kbd>m:</kbd> <kbd>a-z</kbd> | Ⓝ | Preview mark |
| <kbd>m/</kbd> | Ⓝ | List marks from all opened buffers |

#### Plugin: Zk

See [zk-org/zk-nvim] and [zk](https://github.com/zk-org/zk) for
more mappings and usage information.

| Key                            | Mode | Action |
| ------------------------------ |:----:| ----------------------------------- |
| <kbd>Space</kbd>+<kbd>zn</kbd> | Ⓝ | Ask for title and create new note |
| <kbd>Space</kbd>+<kbd>zo</kbd> | Ⓝ | Browse notes sorted by modification time |
| <kbd>Space</kbd>+<kbd>zt</kbd> | Ⓝ | Browse tags |
| <kbd>Space</kbd>+<kbd>zf</kbd> | Ⓝ | Search notes |
| <kbd>Space</kbd>+<kbd>zf</kbd> | Ⓥ | Search notes with selection |
| <kbd>Space</kbd>+<kbd>zb</kbd> | Ⓝ | Show backlinks |
| <kbd>Space</kbd>+<kbd>zl</kbd> | Ⓝ | Show links |

</details>

## License

Apache-2.0, see [LICENSE](./LICENSE). Parts are derived from
[LazyVim](https://github.com/LazyVim/LazyVim) and
[lazy.nvim](https://github.com/folke/lazy.nvim), both Apache-2.0, see
[NOTICE](./NOTICE). Files with derived code name their upstream source in a
header comment.

[Neovim]: https://github.com/neovim/neovim
[vim.pack]: https://neovim.io/doc/user/pack.html#vim.pack
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig
[blink.cmp]: https://github.com/saghen/blink.cmp
[config/keymaps.lua]: ./lua/rafi/config/keymaps.lua
[util/format.lua]: ./lua/rafi/util/format.lua
[plugin/lspconfig.lua]: ./plugin/lspconfig.lua
