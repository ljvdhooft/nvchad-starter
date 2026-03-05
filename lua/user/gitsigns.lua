
local M = {}

function M.preview_hunk_window()
  local gs = require("gitsigns")

  -- open preview
  gs.preview_hunk()

  -- schedule buffer-local mappings for the preview window
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end)
end

function M.action_from_preview(gitsigns_func_name)
  local gs = require("gitsigns")
  local cur_buf = vim.api.nvim_get_current_buf()

  -- Close preview window if needed
  if vim.bo[cur_buf].buftype == "nofile" then
    vim.api.nvim_buf_delete(cur_buf, { force = true })
  end

  -- Call the gitsigns function by name
  if gs[gitsigns_func_name] then
    gs[gitsigns_func_name]()
  else
    error("Invalid gitsigns function: " .. tostring(gitsigns_func_name))
  end
end

function M.move_hunk_and_reopen_preview(hunk_direction)
  local buf = vim.api.nvim_get_current_buf()
  local reopen_preview = false

  -- close floating/no-file buffer if needed
  if vim.bo[buf].buftype == "nofile" then
    reopen_preview = true
    vim.api.nvim_buf_delete(buf, { force = true })
  end

  local gs = require("gitsigns")

  if hunk_direction == "next" then
    gs.next_hunk()
  elseif hunk_direction == "prev" then
    gs.prev_hunk()
  else
    error("Invalid hunk_direction: use 'next' or 'prev'")
  end

  if reopen_preview then
    M.preview_hunk_window()
  end
end

return M
