local plugins = {}

local function extend_plugins(plugin_files)
  for _, plugin_file in ipairs(plugin_files) do
    local plugin_list = require('plugins.' .. plugin_file)
    for _, plugin in ipairs(plugin_list) do
      table.insert(plugins, plugin)
    end
  end
end

extend_plugins({'ui', 'git', 'ai'})

return require('lazy').setup({
    plugins,
    {
        'neovim/nvim-lspconfig',
    },

    {
        "wojciech-kulik/xcodebuild.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
            "stevearc/oil.nvim",
            'BurntSushi/ripgrep',
        },
        config = function()
            require("xcodebuild").setup({
                build_flags = { "-allowProvisioningUpdates" },
            })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next, -- Move to next item
                            ["<Down>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous, -- Move to previous item
                            ["<Up>"] = actions.move_selection_previous,
                            ['<C-p>'] = require('telescope.actions.layout').toggle_preview
                        },
                    },
                    -- path_display = { 'smart' },
                    vimgrep_arguments = {
                        'rg',
                        '--color=never',
                        '--no-heading',
                        '--with-filename',
                        '--line-number',
                        '--column',
                        '--smart-case',
                    },
                    pickers = {
                        find_files = {
                            hidden = true,
                        },
                    },
                    preview = {
                        hide_on_startup = true -- hide previewer when picker starts
                    }
                },
            })

            -- Keymaps for Telescope built-in functions
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
            vim.keymap.set('n', '<leader>fs', builtin.grep_string, {})
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>ch', builtin.command_history, {})
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup({
                 ensure_installed = {
                     "c",
                     "cpp",
                     "json",
                     "javascript",
                     "typescript",
                     "tsx",
                     "go",
                     "swift",
                     "python",
                     "dockerfile",
                     "yaml",
                     "bash",
                     "markdown",
                     "swift",
                 },
                 highlight = {
                     enable = true,              -- false will disable the whole extension
                     additional_vim_regex_highlighting = false,
                     disable = {}
                 },
                 autotag = {
                     enable = true
                 },
            })
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        git= {
            enable = true,
            ignore = false,
        },
        filters = {
            dotfiles = false,
            custom = { '^.git$' }
        },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 35,
                    side = "left",
                    relativenumber = true,
                },
            })
        end,
    },

    -- nvim-cmp setup
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-buffer",         -- Buffer completions
            "hrsh7th/cmp-path",           -- Path completions
            "hrsh7th/vim-vsnip",          -- Snippet engine, replacing LuaSnip
            "hrsh7th/cmp-vsnip",          -- Snippet completions for vSnip
            "rafamadriz/friendly-snippets", -- Common snippets
            "onsails/lspkind.nvim",       -- Icons
            'hrsh7th/cmp-nvim-lsp',       -- LSP source for nvim-cmp
            'hrsh7th/cmp-cmdline',        -- Commandline completions
        },
        config = function()
            local cmp = require("cmp")
            local lspkind = require("lspkind")

            cmp.setup({
                completion = {
                    completeopt = "menu,menuone,preview,noinsert",
                },
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body) -- Use vSnip for snippet expansion
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
                    ['<c-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<c-f>'] = cmp.mapping.scroll_docs(4),
                    ['<c-space>'] = cmp.mapping.complete(),
                    ['<c-e>'] = cmp.mapping.close(),
                    ['<cr>'] = cmp.mapping.confirm({ select = true }),
                    -- No direct vSnip equivalents for jumpable, fallback to other mappings if needed.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },  -- Using vSnip here
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50, -- customize this value to your liking
                        ellipsis_char = "...", -- customize ellipsis character
                    }),
                },
            })
            vim.g.vsnip_snippet_dir = '~/.config/nvim/snippets' -- Set snippet directory

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    vim.cmd([[syntax spell toplevel]])
                end,
            })

            -- Enable spellcheck for specific filetypes
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "markdown", "gitcommit", "text", "swift", "c", "obj", "python",  "go", "gomod", "gowork", "gotmpl",  "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
                callback = function()
                    vim.opt_local.spell = true
                end,
            })
        end,
    },

    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- This ensures it doesn't interfere with Ctrl+{ in visual mode
                keymaps = {
                    visual = "S",
                    visual_line = "gS",
                }
            })
        end
    },

    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup{
                check_ts = true, -- Enable Tree-sitter integration
                ts_config = {
                    go = { "string", "source" }, -- Specify Go file types to handle strings and source code
                },
                disable_filetype = { "TelescopePrompt", "vim" },
                fast_wrap = {},

            }
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
        end
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            -- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",  -- recommended, use latest release instead of latest commit
        lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        --   "BufReadPre path/to/my-vault/**.md",
        --   "BufNewFile path/to/my-vault/**.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "Obsidian",
                    path = "/Users/jeff/Library/Mobile Documents/iCloud~md~obsidian",
                },
            },

            ui = {
                enable = false,
                --- Obsidian additional syntax features require 'conceallevel' to be set to 1 or 2, but you have 'conceallevel' set to '0'.                                                                                                              --- See https://github.com/epwalsh/obsidian.nvim/issues/286 for more details.
                --- If you don't want Obsidian's additional UI features, you can disable them and suppress this warning by setting 'ui.enable = false' in your Obsidian nvim config
            },
            templates = {
                subdir = "Documents/Templates/",
                date_format = "%Y-%m-%d-%a",
                time_format = "%H:%M",
            },
            daily_notes = {
                -- Optional, if you keep daily notes in a separate directory.
                folder = "Documents/Journal/Daily",
                -- Optional, if you want to change the date format for the ID of daily notes.
                date_format = "%Y-%m-%d",
                -- Optional, if you want to change the date format of the default alias of daily notes.
                alias_format = "%B %-d, %Y",
                -- Optional, default tags to add to each new daily note created.
                default_tags = { "journal" },
                -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
                template = "Daily_Template.md"
            },
        },
    },

    {"mg979/vim-visual-multi"},

    {
        "google/vim-codefmt",
        dependencies = {
            "google/vim-maktaba",
            "mattn/emmet-vim",
        },
        config = function()
            -- Automatically format Swift files on write
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = "*.swift",
                callback = function()
                    vim.cmd("FormatCode")
                end,
            })

            -- Automatically format Swift files on paste
            vim.api.nvim_create_autocmd({ "TextChanged"}, {
                pattern = "*.swift",
                callback = function()
                    vim.cmd("FormatCode")
                end,
            })
            vim.api.nvim_create_augroup("CodeFmtSwift", {})
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "swift",
                command = "AutoFormatBuffer swift-format",
                group = "CodeFmtSwift",
            })
            vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
            vim.api.nvim_create_autocmd("BufWritePre", {
                command = [[%s/\s\+$//e]],
                group = "TrimWhitespace",
            })

            vim.api.nvim_create_augroup("YankHighlight", { clear = true })
            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function()
                    vim.highlight.on_yank({higroup="IncSearch", timeout=150})
                end,
                group = "YankHighlight",
            })

        end,
    },
    {
        'skywind3000/asyncrun.vim',
        config = function()
            -- Optional: Add any configuration for asyncrun.vim here
        end
    },
})

