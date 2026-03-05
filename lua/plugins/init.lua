return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright"
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
    opts = {
      -- Add or override specific server setups
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic", -- or "strict"
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    branch = 'master',
    opts = {
      filters = {
        dotfiles = false, -- ✅ Show dotfiles
        custom = {'.DS_Store'}
      },
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "szw/vim-maximizer",
    cmd = { "MaximizerToggle", },
    keys = {
      { "<leader>z", "<cmd>MaximizerToggle<cr>", desc = "Toggle window maximizer" }
    },
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css"
  		},
      highlight = { enable = true },
      indent = { enable = true },
  	},
  },
  {
    "luukvbaal/statuscol.nvim", lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        segments = {
          -- { text = { "%s" }, click = "v:lua.ScSa" },
          {
            sign = {
              namespace = { "gitsigns" },
              maxwidth = 1,
            },
            click = "v:lua.ScSa",
          },
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
          {
            text = { " ", builtin.foldfunc, " " },
            condition = { builtin.not_empty, true, builtin.not_empty },
            click = "v:lua.ScFa"
          },
          { text = { "┃" },
        },
        }
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      preview_config = {
        focusable = true,
        border = "rounded",
      },
    },
    keys = {
      {
        "<leader>gp",
        function()
          require("user.gitsigns").preview_hunk_window()
        end,
        desc = "Preview git hunk (interactive)",
      },
      { "<leader>gs", function() require("user.gitsigns").action_from_preview("stage_hunk") end, desc = "Git stage hunk" },
      { "<leader>gr", function() require("user.gitsigns").action_from_preview("reset_hunk") end, desc = "Git reset hunk" },
      {
        "<leader>gN",
        function()
          require("user.gitsigns").move_hunk_and_reopen_preview("prev")
        end,
        desc = "Next git hunk",
      },
      {
        "<leader>gn",
        function()
          require("user.gitsigns").move_hunk_and_reopen_preview("next")
        end,
        desc = "Next git hunk",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diff (Repo)" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",

    keys = {
      { "<leader>ms", "<cmd>Markview splitToggle<CR>", desc = "Toggle Markview Split", ft = "markdown", },
      { "<leader>mt", "<cmd>Markview Toggle<CR>", desc = "Toggle Markview", ft = "markdown", },
    },
  },
}
