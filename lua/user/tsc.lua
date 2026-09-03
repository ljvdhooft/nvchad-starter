-- :TSC — run the project's `tsc --noEmit` and load the results into quickfix.
--
-- tsserver (and therefore typescript-tools) only reports diagnostics for files
-- that are open in a buffer, so a type error in a file you have not visited is
-- invisible until CI. This runs the real compiler over the whole project.

local M = {}

-- tsc prints paths relative to the directory holding the tsconfig, so we need
-- that directory both as the cwd for the job and to absolutise the results.
local function project_root(bufnr)
  local start = vim.api.nvim_buf_get_name(bufnr)
  start = start ~= "" and vim.fs.dirname(start) or vim.uv.cwd()
  local found = vim.fs.find("tsconfig.json", { upward = true, path = start })[1]
  return found and vim.fs.dirname(found) or nil
end

-- Prefer the project's own compiler; fall back to whatever is on $PATH.
local function tsc_cmd(root)
  local local_bin = root .. "/node_modules/.bin/tsc"
  if vim.uv.fs_stat(local_bin) then
    return { local_bin }
  end
  if vim.fn.executable "tsc" == 1 then
    return { "tsc" }
  end
  return nil
end

local errorformat = table.concat({
  "%f(%l\\,%c): error TS%n: %m",
  "%f(%l\\,%c): warning TS%n: %m",
}, ",")

local running = false

function M.run()
  if running then
    vim.notify("tsc is already running", vim.log.levels.WARN)
    return
  end

  local root = project_root(0)
  if not root then
    vim.notify("No tsconfig.json found above this buffer", vim.log.levels.ERROR)
    return
  end

  local cmd = tsc_cmd(root)
  if not cmd then
    vim.notify("No tsc found (install typescript in the project)", vim.log.levels.ERROR)
    return
  end

  vim.list_extend(cmd, { "--noEmit", "--pretty", "false" })

  running = true
  vim.notify("tsc: typechecking " .. vim.fs.basename(root) .. "…")

  vim.system(cmd, { cwd = root, text = true }, function(res)
    running = false
    vim.schedule(function()
      local lines = vim.split((res.stdout or "") .. (res.stderr or ""), "\n", { trimempty = true })

      -- Rewrite the leading relative path to an absolute one so quickfix
      -- resolves entries regardless of Neovim's cwd.
      for i, line in ipairs(lines) do
        lines[i] = line:gsub("^([^%s(][^(]*)%(", root .. "/%1(", 1)
      end

      local items = vim.fn.getqflist { lines = lines, efm = errorformat }.items
      vim.fn.setqflist({}, " ", { title = "tsc --noEmit", items = items })

      if #items == 0 then
        vim.notify("tsc: no errors", vim.log.levels.INFO)
        -- Close a stale results window rather than leaving old errors on screen.
        pcall(vim.cmd, "cclose")
        return
      end

      vim.notify(("tsc: %d error(s)"):format(#items), vim.log.levels.ERROR)
      -- Trouble renders the list better than the built-in window when present,
      -- but fall back to :copen rather than losing the list if it fails.
      if not (pcall(require, "trouble") and pcall(vim.cmd, "Trouble qflist open")) then
        pcall(vim.cmd, "copen")
      end
    end)
  end)
end

vim.api.nvim_create_user_command("TSC", M.run, { desc = "tsc --noEmit into quickfix" })
vim.keymap.set("n", "<leader>tc", M.run, { desc = "TS typecheck project" })

return M
