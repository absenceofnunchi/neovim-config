return {
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
    -- {
    --     'rebelot/kanagawa.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd("colorscheme kanagawa")
    --     end
    -- },


    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme catppuccin")
        end
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
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        options = {
            icons_enabled = true,
            -- theme = 'gruvbox',
            theme = 'kanagawa',
            component_separators = { left = '', right = ''},
            section_separators = { left = '', right = ''},
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            always_show_tabline = true,
            globalstatus = false,
            refresh = {
                statusline = 100,
                tabline = 100,
                winbar = 100,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = { {'filename'} },
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {{ 'filename' }},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
        config = function()
            require('lualine').setup()
        end
    }

}
