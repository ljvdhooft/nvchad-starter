return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  -- load on startup so the server is running for an external `claude` to connect via /ide
  event = "VeryLazy",
  opts = {
    -- claude runs in a separate tmux pane, not inside nvim
    terminal = { provider = "none" },
  },
  keys = {
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", desc = "Add file", ft = "NvimTree" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
