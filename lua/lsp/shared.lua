local M = {}
local cmp_nvim_lsp = require('cmp_nvim_lsp')

M.capabilities = cmp_nvim_lsp.default_capabilities()

-- common on_attach function to set up buffer-local key mappings
M.on_attach = function(_, bufnr)
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

return M
