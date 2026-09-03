local lint = require "lint"

lint.linters_by_ft = {
  terraform = { "tflint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("user_lint", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
