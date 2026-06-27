# Keymaps Reference & Learning Path

Leader = `<Space>`. Modes: **n** normal · **i** insert · **v/x** visual · **o** operator-pending · **t** terminal · **c** command-line · **s** select.

Four layers, roughly easiest → deepest:
1. [Core Vim motions & operators](#1-core-vim-motions--operators) — learn first, used constantly
2. [Native command families](#2-native-command-families-g-z-brackets-) (`g`, `z`, `[`/`]`, windows, registers…)
3. [Neovim 0.11 built-in defaults](#3-neovim-011-built-in-default-mappings) (LSP, diagnostics, comments)
4. [NvChad + your config](#4-nvchad--your-config) and [buffer-local plugin maps](#5-buffer-local-plugin-maps)

---

## 1. Core Vim motions & operators

### Motions (move the cursor)
| Key | Description |
|-----|-------------|
| `h j k l` | left / down / up / right |
| `0` / `^` / `$` | start / first non-blank / end of line |
| `w` / `W` | next word / WORD (WORD = whitespace-delimited) |
| `b` / `B` | back word / WORD |
| `e` / `E` / `ge` / `gE` | end of word forward / backward |
| `f{c}` / `F{c}` | jump to next / prev char `{c}` on line |
| `t{c}` / `T{c}` | jump till before next / prev char `{c}` |
| `;` / `,` | repeat last `f/t/F/T` forward / backward |
| `{` / `}` | prev / next paragraph |
| `(` / `)` | prev / next sentence |
| `%` | jump to matching pair `()[]{}`...|
| `gg` / `G` | top / bottom of file |
| `H` / `M` / `L` | top / middle / bottom of screen |
| `gj` / `gk` | down / up by *screen* line (wrapped) |

### Search
| Key | Description |
|-----|-------------|
| `/` / `?` | search forward / backward |
| `n` / `N` | next / prev match (same / opposite dir) |
| `*` / `#` | search word under cursor forward / backward |
| `g*` / `g#` | same but partial (no word boundary) |

### Operators (combine with a motion or text object)
| Key | Description |
|-----|-------------|
| `d` / `c` / `y` | delete / change / yank |
| `>` / `<` / `=` | indent / dedent / auto-indent |
| `gu` / `gU` / `g~` | lowercase / uppercase / toggle case |
| `gq` / `gw` | format to textwidth (gw keeps cursor) |
| `g?` | rot13 encode |
| `!` | filter through external command |
| `g@` | call `operatorfunc` (plugin operators) |

### Text objects (use after an operator, or in visual; `i`=inner, `a`=around)
| Object | Description |
|--------|-------------|
| `iw` `aw` / `iW` `aW` | word / WORD |
| `is` `as` | sentence |
| `ip` `ap` | paragraph |
| `i(` `i{` `i[` `i<` (`b`/`B`) | inside bracket pairs |
| `i"` `i'` `` i` `` | inside quotes |
| `it` `at` | (X)HTML tag |
| `in` `an` | treesitter node (Neovim) |

### Quick edits (standalone)
| Key | Description |
|-----|-------------|
| `i I a A` | insert before / line start / after / line end |
| `o` / `O` | open line below / above |
| `x` / `X` | delete char under / before cursor |
| `r` / `R` | replace one char / replace mode |
| `s` / `S` | substitute char / line |
| `~` | toggle case of char |
| `J` / `gJ` | join line below (with / without space) |
| `p` / `P` | paste after / before |
| `gp` / `gP` | paste and leave cursor after text |
| `u` / `<C-r>` | undo / redo |
| `.` | repeat last change |
| `Y` `D` `C` | yank/delete/change to end of line |
| `<C-a>` / `<C-x>` | increment / decrement number |

### Visual mode
| Key | Description |
|-----|-------------|
| `v` / `V` / `<C-v>` | char / line / block visual |
| `gv` | reselect last visual selection |
| `o` / `O` | move to other end / other corner |
| `I` / `A` (block) | insert / append on every line |

### Scroll
| Key | Description |
|-----|-------------|
| `<C-d>` / `<C-u>` | half page down / up |
| `<C-f>` / `<C-b>` | full page forward / back |
| `<C-e>` / `<C-y>` | scroll one line down / up |
| `zz` / `zt` / `zb` | cursor line to center / top / bottom |

---

## 2. Native command families (g, z, brackets, …)

### `g` family
| Key | Description |
|-----|-------------|
| `g~` `gu` `gU` | toggle / lower / upper case (operator) |
| `g~~` `guu` `gUU` | …whole line |
| `gq` `gw` | format (operator) |
| `g?` | rot13 (operator) |
| `gg` `G` | top / bottom of file |
| `g_` | last non-blank char of line |
| `g0` `g^` `g$` | start / first / end of screen line |
| `gj` `gk` `gm` | down / up / middle by screen line |
| `ge` `gE` | end of previous word |
| `gi` | insert at last insert position |
| `gv` | reselect last visual |
| `gp` `gP` | paste, cursor after |
| `gJ` | join without inserting space |
| `gf` `gF` | open file under cursor (+ line nr) |
| `g;` `g,` | older / newer change position |
| `g*` `g#` | search word partial fwd / back |
| `ga` `g8` | show char code / utf-8 bytes |
| `gd` `gD` | go to local / global declaration (native) |
| `g<` | redisplay last command output |
| `g&` | repeat last `:s` on all lines |
| `gI` | insert at column 1 |
| `gn` | select next search match (operator) |
| *plugin/nvim g-maps:* | `gc` comment · `gx` (yours: close tab) · `gt`/`gT` tabs · `gr*` LSP · `gO` symbols |

### `z` family (folds / scroll / spell)
| Key | Description |
|-----|-------------|
| `zz` `zt` `zb` | center / top / bottom current line |
| `z.` `z<CR>` | center / top + cursor to first non-blank |
| `za` `zA` | toggle fold (A = recursive) |
| `zo` `zO` `zc` `zC` | open / close fold (O/C recursive) |
| `zR` `zM` | open all / close all folds |
| `zr` `zm` | reduce / increase foldlevel |
| `zj` `zk` | next / prev fold |
| `zf` `zd` `zE` | create / delete / eliminate folds |
| `zg` `zw` | mark word good / wrong (spell) |
| `zug` `zuw` | undo spell good / wrong |
| `z=` | spelling suggestions |
| `]s` `[s` | next / prev misspelled word |
| `zs` `ze` `zh` `zl` | horizontal scroll |

### `Z` family
| `ZZ` save & quit · `ZQ` quit without saving |

### Bracket families `[` / `]` (prev / next)
| Pair | Description |
|------|-------------|
| `[b` `]b` | previous / next buffer |
| `[B` `]B` | first / last buffer |
| `[a` `]a` | previous / next arg (arglist) |
| `[A` `]A` | first / last arg |
| `[q` `]q` | previous / next quickfix item |
| `[Q` `]Q` | first / last quickfix |
| `[<C-Q>` `]<C-Q>` | quickfix item in prev / next file |
| `[l` `]l` | previous / next location-list item |
| `[L` `]L` | first / last loclist |
| `[<C-L>` `]<C-L>` | loclist item in prev / next file |
| `[t` `]t` | previous / next tag |
| `[T` `]T` | first / last tag |
| `[<C-T>` `]<C-T>` | preview tag prev / next |
| `[d` `]d` | previous / next diagnostic (nvim) |
| `[D` `]D` | first / last diagnostic (nvim) |
| `[<Space>` `]<Space>` | add empty line above / below |
| `[n` `]n` | prev / next treesitter node (visual) |
| `[N` `]N` | prev / next sibling node (visual) |
| `[(` `])` `[{` `]}` | unclosed paren / brace |
| `[[` `]]` `[]` `][` | section / function boundaries |
| `[p` `]p` | paste adjusting indent |
| `[c` `]c` | prev / next diff change (diff mode) |
| `[m` `]m` `[*` `]*` | method / comment boundaries |

### Window family `<C-w>`
| Key | Description |
|-----|-------------|
| `<C-w>s` `<C-w>v` | split horizontal / vertical |
| `<C-w>q` `<C-w>c` | quit / close window |
| `<C-w>o` | close all other windows |
| `<C-w>=` | equalize sizes |
| `<C-w>h/j/k/l` | move to window left/down/up/right |
| `<C-w>H/J/K/L` | relocate window to edge |
| `<C-w>r` `<C-w>R` | rotate windows |
| `<C-w>x` | swap with next window |
| `<C-w>w` `<C-w>p` | cycle / previous window |
| `<C-w>+ - < >` | resize height / width |
| `<C-w>_` `<C-w>\|` | maximize height / width |
| `<C-w>T` | move window to new tab |
| `<C-w>d` | show diagnostics (nvim) |

### Registers, marks, macros, jumps
| Key | Description |
|-----|-------------|
| `"{reg}` | use register `{reg}` for next y/d/p (e.g. `"ay`, `"+p`) |
| `m{a-zA-Z}` | set mark |
| `` `{mark} `` / `'{mark}` | jump to mark (exact / line) |
| `` `` `` / `''` | jump back to position before last jump |
| `` `. `` / `'.` | jump to last change |
| `` `^ `` | jump to last insert |
| `q{reg}` | record macro into register |
| `q` (while recording) | stop recording |
| `@{reg}` / `@@` | play macro / repeat last |
| `@:` | repeat last `:` command |
| `<C-o>` / `<C-i>` | jumplist back / forward |
| `<C-t>` | tag stack back |
| `<C-^>` | switch to alternate buffer |
| `q:` `q/` `q?` | open command / search history window |
| `&` / `g&` | repeat last `:s` on line / all lines |

---

## 3. Neovim 0.11 built-in default mappings

### LSP
| Key | Description |
|-----|-------------|
| `K` | hover documentation |
| `grn` | rename symbol |
| `gra` | code action (n,x) |
| `grr` | references |
| `gri` | implementation |
| `grt` | type definition |
| `grx` | run code lens |
| `gO` | document symbols |
| `<C-s>` (i,s) | signature help |

### Diagnostics
| Key | Description |
|-----|-------------|
| `]d` / `[d` | next / prev diagnostic |
| `]D` / `[D` | last / first diagnostic |
| `<C-w>d` | show diagnostic float under cursor |

### Comments (native, Neovim 0.10+)
| Key | Description |
|-----|-------------|
| `gcc` | toggle comment on line |
| `gc{motion}` | toggle comment over motion (operator) |
| `gc` (visual) | toggle comment on selection |

### Other defaults
| Key | Description |
|-----|-------------|
| `gx` | open URL/file under cursor (⚠ you remapped → close tab) |
| `<Tab>`/`<S-Tab>` (i,s) | jump to next/prev snippet placeholder |
| `Y` | yank to end of line (`y$`) |
| `&` | repeat last substitute |

---

## 4. NvChad + your config

### Your custom maps (lua/mappings.lua, lua/plugins)
| Key | Mode | Description |
|-----|------|-------------|
| `jk` | i | escape |
| `<C-h/j/k/l>` | n | tmux/vim navigation L/D/U/R |
| `<C-\>` | n | tmux previous pane |
| `gc` | n | new tab |
| `gx` | n | close tab |
| `g<A-h>` `g<A-l>` | n | move tab left / right |
| `<A-h>` `<A-l>` | n | move buffer left / right |
| `d dd D / c cc C / x` | n,v | delete/change to black hole (no clipboard) |
| `<leader>d` `<leader>dd` `<leader>D` | n,v | delete to system clipboard |
| `<leader>z` | n | toggle window maximizer |
| `<A-k>` | n (tree) | NvimTree file info popup |
| `<leader>gp` | n | preview git hunk (interactive) |
| `<leader>gs` `<leader>gr` | n | git stage / reset hunk |
| `<leader>gn` `<leader>gN` | n | next / prev git hunk |
| `<leader>gc` | n | Neogit commit |
| `<leader>gP` | n | git push upstream |
| `<leader>gO` | n | Neogit open |
| `<leader>gd` `<leader>gq` | n | Diffview open / close |
| `<leader>gh` `<leader>gH` | n | Diffview file / repo history |
| `<leader>ms` `<leader>mt` | n | Markview split / toggle |

### NvChad defaults — editor / UI
| Key | Description |
|-----|-------------|
| `<Esc>` | clear search highlight |
| `<C-s>` | save file |
| `<C-c>` | copy whole file to clipboard |
| `<leader>n` `<leader>rn` | toggle line / relative numbers |
| `<leader>ch` | open cheatsheet |
| `<leader>fm` | format file (conform) |
| `<leader>/` | toggle comment (n,v) |
| `<C-n>` `<leader>e` | NvimTree toggle / focus |

### NvChad — insert-mode navigation
| `<C-b>` line start · `<C-e>` line end · `<C-h/l>` left/right · `<C-j/k>` down/up |

### NvChad — buffers / tabs
| `<Tab>`/`<S-Tab>` next/prev buffer · `<leader>b` new buffer · `<leader>x` close buffer |

### NvChad — Telescope
| Key | Description |
|-----|-------------|
| `<leader>ff` `<leader>fa` | find files / all files (hidden+ignored) |
| `<leader>fw` | live grep |
| `<leader>fb` | open buffers |
| `<leader>fo` | recent files |
| `<leader>fz` | fuzzy find in current buffer |
| `<leader>fh` | help tags |
| `<leader>ma` | marks |
| `<leader>cm` | git commits |
| `<leader>gt` | git status |
| `<leader>pt` | pick hidden terminal |
| `<leader>th` | themes |

### NvChad — terminal
| Key | Description |
|-----|-------------|
| `<leader>h` `<leader>v` | new horizontal / vertical term |
| `<A-v>` `<A-i>` | toggle vertical / floating term |
| `<A-h>` | toggle horizontal term ⚠ (overridden by your buffer-move) |
| `<C-x>` (t) | escape terminal mode |

### NvChad — LSP (on attach)
| Key | Description |
|-----|-------------|
| `gd` `gD` | go to definition / declaration |
| `<leader>D` | type definition |
| `<leader>ra` | rename (NvRenamer) |
| `<leader>ds` | diagnostics to loclist |
| `<leader>wa` `<leader>wr` `<leader>wl` | add / remove / list workspace folder |

### NvChad — WhichKey
| `<leader>wK` show all keymaps · `<leader>wk` query a keymap |

---

## 5. Buffer-local plugin maps

Only active inside the relevant window. Press `?` or `g?` there for the live list.

- **NvimTree**: `<CR>`/`o` open · `a` create · `d` delete · `r` rename · `x` cut · `c` copy · `p` paste · `R` refresh · `H` toggle hidden · `?` help · `<A-k>` file info (your map)
- **nvim-cmp** (insert, menu open): `<C-n>`/`<C-p>` next/prev · `<C-Space>` trigger · `<CR>` confirm · `<C-e>` abort · `<C-d>`/`<C-u>` scroll docs
- **Telescope** (insert in picker): `<C-n>`/`<C-p>` or `<C-j>`/`<C-k>` move · `<CR>` open · `<C-x>`/`<C-v>`/`<C-t>` split/vsplit/tab · `<C-q>` send to quickfix · `<C-/>` help · `<Esc>` close
- **Diffview / Neogit / Markview / Gitsigns**: own buffer-local maps — open the buffer and press `g?`/`?`

---

## ⚠ Conflicts in your setup
- `<A-h>` → your **move buffer left** wins over NvChad's **toggle horizontal term**.
- `gx` → your **close tab** overrides Neovim's **open URL under cursor**.
- `gc` → your **new tab** (normal `gc`) coexists with comment `gcc`/`gc{motion}`.
- `gt`/`gd`/`gr*` reused between native, NvChad, and Neovim LSP defaults — last loaded wins.
