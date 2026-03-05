require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.number = true
o.relativenumber = true
o.diffopt = "internal,filler,closeoff"
o.foldmethod = "expr"
o.foldlevel = 99
o.foldcolumn = "1"
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.cmd([[highlight FoldedBg guibg=#2E2E2E guifg=NONE]])

o.foldtext = [[substitute(getline(v:foldstart), '\t', '  ', 'g')]]

