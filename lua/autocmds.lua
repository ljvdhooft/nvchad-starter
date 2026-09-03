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

-- ---------------------------------------------------------------------------
-- Auto-reload buffers changed on disk (e.g. by Claude Code or a formatter)
--
-- :checktime rechecks *every* loaded buffer, not just the active one, so
-- background splits pick up external edits too. `autoread` then reloads any
-- buffer that has no unsaved local changes; buffers that do have local changes
-- still prompt, which is what we want for a genuine conflict.
-- ---------------------------------------------------------------------------
vim.o.autoread = true

local reload = vim.api.nvim_create_augroup("user_auto_reload", { clear = true })

local function checktime()
  -- Bail out while a prompt/cmdline is open, or in a terminal buffer, where
  -- :checktime is either invalid or would interrupt input.
  if vim.fn.getcmdwintype() ~= "" or vim.fn.mode():match "^[cr!t]" then
    return
  end
  pcall(vim.cmd.checktime)
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = reload,
  callback = checktime,
})

-- CursorHold only fires once per idle period, so it misses changes that land
-- while you sit still in another window. A slow timer covers that gap.
local timer = vim.uv.new_timer()
timer:start(2000, 2000, function()
  vim.schedule(checktime)
end)

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = reload,
  callback = function()
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
  end,
})
