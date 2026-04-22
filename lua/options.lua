require "nvchad.options"

-- add yours here!

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.number = true
o.relativenumber = true
o.diffopt = "internal,filler,closeoff"
o.scrolloff = 1000
o.foldenable = false
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldcolumn = "1"
o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.cmd([[highlight FoldedBg guibg=#2E2E2E guifg=NONE]])

o.foldtext = [[substitute(getline(v:foldstart), '\t', '  ', 'g')]]
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
  pattern = "*",
  callback = function()
    -- We use a small timer to ensure Treesitter has finished 
    -- its first pass before we try to fold.
    vim.defer_fn(function()
      vim.cmd("normal! zx")
    end, 100)
  end,
})
