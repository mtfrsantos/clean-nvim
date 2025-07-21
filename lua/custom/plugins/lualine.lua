return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'yavorski/lualine-macro-recording.nvim' },
    config = function()
        require('lualine').setup {
            options = { theme = 'horizon' },
            sections = {
                -- lualine_x = {
                --     {
                --         color = { fg = '#ff9e64' },
                --     },
                -- },
                lualine_c = { 'filename', 'macro_recording', '%S' },
            },
        }
    end,
}
