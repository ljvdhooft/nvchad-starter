-- TypeScript / Svelte IDE plugins
--
-- typescript-tools drives tsserver from the project's own `node_modules/typescript`
-- when present, and otherwise falls back to the copy Mason ships with
-- typescript-language-server (hence that package in mason's ensure_installed).
return {
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "svelte" },
    init = function()
      -- typescript-tools locates its Mason fallback through $MASON
      vim.env.MASON = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
    end,
    opts = {
      on_attach = function(_, bufnr)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end
        map("<leader>to", "<cmd>TSToolsOrganizeImports<cr>", "TS organize imports")
        map("<leader>ta", "<cmd>TSToolsAddMissingImports<cr>", "TS add missing imports")
        map("<leader>tu", "<cmd>TSToolsRemoveUnusedImports<cr>", "TS remove unused imports")
        map("<leader>tf", "<cmd>TSToolsFixAll<cr>", "TS fix all")
        map("<leader>td", "<cmd>TSToolsGoToSourceDefinition<cr>", "TS go to source definition")
        map("<leader>tr", "<cmd>TSToolsRenameFile<cr>", "TS rename file")
      end,
      settings = {
        -- Lets tsserver understand imports coming from .svelte files.
        -- Requires `typescript-svelte-plugin` resolvable from the project
        -- (`npm i -D typescript-svelte-plugin`) — SvelteKit templates ship it.
        tsserver_plugins = { "typescript-svelte-plugin" },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "literals",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeCompletionsForModuleExports = true,
        },
        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused_imports" },
        complete_function_calls = false,
      },
    },
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "svelte" },
    opts = {},
  },

  {
    -- Update imports automatically when renaming/moving files in nvim-tree
    "antosha417/nvim-lsp-file-operations",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-tree.lua" },
    event = "LspAttach",
    opts = {},
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html", "xml", "svelte", "vue", "markdown",
      "javascript", "javascriptreact", "typescript", "typescriptreact",
    },
    opts = {},
  },

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (outline)" },
      { "<leader>xr", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
    },
  },

  {
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "html", "svelte", "vue", "css",
      "javascript", "javascriptreact", "typescript", "typescriptreact",
    },
    build = ":UpdateRemotePlugins",
    opts = {
      -- tailwindcss is started from configs/lspconfig.lua; letting tailwind-tools
      -- set it up too would go through the deprecated lspconfig framework.
      server = { override = false },
      document_color = { enabled = true, kind = "inline" },
      conceal = { enabled = false },
    },
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    event = { "BufRead package.json" },
    opts = { hide_up_to_date = true },
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = { vt_position = "end_of_line" },
  },

  {
    -- LSP for editing this Neovim config itself
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
    },
  },
}
