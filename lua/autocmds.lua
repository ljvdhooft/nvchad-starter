require "nvchad.autocmds"

local function update_scrolloff()
  local ok, state = pcall(require, "markview.state")
  if not ok then return end
  local source = state.get_splitview_source()
  if source and vim.api.nvim_get_current_buf() == source then
    vim.o.scrolloff = 1000
  else
    vim.o.scrolloff = 1
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = { "MarkviewSplitviewOpen", "MarkviewSplitviewClose" },
  callback = update_scrolloff,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = update_scrolloff,
})
