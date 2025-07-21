-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
        { '<C-e>', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
        event_handlers = {
            {
                event = 'neo_tree_buffer_enter',
                handler = function()
                    vim.opt_local.relativenumber = true
                end,
            },
        },
        close_if_last_window = true,
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
            position = 'current',
        },
        filesystem = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            filtered_items = {
                visible = true,
                show_hidden_count = true,
                hide_dotfiles = false,
                hide_gitignore = false,
            },
            use_libuv_file_watcher = true,
            window = {
                mappings = {
                    ['<C-e>'] = 'close_window',
                },
            },
        },
    },
}
