local mc = require("multicursor-nvim")

mc.setup()

local set = vim.keymap.set

-- Add cursors above/below the main cursor.
set({ "n", "v" }, "<leader>mk", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
set({ "n", "v" }, "<leader>mj", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })

-- Add or skip cursor by matching word/selection (VSCode Ctrl+D style).
set({ "n", "v" }, "<leader>mn", function() mc.matchAddCursor(1) end, { desc = "Add cursor on next match" })
set({ "n", "v" }, "<leader>mN", function() mc.matchSkipCursor(1) end, { desc = "Skip to next match" })

-- Add all matches in the document.
set({ "n", "v" }, "<leader>mA", function() mc.matchAllAddCursors() end, { desc = "Add cursor on all matches" })

-- Add all matches and immediately start typing at every cursor, like
-- multi-cursor rename: select all occurrences, then `i` to edit them at once.
set({ "n", "v" }, "<leader>mi", function()
  mc.matchAllAddCursors()
  mc.feedkeys("i")
end, { desc = "Add cursor on all matches and enter insert" })

-- Mouse cursors.
set("n", "<leader><c-LeftMouse>", mc.handleMouse, { desc = "Add cursor at mouse click" })

-- Disable and remove cursors.
set({ "n", "v" }, "<leader>mx", mc.disableCursors, { desc = "Disable cursors" })
set({ "n", "v" }, "<leader>mq", function()
  if mc.hasCursors() then
    mc.clearCursors()
  else
    vim.cmd("noh")
  end
end, { desc = "Clear cursors" })

mc.addKeymapLayer(function(layerSet)
  layerSet({ "n", "v" }, "<leader>mn", function() mc.matchAddCursor(1) end)
  layerSet({ "n", "v" }, "<leader>mN", function() mc.matchSkipCursor(1) end)
  layerSet({ "n", "v" }, "<leader>mq", function()
    if mc.hasCursors() then
      mc.clearCursors()
    else
      vim.cmd("noh")
    end
  end)
end)

-- The extra cursors are highlighted character cells (extmarks), not real
-- terminal cursors, so they can't be a true vertical bar. An underline is
-- the closest "line" look achievable, colored from the active theme so it
-- adapts across colorschemes.
local function fg(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false }).fg
end

local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { underline = true, sp = fg("Function"), bold = true })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorMatchPreview", { link = "Search" })
hl(0, "MultiCursorDisabledCursor", { underline = true, sp = fg("Comment") })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
