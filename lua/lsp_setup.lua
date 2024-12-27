local cmp = require'cmp'
local cmp_nvim_lsp = require'cmp_nvim_lsp'
local util = require('lspconfig/util')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<c-d>'] = cmp.mapping.scroll_docs(-4),
        ['<c-f>'] = cmp.mapping.scroll_docs(4),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<c-e>'] = cmp.mapping.close(),
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'buffer' },
    }),
})

-- enhance lsp client capabilities with `cmp_nvim_lsp`
local capabilities = cmp_nvim_lsp.default_capabilities()

-- common on_attach function to set up buffer-local key mappings
local function on_attach(_, bufnr)
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)  -- Go to definition
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)       -- Show hover
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)  -- Go to implementation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)  -- Rename
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)  -- Code action
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)  -- Find references
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)  -- Format
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)  -- Go to type definition
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)  -- Signature help
end

-- lsp server configurations
-- `sourcekit` (swift)
require'lspconfig'.sourcekit.setup{
    cmd = { "/usr/bin/sourcekit-lsp" },
    -- cmd = { "/library/developer/commandlinetools/usr/bin/sourcekit-lsp" },
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
    on_attach = on_attach,
}

require('lspconfig').clangd.setup{
    init_options = {
        fallbackFlags = {'--std=c++20'}
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true
                }
            }
        },
        offsetEncoding = { "utf-16" }
    },
    on_attach = on_attach,
}

require('lspconfig').pyright.setup{
    on_attach = on_attach,
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace"
            }
        }
    }
}

-- typescript-language-server
require('lspconfig').ts_ls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" }
}

-- gopls (Go)
require('lspconfig').gopls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {"gopls"},
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
}

