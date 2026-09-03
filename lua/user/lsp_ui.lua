-- Hover window ergonomics.
--
-- The float that `K` opens is already focusable, and Neovim maps `q` inside it
-- to close it — but only once your cursor is actually in the window. Plain `K`
-- leaves the cursor in the buffer, where `q` still means "record macro", so the
-- float feels unclosable. Pressing `K` a second time focuses it (the request
-- carries a focus_id, so the second call reuses the open window instead of
-- making a new one), and from there `q` works.
--
-- NvChad maps `K` buffer-locally in its own LspAttach handler, so overriding it
-- has to happen in a later LspAttach — a global mapping would just be shadowed.

-- Telescope's preview pane hides line numbers by default.
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("user_telescope_preview_numbers", { clear = true }),
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.number = true
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_ui", { clear = true }),
  callback = function(args)
    vim.keymap.set("n", "K", function()
      -- Long TypeScript signatures otherwise produce a float as wide as the
      -- screen and taller than the window.
      vim.lsp.buf.hover { max_width = 90, max_height = 25 }
    end, { buffer = args.buf, desc = "LSP hover (press again to focus, then q)" })

    -- Route reference/definition/etc lookups through Telescope so results show
    -- in a floating picker with preview instead of the quickfix list at the
    -- bottom of the screen. Not every server supports every method (e.g.
    -- terraform-ls has no textDocument/implementation), so check capability
    -- before calling Telescope — otherwise it errors instead of falling back.
    local builtin = require "telescope.builtin"
    local opts = { buffer = args.buf }

    local function on_supported(method, telescope_fn, buf_fn)
      return function()
        local clients = vim.lsp.get_clients { bufnr = args.buf, method = method }
        if #clients > 0 then
          telescope_fn()
        else
          buf_fn()
        end
      end
    end

    vim.keymap.set(
      "n",
      "gr",
      on_supported("textDocument/references", builtin.lsp_references, vim.lsp.buf.references),
      vim.tbl_extend("force", opts, { desc = "LSP references" })
    )
    vim.keymap.set(
      "n",
      "gd",
      on_supported("textDocument/definition", builtin.lsp_definitions, vim.lsp.buf.definition),
      vim.tbl_extend("force", opts, { desc = "LSP definitions" })
    )
    vim.keymap.set(
      "n",
      "gi",
      on_supported("textDocument/implementation", builtin.lsp_implementations, vim.lsp.buf.implementation),
      vim.tbl_extend("force", opts, { desc = "LSP implementations" })
    )
    vim.keymap.set(
      "n",
      "<leader>fs",
      on_supported("textDocument/documentSymbol", builtin.lsp_document_symbols, vim.lsp.buf.document_symbol),
      vim.tbl_extend("force", opts, { desc = "Document symbols" })
    )
    vim.keymap.set(
      "n",
      "<leader>ws",
      on_supported("workspace/symbol", builtin.lsp_dynamic_workspace_symbols, vim.lsp.buf.workspace_symbol),
      vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
    )
  end,
})

-- Restore NvChad's default <leader>ds (diagnostic loclist), which the
-- document-symbols binding above used to shadow, but route it through
-- Telescope's diagnostics picker instead — floating, filterable, with preview.
vim.keymap.set("n", "<leader>ds", function()
  require("telescope.builtin").diagnostics { bufnr = 0 }
end, { desc = "Buffer diagnostics" })
vim.keymap.set("n", "<leader>wd", function()
  require("telescope.builtin").diagnostics {}
end, { desc = "Workspace diagnostics" })
