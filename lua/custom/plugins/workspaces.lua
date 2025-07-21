return {
    'mtfrsantos/nvim-workspaces',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
        local home = os.getenv 'HOME'
        local file_path = home .. '/workspaces.json'
        require('workspaces').setup {
            file_path = file_path,
        }
        vim.keymap.set('n', '<leader>w', '<cmd>Workspaces<cr>', { desc = 'List [W]orkspaces' })
    end,
}
