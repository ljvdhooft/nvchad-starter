return {
  "nvim-tree/nvim-tree.lua",
  opts = {
    filters = {
      dotfiles = false,
    },
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"
      api.config.mappings.default_on_attach(bufnr)
      vim.keymap.del("n", "<C-k>", { buffer = bufnr })
      vim.keymap.set("n", "<A-k>", api.node.show_info_popup, { buffer = bufnr })
    end,
  },
}
