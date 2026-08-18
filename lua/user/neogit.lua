local M = {}

-- Like require("neogit").action(popup, action, args), but wraps the
-- deferred callback in its own async context. Upstream only wraps the
-- dispatch_refresh call itself, and the action fn actually runs later
-- inside Repo:run_callbacks (outside that async context), which crashes
-- commit/extend/amend etc. with "wrapped function called outside an
-- async context" since they call a.util.scheduler().
function M.action(popup, action, args)
  local util = require("neogit.lib.util")
  local git = require("neogit.lib.git")
  local a = require("neogit.lib.async")

  args = args or {}

  local internal_args = {
    graph = util.remove_item_from_table(args, "--graph"),
    color = util.remove_item_from_table(args, "--color"),
    decorate = util.remove_item_from_table(args, "--decorate"),
  }

  return function()
    local ok, actions = pcall(require, "neogit.popups." .. popup .. ".actions")
    if not ok then
      require("neogit").notification.error("Invalid popup: " .. popup)
      return
    end

    local fn = actions[action]
    if not fn then
      require("neogit").notification.error(
        string.format(
          "Invalid action %s for %s popup\nValid actions are: %s",
          action,
          popup,
          table.concat(vim.tbl_keys(actions), ", ")
        )
      )
      return
    end

    local callback = a.void(function()
      fn {
        close = function() end,
        state = { env = {} },
        get_arguments = function()
          return args
        end,
        get_internal_arguments = function()
          return internal_args
        end,
      }
    end)

    git.repo:dispatch_refresh { source = "action", callback = callback }
  end
end

return M
