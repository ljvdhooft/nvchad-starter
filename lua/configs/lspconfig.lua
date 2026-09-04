require("nvchad.configs.lspconfig").defaults()

-- NOTE: ts_ls / vtsls are intentionally NOT enabled here.
-- typescript-tools.nvim (lua/plugins/typescript.lua) drives tsserver instead.
local servers = {
  "html",
  "cssls",
  "svelte",
  "eslint",
  "tailwindcss",
  "emmet_language_server",
  "terraformls",
}

-- Let every server advertise willRename/willDelete so nvim-lsp-file-operations
-- can update imports when files move in nvim-tree.
local ok_fileops, fileops = pcall(require, "lsp-file-operations")
if ok_fileops then
  vim.lsp.config("*", { capabilities = fileops.default_capabilities() })
end

vim.lsp.config("emmet_language_server", {
  filetypes = {
    "html", "css", "scss", "sass", "less",
    "svelte", "vue", "javascriptreact", "typescriptreact",
  },
})

-- Needed for tailwind-tools' inline colour swatches
local tw_caps = vim.lsp.protocol.make_client_capabilities()
tw_caps.textDocument.colorProvider = { dynamicRegistration = true }
vim.lsp.config("tailwindcss", {
  capabilities = tw_caps,
  filetypes = {
    "html", "css", "scss", "sass", "less", "svelte", "vue",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
  },
})

vim.lsp.config("eslint", {
  settings = {
    workingDirectories = { mode = "auto" },
  },
})

-- nvim-lspconfig's terraformls preset turns on vim.lsp.codelens.enable in its
-- own on_attach, which renders lenses as virt_lines above the line. We render
-- them as eol virt_text instead (see below), so undo that here.
vim.lsp.config("terraformls", {
  on_attach = function() end,
})

vim.lsp.enable(servers)

-- terraform-ls can report reference counts (like VSCode's CodeLens). The
-- built-in vim.lsp.codelens.display renders them as virt_lines above the
-- line; we want them at end-of-line instead, so request and render manually.
local terraform_codelens_ns = vim.api.nvim_create_namespace "user_terraform_codelens"

local function show_terraform_codelens(bufnr)
  local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  vim.lsp.buf_request(bufnr, "textDocument/codeLens", params, function(err, result)
    -- The buffer can be closed/wiped between issuing the request and the
    -- response landing (e.g. closing it right after switching away); the
    -- line numbers in `result` would then be stale or out of range.
    if err or not result or not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    vim.api.nvim_buf_clear_namespace(bufnr, terraform_codelens_ns, 0, -1)

    -- terraform-ls can send several lenses for the same line; merge them into
    -- one extmark so they render on a single eol virt_text instead of each
    -- stacking on its own virtual line.
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local titles_by_line = {}
    for _, lens in ipairs(result) do
      if lens.command and lens.command.title ~= "" then
        local line = lens.range.start.line
        if line < line_count then
          titles_by_line[line] = titles_by_line[line] or {}
          table.insert(titles_by_line[line], lens.command.title)
        end
      end
    end

    for line, titles in pairs(titles_by_line) do
      vim.api.nvim_buf_set_extmark(bufnr, terraform_codelens_ns, line, 0, {
        virt_text = { { "  " .. table.concat(titles, ", "), "Comment" } },
        virt_text_pos = "eol",
      })
    end
  end)
end

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("user_terraform_codelens", { clear = true }),
  pattern = "*.tf",
  callback = function(args)
    if #vim.lsp.get_clients { bufnr = args.buf, name = "terraformls" } > 0 then
      show_terraform_codelens(args.buf)
    end
  end,
})

-- Auto-fix ESLint problems on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("user_eslint_fix", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.svelte", "*.mjs", "*.cjs" },
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf, name = "eslint" }
    if #clients > 0 then
      vim.cmd "LspEslintFixAll"
    end
  end,
})

-- svelte-language-server does not watch .ts/.js files itself; tell it when one
-- changes so that types/props used in .svelte files stay up to date.
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("user_svelte_ts_reload", { clear = true }),
  pattern = { "*.js", "*.ts" },
  callback = function(args)
    for _, client in ipairs(vim.lsp.get_clients { name = "svelte" }) do
      client:notify("$/onDidChangeTsOrJsFile", { uri = vim.uri_from_fname(args.match) })
    end
  end,
})

-- read :h vim.lsp.config for changing options of lsp servers
