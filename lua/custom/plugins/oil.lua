return {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        vim.keymap.set('n', '=', '<cmd>Oil<CR>', { desc = 'Open oil' })
        require('oil').setup {
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            keymaps = {
                ['<CR>'] = 'actions.select',
                ['<BS>'] = 'actions.parent',
                ['='] = 'actions.close',
                ['.'] = 'actions.cd',
            },
            use_default_keymaps = false,
            view_options = {
                natural_order = true,
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == '..' or name == '.git'
                end,
            },
        }
    end,
}
