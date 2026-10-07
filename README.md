# nvim

Personal Neovim config. Works on Arch Linux and Windows.

Stack it is tuned for: Java / Spring Boot, PHP (5.x WAMP, Phalcon), Vue / React / TypeScript,
HTML / CSS, SQL Server, Rust, SQLite.

## Requirements

- Neovim **0.12+**
- git, [ripgrep](https://github.com/BurntSushi/ripgrep), [fd](https://github.com/sharkdp/fd)
- A C compiler + the `tree-sitter` CLI (0.26.1+) to build treesitter parsers.
  Install the CLI with your package manager or cargo, **not npm**.
  Arch: `gcc` + `tree-sitter-cli`. Windows: `zig` + `cargo install --locked tree-sitter-cli`
- Node.js (prettier, Vue/TS servers, PHP + JS debug adapters)
- Java **21+** on PATH (jdtls needs it; your project can still target 8/11/17)
- Rust via `rustup` (`rustup component add rust-analyzer rustfmt clippy`)
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal
- Optional: `lazygit`, `sqlcmd` (SQL Server), `sqlite3`

### Arch

```sh
sudo pacman -S neovim git ripgrep fd gcc tree-sitter-cli nodejs npm jdk21-openjdk rustup lazygit sqlite
```

### Windows

```powershell
winget install Neovim.Neovim Git.Git BurntSushi.ripgrep.MSVC sharkdp.fd zig.zig OpenJS.NodeJS.LTS Microsoft.OpenJDK.21 Rustlang.Rustup JesseDuffield.lazygit
# after rustup is set up:
cargo install --locked tree-sitter-cli
```

## Install

```sh
# Arch
git clone <this repo> ~/.config/nvim

# Windows (PowerShell)
git clone <this repo> $env:LOCALAPPDATA\nvim
```

Open `nvim`. lazy.nvim installs itself, then plugins, then Mason downloads the
language servers and debuggers. Wait for it to finish, restart, run `:checkhealth`.

## Keymaps

Leader is `<space>`. Press it and wait: which-key shows everything.
The most used ones:

| Key | What |
| --- | --- |
| `<space><space>` | find files |
| `<space>/` | grep in project |
| `<space>e` | file explorer |
| `<space>fb`, `S-h` / `S-l` | switch buffers |
| `s` + 2 chars | jump anywhere on screen (flash) |
| `gd` `gr` `gI` | definition / references / implementations |
| `K` | hover docs |
| `<space>ca` `<space>cr` | code action / rename |
| `<space>cf` | format |
| `<space>xx` | diagnostics list |
| `<space>gg` | lazygit |
| `<C-/>` | terminal |
| `<space>u…` | toggles (wrap, inlay hints, format on save…) |

### Debugging

| Key | What |
| --- | --- |
| `<space>db` | toggle breakpoint |
| `F5` / `<space>dc` | start / continue |
| `F10` / `F11` / `S-F11` | step over / into / out |
| `<space>du` | toggle debug UI |
| `<space>de` | evaluate word / selection |
| `<space>dt` | stop |

- **Rust**: just `F5` in a cargo project (rustaceanvim + codelldb).
- **Java**: `F5` lists main classes (Spring Boot app included). `<space>dm` debugs the test under cursor.
- **PHP**: enable Xdebug in WAMP, then `F5` → "Listen for Xdebug…", refresh the page in the browser.
  Xdebug 3 uses port 9003, old Xdebug 2 (PHP 5) uses 9000. Both are configured.
- **JS/TS**: `F5` → launch node on current file, attach to a process, or launch Chrome against a dev server.
- A project `.vscode/launch.json` is picked up automatically.

### Database

`<space>Du` opens the DB UI. Add connections once with `:DBUIAddConnection`, e.g.

```
sqlserver://user:pass@localhost:1433/mydb
sqlite:///home/me/app.db
```

Inside a query buffer `<leader>S` runs the query. Completion is table/column aware.

## Per-project overrides

`exrc` is on, so Neovim reads a `.nvim.lua` in the project root (it asks you to
trust the file the first time). Example to make intelephense use modern PHP on one project:

```lua
-- .nvim.lua
vim.lsp.config("intelephense", {
  settings = { intelephense = { environment = { phpVersion = "8.2.0" } } },
})
```

## Layout

```
init.lua                 entry
lua/config/options.lua   editor options (+ Windows PowerShell setup)
lua/config/keymaps.lua   general keymaps
lua/config/autocmds.lua  autocommands
lua/config/lazy.lua      plugin manager bootstrap
lua/plugins/ui.lua       colorscheme, statusline, which-key, snacks (picker, explorer, dashboard…)
lua/plugins/editor.lua   flash, gitsigns, mini.*, todo-comments, trouble, sessions
lua/plugins/treesitter.lua
lua/plugins/completion.lua  blink.cmp
lua/plugins/lsp.lua      mason + language servers, rust, java plugin
lua/plugins/formatting.lua  conform
lua/plugins/dap.lua      debuggers
lua/plugins/db.lua       dadbod
ftplugin/java.lua        jdtls setup (runs per Java buffer)
```
