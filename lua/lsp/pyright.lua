-- local lspconfig = require('lspconfig')
-- local shared = require('lsp.shared')
-- local util = require('lspconfig/util')
--
-- -- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/pyright.lua
-- local root_files = {
--   'pyproject.toml',
--   'setup.py',
--   'setup.cfg',
--   'requirements.txt',
--   'Pipfile',
--   'pyrightconfig.json',
--   '.git',
-- }
--
-- local function organize_imports()
--   local params = {
--     command = 'pyright.organizeimports',
--     arguments = { vim.uri_from_bufnr(0) },
--   }
--
--   local clients = util.get_lsp_clients {
--     bufnr = vim.api.nvim_get_current_buf(),
--     name = 'pyright',
--   }
--   for _, client in ipairs(clients) do
--     client.request('workspace/executeCommand', params, nil, 0)
--   end
-- end
--
-- local function set_python_path(path)
--   local clients = util.get_lsp_clients {
--     bufnr = vim.api.nvim_get_current_buf(),
--     name = 'pyright',
--   }
--   for _, client in ipairs(clients) do
--     if client.settings then
--       client.settings.python = vim.tbl_deep_extend('force', client.settings.python, { pythonPath = path })
--     else
--       client.config.settings = vim.tbl_deep_extend('force', client.config.settings, { python = { pythonPath = path } })
--     end
--     client.notify('workspace/didChangeConfiguration', { settings = nil })
--   end
-- end
--
-- lspconfig.pyright.setup{
--     on_attach = shared.on_attach,
--     capabilities = shared.capabilities,
--     settings = {
--         python = {
--             analysis = {
--                 autoSearchPaths = true,
--                 useLibraryCodeForTypes = true,
--                 diagnosticMode = "workspace"
--             }
--         }
--     },
--     default_config = {
--         cmd = { 'pyright-langserver', '--stdio' },
--         filetypes = { 'python' },
--         root_dir = function(fname)
--             return util.root_pattern(unpack(root_files))(fname)
--         end,
--         single_file_support = true,
--         settings = {
--             python = {
--                 analysis = {
--                     autoSearchPaths = true,
--                     useLibraryCodeForTypes = true,
--                     diagnosticMode = 'openFilesOnly',
--                 },
--             },
--         },
--     },
--     commands = {
--         PyrightOrganizeImports = {
--             organize_imports,
--             description = 'Organize Imports',
--         },
--         PyrightSetPythonPath = {
--             set_python_path,
--             description = 'Reconfigure pyright with the provided python path',
--             nargs = 1,
--             complete = 'file',
--         },
--     },
--     docs = {
--         description = [[
--         https://github.com/microsoft/pyright
--
--         `pyright`, a static type checker and language server for python
--         ]],
--     },
-- }
--

local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Shared capabilities for autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Organize imports command
local function organize_imports()
    local params = {
        command = 'pyright.organizeimports',
        arguments = { vim.uri_from_bufnr(0) },
    }
    local client = vim.lsp.get_active_clients({ name = 'pyright', bufnr = vim.api.nvim_get_current_buf() })[1]
    if client then
        client.request('workspace/executeCommand', params, function(err, _, result)
            if err then
                vim.notify("Error organizing imports: " .. tostring(err), vim.log.levels.ERROR)
            elseif result then
                vim.notify("Imports organized successfully.", vim.log.levels.INFO)
            end
        end)
    else
        vim.notify("Pyright LSP client not found.", vim.log.levels.WARN)
    end
end

-- Infer Python path dynamically (uses virtual environments or system Python)
local function get_python_path(workspace)
    -- Use activated virtualenv
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. '/bin/python'
    end
    -- Search for virtualenv in the workspace
    for _, pattern in ipairs({ 'venv', '.venv' }) do
        local match = util.path.join(workspace, pattern, 'bin', 'python')
        if util.path.exists(match) then
            return match
        end
    end
    -- Fallback to system Python
    return 'python'
end

-- LSP setup for Pyright
lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
        -- Enable keymaps for LSP functionality
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<leader>oi', organize_imports, opts) -- Organize imports
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        -- Notify user if Pyright is attached
        vim.notify("Pyright attached to buffer " .. bufnr, vim.log.levels.INFO)
    end,
    capabilities = capabilities,
    root_dir = function(fname)
        return util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git')(fname)
        or util.path.dirname(fname)
    end,
    settings = {
        python = {
            pythonPath = get_python_path(vim.fn.getcwd()),
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace", -- "workspace" or "openFilesOnly"
                typeCheckingMode = "basic", -- "off", "basic", or "strict"
            },
        },
    },
    commands = {
        PyrightOrganizeImports = {
            organize_imports,
            description = 'Organize Imports',
        },
    },
})
