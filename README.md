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

| Key                                 | What                                                             |
| ----------------------------------- | ---------------------------------------------------------------- |
| `<space><space>`                    | find files                                                       |
| `<space>/`                          | grep in project                                                  |
| `<space>sr` / `<space>sf`           | search & replace in the project / this file (preview first)      |
| `:%s/old/new/g`                     | quick replace in this file (live preview while typing)           |
| `<space>e`                          | file explorer                                                    |
| `<space>fb`                         | pick an open file                                                |
| `s` + 2 chars                       | jump anywhere on screen (flash)                                  |
| visual `J` / `K`                    | move selected lines down / up                                    |
| `gcc` / `gc`                        | toggle line comment (line / visual or motion)                    |
| `gbc` / `gb`                        | toggle block comment (line / visual or motion)                   |
| `<space>m` / `<space>j`             | split/join toggle / join (treesj)                                |
| `gd` `gr` `gI`                      | definition / references / implementations                        |
| `K`                                 | hover docs                                                       |
| `<space>ca` `<space>cr`             | code action / rename                                             |
| `<space>cf`                         | format                                                           |
| `Tab` / `S-Tab`, `Enter`            | completion: move down / up, apply (nothing is selected at first) |
| `<space>y` (+ motion, or in visual) | copy to the system clipboard (`y` alone stays inside Neovim)     |
| `<space>dm` / `<space>dM`           | diagnostics of the line / under the cursor                       |
| `]d` `[d` / `]e` `[e` / `]w` `[w`   | next / prev diagnostic / error / warning (wraps around)          |
| `<space>xx`                         | diagnostics list                                                 |
| `<space>gg`                         | lazygit                                                          |
| `<C-/>`                             | terminal                                                         |
| `<space>u…`                         | toggles (wrap, inlay hints, format on save…)                     |

### Tabs

| Key                                  | What                                       |
| ------------------------------------ | ------------------------------------------ |
| `Alt+.` / `Alt+,` (or `S-l` / `S-h`) | next / prev tab                            |
| `Alt+Right` / `Alt+Left`             | move tab right / left                      |
| `Alt+1`…`Alt+9` / `Alt+0`            | go to tab N / last tab                     |
| `Alt+p`                              | pin / unpin (pinned tabs stay on the left) |
| `Alt+n`                              | new empty tab                              |
| `Alt+x`, middle click                | close tab                                  |
| right click                          | pin / unpin                                |

### Debugging

| Key                     | What                      |
| ----------------------- | ------------------------- |
| `<space>db`             | toggle breakpoint         |
| `F5` / `<space>dc`      | start / continue          |
| `F10` / `F11` / `S-F11` | step over / into / out    |
| `<space>du`             | toggle debug UI           |
| `<space>de`             | evaluate word / selection |
| `<space>dt`             | stop                      |

- **Rust**: just `F5` in a cargo project (rustaceanvim + codelldb).
- **Java**: `F5` lists main classes (Spring Boot app included). `<space>dn` debugs the test under cursor.
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
init.lua                  entry
ftplugin/java.lua         jdtls setup (runs for each Java buffer)
lua/config/               editor basics
  options.lua             options (+ Windows PowerShell setup)
  keymaps.lua             general keymaps
  autocmds.lua            autocommands
  lazy.lua                plugin manager bootstrap
lua/plugins/              one file per plugin: when it loads + its keymaps
lua/setup/                the plugin's settings, when they are longer than ~3 lines
after/lsp/                language server settings, one file per server (Neovim loads them by itself)
```

Rule: short settings stay inline in `lua/plugins/<name>.lua` (`opts = {...}`).
Long ones go to `lua/setup/<name>.lua`, and the plugin file just does
`config = function() require("setup.<name>") end`.

To add a plugin: create `lua/plugins/<name>.lua`. To remove one: delete its file(s).

Language servers: add the name to `ensure_installed` in `lua/setup/lsp.lua`.
If it needs settings, create `after/lsp/<name>.lua` returning a table.
It's in `after/` so your settings override nvim-lspconfig's defaults.

## Completion per file type

| File                                        | Server                                               |
| ------------------------------------------- | ---------------------------------------------------- |
| package.json, tsconfig.json, composer.json… | jsonls + SchemaStore                                 |
| docker-compose.yml, GitHub workflows…       | yamlls + SchemaStore                                 |
| Cargo.toml, other TOML                      | taplo                                                |
| Dockerfile                                  | dockerls                                             |
| application.yml / application.properties    | spring-boot.nvim (Spring Boot server, through jdtls) |
| pom.xml                                     | lemminx                                              |
