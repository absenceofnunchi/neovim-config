local lspconfig = require('lspconfig')
local shared = require('lsp.shared')

lspconfig.ts_ls.setup{
    on_attach = shared.on_attach,
    capabilities = shared.capabilities,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" }
}

