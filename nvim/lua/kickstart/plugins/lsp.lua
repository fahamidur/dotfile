
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright",   -- you already have this
        "clangd"     -- add this for C++
    }
})


local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
    cmd = { "clangd", "--header-insertion=never" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
