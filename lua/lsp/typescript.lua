local lspconfig = require('lspconfig')
local shared = require('lsp.shared')

lspconfig.ts_ls.setup{
    on_attach = shared.on_attach,
    capabilities = shared.capabilities,
    filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx"
    }
}

-- ESLint setup for better JavaScript linting
lspconfig.eslint.setup{
  on_attach = shared.on_attach,
  capabilities = shared.capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    }
  }
}
