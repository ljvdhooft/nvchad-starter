local prettier = { "prettierd", "prettier", stop_after_first = true }

-- Prettier can only format .svelte files when the project provides
-- prettier-plugin-svelte. When it doesn't, return no formatter so conform falls
-- back to svelte-language-server instead of erroring out on every save.
local function svelte_formatters(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if dir == "" then
    return {}
  end
  for _, nm in ipairs(vim.fs.find("node_modules", { upward = true, type = "directory", path = dir, limit = math.huge })) do
    if vim.uv.fs_stat(nm .. "/prettier-plugin-svelte") then
      return prettier
    end
  end
  return {}
end

local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    svelte = svelte_formatters,
    typescript = prettier,
    typescriptreact = prettier,
    javascript = prettier,
    javascriptreact = prettier,
    json = prettier,
    jsonc = prettier,
    css = prettier,
    scss = prettier,
    html = prettier,
    yaml = prettier,
    markdown = prettier,
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_format = "fallback",
  },
}

return options
