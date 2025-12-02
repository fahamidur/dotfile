
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.cpp", "*.c", "*.h", "*.hpp" },
  callback = function()
    vim.cmd("silent! !clang-format -i %")
  end,
})
