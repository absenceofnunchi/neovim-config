return require('lazy').setup({
    ui = {
        icons = {
            cmd = "",
            config = "",
            event = "",
            ft = "",
            init = "",
            keys = "",
            plugin = "",
            runtime = "",
            require = "",
            source = "",
            start = "",
            task = "",
            lazy = "",
        },
    },
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
            require('telescope').setup({
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case'
                },
            })

            require('telescope').setup({
                pickers = {
                    find_files = {
                        hidden = true
                    }
                }
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

        end
    },

    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup({
                 ensure_installed = { "c", "cpp" },
                 highlight = {
                     enable = true,              -- false will disable the whole extension
                     additional_vim_regex_highlighting = false,
                 },
            })
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        git = {
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
                    width = 30,
                    side = "left",
                },
            })
            vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>")
        end,
    },

    {
        "kyazdani42/nvim-web-devicons",
        config = function()
            require('lazy').setup({
                {'glepnir/nerdicons.nvim', cmd = 'NerdIcons', config = function() require('nerdicons').setup({}) end}
            })
            require("nvim-web-devicons").setup()
        end
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
                    completeopt = "menu,menuone,noinsert",
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
        end,
    },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     version = false,
    --     event = "InsertEnter",
    --     dependencies = {
    --         "hrsh7th/cmp-nvim-lsp",
    --         "hrsh7th/cmp-path",
    --         "hrsh7th/cmp-buffer",
    --     },
    --     config = function()
    --         local cmp = require('cmp')
    --         local luasnip = require('luasnip')
    --         local opts = {
    --             sources = cmp.config.sources {
    --                 { name = "nvim_lsp", },
    --                 { name = "path", },
    --                 { name = "buffer", },
    --             },
    --             mapping = cmp.mapping.preset.insert({
    --                 ["<CR>"] = cmp.mapping.confirm({ select = true }),
    --                 ["<tab>"] = cmp.mapping(function(original)
    --                     print("tab pressed")
    --                     if cmp.visible() then
    --                         print("cmp expand")
    --                         cmp.select_next_item()
    --                     elseif luasnip.expand_or_jumpable() then
    --                         print("snippet expand")
    --                         luasnip.expand_or_jump()
    --                     else
    --                         print("fallback")
    --                         original()
    --                     end
    --                 end, {"i", "s"}),
    --                 ["<S-tab>"] = cmp.mapping(function(original)
    --                     if cmp.visible() then
    --                         cmp.select_prev_item()
    --                     elseif luasnip.expand_or_jumpable() then
    --                         luasnip.jump(-1)
    --                     else
    --                         original()
    --                     end
    --                 end, {"i", "s"}),
    --
    --             })
    --         }
    --         cmp.setup(opts)
    --     end,
    -- },
    -- { "hrsh7th/cmp-nvim-lsp", lazy = true },
    -- { "hrsh7th/cmp-path", lazy = true },
    -- { "hrsh7th/cmp-buffer", lazy = true },

    {'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup{
            check_ts = true, -- Enable Tree-sitter integration
            ts_config = {
                go = { "string", "source" }, -- Specify Go file types to handle strings and source code
            },
            disable_filetype = { "TelescopePrompt", "vim" },
            fast_wrap = {},
        } end
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

--     {
--         "shaunsingh/nord.nvim",
--         config = function()
--             vim.g.nord_contrast = true
--             vim.g.nord_borders = false
--             vim.g.nord_disable_background = false
--             vim.g.nord_italic = false
--             vim.g.nord_uniform_diff_background = true
--             vim.g.nord_bold = false
--
--             require('nord').set()
--         end,
--     },

    -- {
    --     'AlexvZyl/nordic.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require 'nordic' .load()
    --     end
    -- },
    {
        'rebelot/kanagawa.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme kanagawa")
        end
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
    {
        'tpope/vim-fugitive',
        event = "VimEnter",
        config = function()
            -- Add any vim-fugitive specific configuration here
        end,
    },
})

