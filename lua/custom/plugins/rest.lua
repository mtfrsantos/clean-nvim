return {
    "rest-nvim/rest.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/nvim-nio",
    },
    keys = {
        { "<leader>rr", "<cmd>Rest run<cr>", desc = "[R]un request under cursor" },
        { "<leader>rf", "<cmd>Rest env select<cr>", desc = "Select env [F]ile" },
    },
    build = false,
    config = function()
        require("rest-nvim").setup({
            rocks = {
                enabled = false,
                hererocks = false,
            },
            ui = {
                winbar = true,
                keybinds = {
                    prev = "H",
                    next = "L",
                },
            },
        })
    end,
}
