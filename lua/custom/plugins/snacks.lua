return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = {
            enabled = false,
            sections = {
                { section = 'header' },
                { section = 'keys', gap = 1, padding = 1 },
                { section = 'startup' },
                { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 2 },
                {
                    section = 'terminal',
                    cmd = 'pokemon-colorscripts -r --no-title; sleep .1',
                    random = 10,
                    pane = 2,
                    indent = 4,
                    height = 30,
                },
            },
        },
        explorer = { enabled = false },
        indent = { enabled = false },
        input = { enabled = true },
        picker = { enabled = false },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
    keys = {
        {
            '<leader>n',
            function()
                Snacks.notifier.show_history()
            end,
            desc = 'Notification History',
        },
        -- {
        --     '<leader>cR',
        --     function()
        --         Snacks.rename.rename_file()
        --     end,
        --     desc = 'Rename File',
        -- },
        {
            '<leader>G',
            function()
                Snacks.lazygit()
            end,
            desc = 'Lazygit',
        },
    },
    init = function()
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option('spell', { name = '[T]oggle [S]pelling' }):map '<leader>ts'
                Snacks.toggle.option('wrap', { name = '[T]oggle [W]rap' }):map '<leader>tw'
                Snacks.toggle.option('relativenumber', { name = '[T]oggle [R]elative Number' }):map '<leader>tr'
                Snacks.toggle.diagnostics():map '<leader>td'
                -- Snacks.toggle.line_number():map '<leader>ul'
                -- Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
                -- Snacks.toggle.treesitter():map '<leader>uT'
                -- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
                -- Snacks.toggle.inlay_hints():map '<leader>uh'
                -- Snacks.toggle.indent():map '<leader>ug'
                -- Snacks.toggle.dim():map '<leader>uD'
            end,
        })
    end,
}
